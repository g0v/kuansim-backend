-- Kuansim Posgresql SQL
CREATE TABLE users (
       _id SERIAL UNIQUE,
       provider_name TEXT,
       provider_id TEXT,
       username TEXT,
       name JSON,
       display_name TEXT,
       emails JSON,
       photos JSON
);

-- Bookmarks
CREATE TABLE bookmarks (
       _id SERIAL UNIQUE,
       author_id INT,
       author JSON,
       normal_url TEXT,
       resolved_id INT,
       resolved_type TEXT,
       resolved_item JSON,
       in_inbox boolean DEFAULT TRUE
);

-- Web Pages
CREATE TABLE webpages (
       _id SERIAL UNIQUE,
       permanent_url TEXT,
       title TEXT,
       summary TEXT,
       date_published DATE
);

-- News
CREATE TABLE news (
       _id serial unique,
       provider TEXT,
       has_diffs BOOLEAN,
       suggest_tags JSON
) INHERITS(webpages);

-- Tags
CREATE TABLE tags (
       _id SERIAL UNIQUE,
       name TEXT,
       author_id INT,
       author JSON
);
