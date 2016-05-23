require('better-require')()
twitter = require 'twitter'
mongodb = require 'mongodb'
assert = require 'assert'

secret = require './secret'
tw = new twitter
  consumer_key: secret.consumer_key
  consumer_secret: secret.consumer_secret
  access_token_key: secret.access_token_key
  access_token_secret: secret.access_token_secret

timestamp = require('./functions/timestamp').timestamp
ifError = require('./functions/ifError').ifError
dm_send = require('./functions/dm_send').dm_send
dm_save = require('./functions/dm_save').dm_save
admin_add = require('./functions/admin_add').admin_add
admin_del = require('./functions/admin_del').admin_del
hashtag_add = require('./functions/hashtag_add').hashtag_add
hashtag_del = require('./functions/hashtag_del').hashtag_del
user_add = require('./functions/user_add').user_add
user_del = require('./functions/user_del').user_del
tw_save = require('./functions/tw_save').tw_save
tw_fav = require('./functions/tw_fav').tw_fav
tw_rt = require('./functions/tw_rt').tw_rt
hashtag_retweet = require('./functions/hashtag_retweet').hashtag_retweet

console.log timestamp() + 'App started'

# setInterval ->
#   mongodb.connect secret.mongourl, (err, db) ->
#     assert.equal null, err
#     collection = db.collection 'hashtags'
#     collection.find({}).toArray (err, doc) ->
#       if doc
#         doc.forEach (hashtag) ->
#           params = { q: "##{hashtag.name}", result_type: "recent", count: 20 }
#           tw.get 'search/tweets', params, (error, tweets, response) ->
#             ifError error if error
# 
#             if tweets.statuses.length >= 1
#               tweets.statuses.forEach (tweet) ->
#                 mongodb.connect secret.mongourl, (err, db) ->
#                   assert.equal null, err
#                   collection = db.collection 'tweets'
#                   collection.findOne {id:tweet.id_str}, (err, doc) ->
#                     if !doc
#                       console.log timestamp() + "@#{tweet.user.screen_name}: \"#{tweet.text}\""
#
#                       hashtag_retweet tweet
#
#                       tw_save tweet
#                     db.close()
# , 15000

# setInterval ->
#   tw.get 'direct_messages', {}, (error, tweets, response) ->
#     ifError error if error
#     if tweets
#       tweets.forEach (tweet) ->
#         mongodb.connect secret.mongourl, (err, db) ->
#           assert.equal null, err
#           collection = db.collection 'directmessages'
#           collection.findOne {id:tweet.id_str}, (err, doc) ->
#             if !doc
#               console.log timestamp() + "@#{tweet.sender.screen_name}: \"#{tweet.text}\""
#
#               if /^ping$/i.test tweet.text
#                 dm_send tweet.sender.id_str, "pong"
#
#               else if /^add admin @[a-z0-9_]*$/i.test tweet.text
#                 name = tweet.text.match(/^add admin @([a-z0-9_]*)$/i)
#                 admin_add tweet.sender.id_str, name[1]
#
#               else if /^del admin @[a-z0-9_]*$/i.test tweet.text
#                 name = tweet.text.match(/^del admin @([a-z0-9_]*)$/i)
#                 admin_del tweet.sender.id_str, name[1]
#
#               else if /^add hashtag #[a-z0-9_]*$/i.test tweet.text
#                 name = tweet.text.match(/^add hashtag #([a-z0-9_]*)$/i)
#                 hashtag_add tweet.sender.id_str, name[1]
#
#               else if /^del hashtag #[a-z0-9_]*$/i.test tweet.text
#                 name = tweet.text.match(/^del hashtag #([a-z0-9_]*)$/i)
#                 hashtag_del tweet.sender.id_str, name[1]
#
#               else if /^add user @[a-z0-9_]*$/i.test tweet.text
#                 name = tweet.text.match(/^add user @([a-z0-9_]*)$/i)
#                 user_add tweet.sender.id_str, name[1]
#
#               else if /^del user @[a-z0-9_]*$/i.test tweet.text
#                 name = tweet.text.match(/^del user @([a-z0-9_]*)$/i)
#                 user_del tweet.sender.id_str, name[1]
#
#               else
#                 dm_send tweet.sender.id_str, "Unknown command."
#
#               dm_save tweet
#             db.close()
# , 15000
