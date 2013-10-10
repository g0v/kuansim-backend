# kuansim-backend
*   master [![Build Status](https://travis-ci.org/g0v/kuansim-backend.png?branch=master)](https://travis-ci.org/g0v/kuansim-backend)
*   develop [![Build Status](https://travis-ci.org/g0v/kuansim-backend.png?branch=develop)](https://travis-ci.org/g0v/kuansim-backend)

# Branch Rules
See [git-flow cheatsheet](http://danielkummer.github.io/git-flow-cheatsheet/)

*   All new code shall be push to `develop` branch
*   Release manager will merge `develop` to `master`

# Report Issue
Please report issue to <https://github.com/g0v/kuansim/issues>

# Setup EditorConfig
*   Setup [EditorConfig](http://editorconfig.org/) to ensure consistently coding style.

# Setup in debian/ubuntu

## Setup PostgreSQL
*   Add postgresql apt repository. You need to change `squeeze` to your distribution codename. You can get your system codename by `lsb_release -c`.

        sudo sh -c "echo deb http://apt.postgresql.org/pub/repos/apt/ squeeze-pgdg main > /etc/apt/sources.list.d/postgresql.list"

*   Add apt repository key

        wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

*   Update and install packages

        sudo apt-get update
        sudo apt-get install postgresql-9.2 postgresql-9.2-plv8 postgresql-server-dev-9.2

*   Update postgresql configuration

    Edit /etc/postgresql/9.2/main/pg_hba.conf. Remove the line `local all postgres peer`, and add the following lines.

        #local   all             postgres                                peer
        local   all             postgres                                trust
        host    all             postgres        127.0.0.1/32            trust

*   Restart postgresql service

        sudo service postgresql restart

*   Test postgresql

        psql -U postgres

*   Create kuansim database

        createdb kuansim -U postgres

*   Create plv8 extension

        psql -U postgres -c "create extension plv8"

## Setup Node.js
*   Use `node --version` to check the version. The version shall be >= v0.10.
    *   ubuntu user can use [PPA](https://launchpad.net/~chris-lea/+archive/node.js/) to install Node.js

            sudo add-apt-repository ppa:chris-lea/node.js
            sudo apt-get update
            sudo apt-get install nodejs

    *   Other platform can use [node version manager](https://npmjs.org/package/n) to upgrade Node.js.

            sudo npm install -g n
            sudo n stable

*   Install node.js modules

        npm install

*   Run server

        npm start

# FAQ
*   if `npm start` failed in searching "cannot find ../config.log"

    \> cp config.ls.template config.ls

*   when asking for facebook/tweeter/google's  api key/pass. change following lines in `config.ls`

```{.javascript .numberLines}
    auth_providers:
      facebook:
          clientID: "223074367841889"
          clientSecret: "e40b54d17e245b956efa85a0c4c34497"
#  twitter:
#    consumerKey: null
#    consumerSecret: null
#  google:
#    consumerKey: null
#    consumerSecret: null
```

*   make sure `postgresql` is running, and no other npm server running, apply for facebook app developer from hychen

	\> visit <http://localhost:3000/auth/facebook>, then visit <http://localhost:3000/isauthz>
	
	\> you shall now see your facebook public profile
	
# install PostgreSQL + plv8 on MAC

* install PostgreSQL App <http://postgresapp.com/>
* install 3.18.2 v8 (Assume using Homebrew) (don't use default 3.19)
  
```
	cd /usr/local
	git checkout -b v8 db3bdb1
	brew install v8 
	git checkout master
```

* the rest steps are similar to those of ubuntu's

# Reference
*   [PostgreSQL packages for Debian and Ubuntu](https://wiki.postgresql.org/wiki/Apt)
*   [How to install PostgreSQL on Ubuntu 13.04?](http://askubuntu.com/questions/287786/how-to-install-postgresql-on-ubuntu-13-04)
*   [How to upgrade the Node.js version?](http://theholmesoffice.com/node-js-fundamentals-how-to-upgrade-the-node-js-version/)
