``#!/usr/bin/env node``
require! {optimist, plv8x, path}


{argv} = optimist
if argv.config
  config = require (path.resolve argv.config)
else
  config = require '../config.json'

conString = argv.db or process.env['PLV8XCONN'] or process.env['PLV8XDB'] or config['db'] or process.env.TESTDBNAME or process.argv?2
unless conString
  console.log "ERROR: Please set the PLV8XDB environment variable, or pass in a connection string as an argument"
  process.exit!
{pgsock} = argv


if pgsock
  conString = do
    host: pgsock
    database: conString

pgrest = require \..
plx <- pgrest .new conString, meta: do
  'kuansim.tags': {+q}
{mount-default, mount-auth, with-prefix} = pgrest.routes!

process.exit 0 if argv.boot
{port=3000, prefix="/collections", host="127.0.0.1"} = argv
express = try require \express
throw "express required for starting server" unless express
app = express!
require! cors
require! \connect-csv

app.use express.json!
app.use connect-csv header: \guess
#app.use express.logger!

# express passport settings
if config.enable_auth? and config.enable_auth
  require! passport
  app.use express.cookieParser!
  app.use express.bodyParser!
  app.use express.methodOverride!
  app.use express.session secret: 'test'  
  app.use passport.initialize!
  app.use passport.session!
  mount-auth plx, app, config

# define user-fun
<- plx.mk-user-func "getauth():int" ':~> throw "logged out" unless plv8x.context.auth; plv8x.context.auth.auth_id'
<- plx.mk-user-func "pgrest_param():json" ':~> plv8x.context'
<- plx.mk-user-func "pgrest_param(text):int" ':~> plv8x.context?[it]'
<- plx.mk-user-func "pgrest_param(text):text" ':~> plv8x.context?[it]'
<- plx.mk-user-func "pgrest_param(json):json" ':~> plv8x.context = it'
# init session
<- plx.query '''select pgrest_param('{}'::json)'''

ensure_authz = (req, res, next) ->
  console.log "auth checking"
  if req.isAuthenticated!
    console.log "#{req.path} user is authzed. init db sesion"
    <- plx.query "select pgrest_param($1::json)", [{auth:req.user}]
  else
    console.log "#{req.path} user is not authzed. reset db session"
    <- plx.query '''select pgrest_param('{}'::json)'''
  next!

schema = argv.schema or config.schema
console.log "schema: #{schema}"

<- plx.query """
DO $$
BEGIN
    IF NOT EXISTS(
        SELECT schema_name
          FROM information_schema.schemata
          WHERE schema_name = '#{schema}'
      )
    THEN
      EXECUTE 'CREATE SCHEMA #{schema}';
    END IF;
END
$$;

CREATE OR REPLACE VIEW kuansim.inbox AS
  WITH auth as (select getauth() as auth_id)
  SELECT * FROM public.bookmarks WHERE in_inbox=true AND author_id=(SELECT auth_id FROM auth);
"""

define-user-views = (plx, schema, names) ->
  names.map ->
    name = it
    console.log name
    sql = """
    CREATE OR REPLACE VIEW #{schema}.#{name} AS
      SELECT * FROM public.#{name};
    """
    <- plx.query sql

define-user-views plx, schema, ['bookmarks', 'tags', 'news', 'webpages']

# tags
<- plx.query """
CREATE OR REPLACE RULE tags_add AS ON INSERT TO kuansim.tags
  DO INSTEAD
  WITH auth as (select getauth() as auth_id)
  INSERT INTO public.tags (name, author_id) VALUES(NEW.name, (SELECT auth_id FROM auth));
"""

cols <- mount-default plx, schema, with-prefix prefix, (path, r) ->
  args = [ensure_authz, r]
  args.unshift cors! if argv.cors
  args.unshift path
  app.all ...args
  # for debug
  app.get '/isauthz', ensure_authz, (req, res) ->
    [pgrest_param:result] <- plx.query '''select pgrest_param()'''
    row? <- plx.query "select getauth()"
    console.log row
    res.send result          

app.listen port, host
console.log "Available collections:\n#{ cols * ' ' }"
console.log "Serving `#conString` on http://#host:#port#prefix"
