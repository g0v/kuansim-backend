``#!/usr/bin/env node``
require! {optimist, plv8x, passport}
config = require '../config.json'

mount-auth = (app, config) ->
  #@FIXME: add acl in db level.
  users = {}
  for provider_name, provider_cfg of config.auth_providers
    # passport settings
    provider_cfg['callbackURL'] = "#{config.host}/auth/#{provider_name}/callback"    
    cb_after_auth = (token, tokenSecret, profile, done) ->
      users[profile.id] = profile
      done null, profile
    module_name = switch provider_name
                  case \google then "passport-google-oauth"
                  default "passport-#{provider_name}"
    _Strategy = require(module_name).Strategy
    passport.use new _Strategy provider_cfg, cb_after_auth
    passport.serializeUser (user, done) -> done null, user
    passport.deserializeUser (id, done) -> done null, id

    # express settings
    app.use passport.initialize!
    app.use passport.session!
    app.get "/auth/#{provider_name}", (passport.authenticate "#{provider_name}", provider_cfg.scope)
    _auth = passport.authenticate "#{provider_name}", {successRedirect: '/', failureRedirect: "/auth/#{provider_name}"}
    app.get "/auth/#{provider_name}/callback", _auth
    app.get "/login", (req, res) -> res.send "give it oauth path."
    #@FIXME: logout does not delete session.
    app.get "/logout", (req, res) -> res.logout!; res.redirect config.logout_redirect

    #@FIXME: setup protected resource
    app.all "/collections", (req, res, next) -> if req.isAuthenticated! then next! else res.redirect '/login'
  app

{argv} = optimist
conString = argv.db or process.env['PLV8XCONN'] or process.env['PLV8XDB'] or process.env.TESTDBNAME or process.argv?2
unless conString
  console.log "ERROR: Please set the PLV8XDB environment variable, or pass in a connection string as an argument"
  process.exit!
{pgsock} = argv

if pgsock
  conString = do
    host: pgsock
    database: conString

pgrest = require \..
plx <- pgrest .new conString, {}
{mount-default,with-prefix} = pgrest.routes!

process.exit 0 if argv.boot
{port=3000, prefix="/collections", host="127.0.0.1"} = argv
express = try require \express
throw "express required for starting server" unless express
app = express!
require! cors
require! \connect-csv

app.use express.json!
app.use connect-csv header: \guess

cols <- mount-default plx, argv.schema, with-prefix prefix, (path, r) ->
  mount-auth app, config
  app.all path, cors!, r

app.listen port, host
console.log "Available collections:\n#{ cols * ' ' }"
console.log "Serving `#conString` on http://#host:#port#prefix"
