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
