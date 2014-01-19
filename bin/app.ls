``#!/usr/bin/env node``
{meta} = require \../lib/meta
require! pgrest
pgrest-passport = require \pgrest-passport
pgrest.use pgrest-passport

opts = pgrest.get-opts!! <<< {meta}

app <- pgrest.cli! opts, {}, [],  require \../lib

app.get '/me', (req, res) ->
  if req.isAuthenticated!
    res.send req.user
  else
    res.send 403
