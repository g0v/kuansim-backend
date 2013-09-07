``#!/usr/bin/env node``
require! pgrest
app <- pgrest.cli! {}, {}, [],  require \../lib
