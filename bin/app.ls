``#!/usr/bin/env node``
require! pgrest
pgrest-passport = require \pgrest-passport
pgrest.use pgrest-passport

app <- pgrest.cli! {}, {}, [],  require \../lib

app.get '/me', (req, res) ->
  if req.isAuthenticated!
    res.send req.user
  else
    res.send 403
