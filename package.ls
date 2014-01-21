#!/usr/bin/env lsc -cj
author:
  name: ['Chen Hsin-Yi']
  email: 'ossug.hychen@gmail.com'
name: 'kuansim-backend'
description: 'Kuansim Backend'
version: '0.0.1'
main: \lib/index.js
bin:
  kuansim: 'bin/app.js'
repository:
  type: 'git'
  url: 'git://github.com/g0v/kuansim-backend.git'
scripts:
  test: """
    env PATH="./node_modules/.bin:$PATH" mocha
  """
  prepublish: """
    env PATH="./node_modules/.bin:$PATH" lsc -cj package.ls &&
    env PATH="./node_modules/.bin:$PATH" lsc -bc bin/app.ls &&
    env PATH="./node_modules/.bin:$PATH" lsc -bc -o lib src
    if [ -e config.ls ]; then
        env PATH="./node_modules/.bin:$PATH" lsc -cj config.ls
    fi
  """
  postinstall: """
    env PATH="./node_modules/.bin:$PATH" lsc -cj package.ls &&
    env PATH="./node_modules/.bin:$PATH" lsc -bc bin/app.ls &&
    env PATH="./node_modules/.bin:$PATH" lsc -bc -o lib src
  """
  start:"""
    env PATH="./node_modules/.bin:$PATH" npm run prepublish
    env PATH="./node_modules/.bin:$PATH" ./node_modules/.bin/lsc bin/app.ls --config config.json
  """
engines: {node: '*'}
dependencies:
  pgrest: \0.1.x
  'pgrest-passport': \0.0.x
  optimist: \0.3.x
  trycatch: \0.2.x
  plv8x: \0.5.x
  express: \3.4.x
  cors: \0.0.x
  \connect-csv : \*
  passport: \*
  'passport-facebook': \*
  'passport-twitter': \*
  'passport-google-oauth': \*
devDependencies:
  mocha: \1.14.x
  supertest: \0.7.x
  chai: \*
  LiveScript: \1.1.1
optionalDependencies: {}
