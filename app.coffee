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
tw_fav = require('./functions/tw_fav').tw_fav

console.log timestamp() + 'App started'

# params = { follow: '1652780346' }
# tw.stream 'statuses/filter', params, (stream) ->
#   stream.on 'data', (tweet) ->
#     if tweet.user
#       console.log timestamp() + "@#{tweet.user.screen_name}: \"#{tweet.text}\""
#       tw_fav tweet.id_str
#
#   stream.on 'error', (error) ->
#     throw error

# setInterval ->
tw.get 'direct_messages', {}, (error, tweets, response) ->
  ifError error if error
  if tweets
    tweets.forEach (tweet) ->
      mongodb.connect secret.mongourl, (err, db) ->
        assert.equal null, err
        collection = db.collection 'directmessages'
        collection.findOne {id:tweet.id_str}, (err, doc) ->
          if !doc
            console.log timestamp() + "@#{tweet.sender.screen_name}: \"#{tweet.text}\""

            if /^ping$/i.test tweet.text
              dm_send tweet.sender.id_str, "pong"

            else if /^add admin @[a-z0-9_]*$/i.test tweet.text
              name = tweet.text.match(/^add admin @([a-z0-9_]*)$/i)
              admin_add tweet.sender.id_str, name[1]

            else if /^del admin @[a-z0-9_]*$/i.test tweet.text
              name = tweet.text.match(/^del admin @([a-z0-9_]*)$/i)
              admin_del tweet.sender.id_str, name[1]

            else
              dm_send tweet.sender.id_str, "Unknown command."

            dm_save tweet
          db.close()
# , 3000
