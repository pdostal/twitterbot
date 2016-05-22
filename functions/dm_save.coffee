mongodb = require 'mongodb'
assert = require 'assert'

secret = require '../secret'

exports.dm_save = (tweet) ->
  mongodb.connect secret.mongourl, (err, db) ->
    assert.equal null, err
    collection = db.collection 'directmessages'
    data =
      id: tweet.id_str, text: tweet.text,
      sender_name: tweet.sender.screen_name, sender_id: tweet.sender.id_str
    collection.insert data
    db.close()
