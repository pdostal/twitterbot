mongodb = require 'mongodb'
assert = require 'assert'

dm_send = require('./dm_send').dm_send

secret = require '../secret'

exports.ban_del = (sender_id, name) ->
  mongodb.connect secret.mongourl, (err, db) ->
    assert.equal null, err
    collection = db.collection 'bans'
    collection.findOne {name:name}, (err, doc) ->
      if doc
        collection.remove { _id: doc._id }, (err, result) ->
        dm_send sender_id, "Ban @#{name} removed."
      else
        dm_send sender_id, "Ban @#{name} isn't in database."
      db.close()
