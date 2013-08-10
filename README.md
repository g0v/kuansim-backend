# kuansim-backend
*   master [![Build Status](https://travis-ci.org/g0v/kuansim-backend.png?branch=master)](https://travis-ci.org/g0v/kuansim-backend)
*   develop [![Build Status](https://travis-ci.org/g0v/kuansim-backend.png?branch=develop)](https://travis-ci.org/g0v/kuansim-backend)

# Branch Rules
See [git-flow cheatsheet](http://danielkummer.github.io/git-flow-cheatsheet/)

*   All new code shall be push to `develop` branch
*   Release manager will merge `develop` to `master`

# Setup in debian/ubuntu
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

*   Import database schema

        psql -U postgres -f kuansim.sql

*   Install node.js modules

        npm install

# Reference
*   [PostgreSQL packages for Debian and Ubuntu](https://wiki.postgresql.org/wiki/Apt)
*   [How to install PostgreSQL on Ubuntu 13.04?](http://askubuntu.com/questions/287786/how-to-install-postgresql-on-ubuntu-13-04)
