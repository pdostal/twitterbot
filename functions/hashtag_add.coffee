mongodb = require 'mongodb'
assert = require 'assert'

dm_send = require('./dm_send').dm_send

secret = require '../secret'

exports.hashtag_add = (sender_id, name) ->
  mongodb.connect secret.mongourl, (err, db) ->
    assert.equal null, err
    collection = db.collection 'hashtags'
    collection.findOne {name:name}, (err, doc) ->
      if !doc
        collection.insert { name: name }
        dm_send sender_id, "Hashtag ##{name} added."
      else
        dm_send sender_id, "Hashtag ##{name} already exists."
      db.close()
