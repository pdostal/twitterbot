mongodb = require 'mongodb'
assert = require 'assert'

secret = require '../secret'

exports.tw_save = (tweet) ->
  mongodb.connect secret.mongourl, (err, db) ->
    assert.equal null, err
    collection = db.collection 'tweets'
    data =
      id: tweet.id_str, text: tweet.text,
      sender_name: tweet.user.screen_name, sender_id: tweet.user.id_str
    collection.insert data
    db.close()
