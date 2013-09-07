#!/usr/bin/env lsc -cj
#
# PgRest Configuration
#

#------------------------
# Web Server Settings
#------------------------

# http server host
host: "0.0.0.0"
# http server port
port: "3000"
# prefix
prefix: "/collections"
# cookie name
#cookiename: ''

# pgrest meta 
#meta:
#  'pgrest.info': {+fo}
#  'pgrest.member_count': {+fo}
#  'pgrest.contingent': {}
#  'pgrest.issue':
#    as: 'public.issue'
#  'pgrest.initiative':
#    as: 'public.initiative'

dbconn: "tcp://postgres@localhost"
dbname: "mydb"
dbschema: "kuansim"

#-------------------------------
# Authnication and Authorization
#-------------------------------
auth:
  enable: true
  success_redirect: "/me"
  logout_redirect: "/"
  # Active auth plugins
  plugins: ['facebook']
  providers_settings:
    facebook:
      clientID: '223074367841889'
      clientSecret: 'e40b54d17e245b956efa85a0c4c34497'
    twitter:
      consumerKey: null
      consumerSecret: null
    google:
      consumerKey: null
      consumerSecret: null
