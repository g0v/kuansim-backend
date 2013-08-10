#!/usr/bin/env lsc -cj
author:
  name: ['Chia-liang Kao']
  email: 'clkao@clkao.org'
name: 'pgrest'
description: 'enable REST in postgres'
version: '0.0.5'
main: \lib/index.js
bin:
  pgrest: 'bin/cmd.js'
repository:
  type: 'git'
  url: 'git://github.com/clkao/pgrest.git'
scripts:
  test: """
    env PATH="./node_modules/.bin:$PATH" mocha
  """
  prepublish: """
    env PATH="./node_modules/.bin:$PATH" lsc -cj package.ls &&
    env PATH="./node_modules/.bin:$PATH" lsc -bc bin &&
    env PATH="./node_modules/.bin:$PATH" lsc -bc -o lib src
    if [ -e config.ls ]; then
        env PATH="./node_modules/.bin:$PATH" lsc -cj config.ls
    fi
  """
  postinstall: """
    env PATH="./node_modules/.bin:$PATH" lsc -cj package.ls &&
    env PATH="./node_modules/.bin:$PATH" lsc -bc bin &&
    env PATH="./node_modules/.bin:$PATH" lsc -bc -o lib src
  """
  start:"""
    env PATH="./node_modules/.bin:$PATH" npm run prepublish
    env PATH="./node_modules/.bin:$PATH" ./node_modules/.bin/lsc bin/cmd.ls
  """
engines: {node: '*'}
dependencies:
  optimist: \0.3.x
  trycatch: \0.2.x
  plv8x: \0.5.x
  express: \3.1.x
  cors: \0.0.x
  \connect-csv : \*
  passport: \*
  'passport-facebook': \*
  'passport-twitter': \*
  'passport-google-oauth': \*
devDependencies:
  mocha: \*
  supertest: \0.7.x
  chai: \*
  LiveScript: \1.1.1
optionalDependencies: {}
