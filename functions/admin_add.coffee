mongodb = require 'mongodb'
assert = require 'assert'

dm_send = require('./dm_send').dm_send

secret = require '../secret'

exports.admin_add = (sender_id, name) ->
  mongodb.connect secret.mongourl, (err, db) ->
    assert.equal null, err
    collection = db.collection 'admins'
    collection.findOne {name:name}, (err, doc) ->
      if !doc
        collection.insert { name: name }
        dm_send sender_id, "Admin @#{name} added."
      else
        dm_send sender_id, "Admin @#{name} already exists."
      db.close()
