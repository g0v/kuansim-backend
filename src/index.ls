{pgrest_param_get, pgrest_param_set} = require \pgrest

define-user-views = (plx, schema, names) ->
  names.map ->
    name = it
    console.log name
    sql = """
    CREATE OR REPLACE VIEW #{schema}.#{name} AS
      SELECT * FROM public.#{name};
    """
    <- plx.query sql

export function bootstrap(plx, cb)
  next <- plx.import-bundle-funcs \kuansim require.resolve \../package.json

  <- plx.query """
  DO $$
  BEGIN
      IF NOT EXISTS(
          SELECT schema_name
            FROM information_schema.schemata
            WHERE schema_name = 'kuansim'
        )
      THEN
        EXECUTE 'CREATE SCHEMA kuansim';
      END IF;
  END
  $$;

--- Users

      CREATE TABLE IF NOT EXISTS users (
        _id SERIAL UNIQUE,
        provider_name TEXT NOT NULL,
        provider_id TEXT NOT NULL,
        username TEXT,
        name JSON,
        display_name TEXT,
        emails JSON,
        photos JSON,
        tokens JSON
    );

--- User Preferences

CREATE TABLE IF NOT EXISTS user_prefs (
        user_id INTEGER REFERENCES USERS(_id),
        prefer_poston TEXT,
        subscriptions JSON
    );

-- Bookmarks
CREATE TABLE IF NOT EXISTS bookmarks (
       _id SERIAL UNIQUE,
       author_id INTEGER NOT NULL,
       normal_url TEXT,
       resolved_id INTEGER NOT NULL,
       resolved_type TEXT,
       date_resolved TIMESTAMP,
       date_happend TIMESTAMP,
       tags JSON,
       messages JSON,
       in_inbox BOOLEAN DEFAULT TRUE
);

-- Web Pages
CREATE TABLE IF NOT EXISTS webpages (
       _id SERIAL UNIQUE,
       permanent_url TEXT NOT NULL,
       title TEXT NOT NULL,
       summary TEXT,
       fulltext TEXT,
       date_published TIMESTAMP,
       has_images BOOLEAN DEFAULT TRUE,
       has_videos BOOLEAN DEFAULT TRUE,
       videos JSON,
       images JSON
);

-- News
CREATE TABLE IF NOT EXISTS news (
       _id SERIAL UNIQUE,
       provider TEXT NOT NULL,
       has_diffs BOOLEAN DEFAULT FALSE,
       diffs JSON,
       suggest_tags JSON
) INHERITS(webpages);

-- Tags
CREATE TABLE IF NOT EXISTS tags (
       _id SERIAL UNIQUE,
       name TEXT NOT NULL,
       author_id INTEGER NOT NULL,
       authors JSON
);

-- Messages
CREATE TABLE IF NOT EXISTS messages (
       _id SERIAL UNIQUE,
       resolved_id INTEGER NOT NULL,
       resolved_url TEXT NOT NULL,
       carrier TEXT NOT NULL,
       owner_id INTEGER NOT NULL,
       fulltext TEXT,
       tags JSON,
       people JSON
);

  """
  next ->
    define-user-views plx, \kuansim, ['bookmarks', 'tags', 'news', 'webpages']
    <- plx.query """
      CREATE OR REPLACE VIEW kuansim.users AS
      SELECT _id, username, photos FROM public.users;
      
      CREATE OR REPLACE VIEW kuansim.inbox AS
      WITH auth as (select pgrest_getauth() as auth_id)
      SELECT * FROM public.bookmarks WHERE in_inbox=true AND author_id=(SELECT auth_id FROM auth);

      CREATE OR REPLACE RULE tags_add AS ON INSERT TO kuansim.tags
      DO INSTEAD
      WITH auth as (select pgrest_getauth() as auth_id)
      INSERT INTO public.tags (name, author_id) VALUES(NEW.name, (SELECT auth_id FROM auth));      
    """
    cb!
