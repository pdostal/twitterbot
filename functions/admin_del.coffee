mongodb = require 'mongodb'
assert = require 'assert'

dm_send = require('./dm_send').dm_send

secret = require '../secret'

exports.admin_del = (sender_id, name) ->
  mongodb.connect secret.mongourl, (err, db) ->
    assert.equal null, err
    collection = db.collection 'admins'
    collection.findOne {name:name}, (err, doc) ->
      if doc
        collection.remove { _id: doc._id }, (err, result) ->
        dm_send sender_id, "Admin @#{name} removed."
      else
        dm_send sender_id, "User @#{name} isn't admin."
      db.close()
