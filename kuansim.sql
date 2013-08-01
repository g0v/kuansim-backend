-- Kuansim Posgresql SQL
CREATE TABLE users (
       _id SERIAL UNIQUE,
       provider_name TEXT NOT NULL,
       provider_id TEXT NOT NULL,
       username TEXT,
       name JSON,
       display_name TEXT,
       emails JSON,
       photos JSON,
       tokens JSON,
       prefer_poston TEXT DEFAULT "kuansim",
       subscriptions JSON
);

-- Bookmarks
CREATE TABLE bookmarks (
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
CREATE TABLE webpages (
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
CREATE TABLE news (
       _id SERIAL UNIQUE,
       provider TEXT NOT NULL,
       has_diffs BOOLEAN DEFAULT FALSE,
       diffs JSON,
       suggest_tags JSON
) INHERITS(webpages);

-- Tags
CREATE TABLE tags (
       _id SERIAL UNIQUE,
       name TEXT NOT NULL,
       author_id INTEGER NOT NULL,
       authors JSON
);

-- Messages
CREATE TABLE messages (
       _id SERIAL UNIQUE,
       resolved_id INTEGER NOT NULL,
       resolved_url TEXT NOT NULL,
       carrier TEXT NOT NULL,
       owner_id INTEGER NOT NULL,
       fulltext TEXT,
       tags JSON,
       people JSON
);
