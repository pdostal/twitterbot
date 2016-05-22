mongodb = require 'mongodb'
assert = require 'assert'

tw_rt = require('./tw_rt').tw_rt

secret = require '../secret'

exports.hashtag_retweet = (tweet) ->
  mongodb.connect secret.mongourl, (err1, db1) ->
    assert.equal null, err1
    mongodb.connect secret.mongourl, (err2, db2) ->
      assert.equal null, err2
      collection1 = db1.collection 'hashtags'
      collection2 = db2.collection 'users'
      collection1.find({}).toArray (err1, doc1) ->
        if doc1
          doc1.forEach (hashtag) ->
            names = tweet.text.match /#([a-z0-9_]*)/i
            names.forEach (name) ->
              if name == hashtag.name
                collection2.find({}).toArray (err2, doc2) ->
                  if doc2
                    doc2.forEach (user) ->
                      if user.name == tweet.user.screen_name
                        tw_rt tweet.id_str
                  db2.close()
        db1.close()
