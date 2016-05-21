moment = require 'moment'
twitter = require 'twitter'
mongodb = require('mongodb').MongoClient
mongourl = 'mongodb://172.27.27.3/pdostalbot'
assert = require 'assert'

# https://apps.twitter.com/
secret = require './secret'

tw = new twitter
  consumer_key: secret.consumer_key
  consumer_secret: secret.consumer_secret
  access_token_key: secret.access_token_key
  access_token_secret: secret.access_token_secret

timestamp = () ->
  moment().format 'MM. DD. YYYY hh:mm:ss '

ifError = (errors) ->
  for error, index in errors
    console.log timestamp() + "Error#{index}(#{error.code}): #{error.message}"
    directmessage '1652780346', "Error#{index}(#{error.code}): #{error.message}"

fav = (id) ->
  console.log timestamp() + "Favorite tweet #{id}"
  params = { id: id }
  tw.post 'favorites/create', params, (error, tweet, response) ->
    ifError error if error

dm_save = (tweet) ->
  mongodb.connect mongourl, (err, db) ->
    assert.equal null, err
    collection = db.collection 'directmessages'
    collection.findOne {id:tweet.id_str}, (err, doc) ->
      if !doc
        data =
          id: tweet.id_str, text: tweet.text,
          sender_name: tweet.sender.screen_name, sender_id: tweet.sender.id_str
        collection.insert data
        db.close()
        true
      else
        false


dm_send = (id, message) ->
  console.log timestamp() + "Direct message for #{id}"
  params = { user_id: id, text: message }
  tw.post 'direct_messages/new', params, (error, tweet, response) ->
    ifError error if error

console.log timestamp() + 'App started'

# http://gettwitterid.com/
# params = { follow: '1652780346' }
# tw.stream 'statuses/filter', params, (stream) ->
#   stream.on 'data', (tweet) ->
#     if tweet.user
#       console.log timestamp() + "@#{tweet.user.screen_name}: \"#{tweet.text}\""
#       fav tweet.id_str
#
#   stream.on 'error', (error) ->
#     throw error

setInterval ->
  tw.get 'direct_messages', {}, (error, tweets, response) ->
    ifError error if error
    if tweets
      for tweet, index in tweets
        if dm_save tweet
          console.log 'SAVED'
          dm_send tweet.sender.id_str, "Thanks for your message"
        else
          console.log 'OLD'
, 3000
