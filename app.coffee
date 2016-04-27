async = require 'async'
moment = require 'moment'
Twitter = require 'twitter'
Sequelize = require 'sequelize'

# https://apps.twitter.com/
secret = require './secret'

sequelize = new Sequelize 'pdostalbot', 'pdostalbot', '',
  host: '172.27.27.3'
  dialect: 'postgres'
  pool:
    max: 5
    min: 0
    idle: 10000
  logging: false

Administrators = sequelize.define 'administrators',
  id: { type: Sequelize.BIGINT, primaryKey: true }
  name: { type: Sequelize.STRING }

DirectMessages = sequelize.define 'directmessages',
  id: { type: Sequelize.BIGINT, primaryKey: true }
  text: { type: Sequelize.STRING }
  screen_name: { type: Sequelize.STRING }
  sender_id: { type: Sequelize.BIGINT }

sequelize.sync().then ->
  console.log timestamp() + "Database synchronized"
.catch (error) ->
  console.log timestamp() + "Database not synchronized"

tw = new Twitter
  consumer_key: secret.consumer_key
  consumer_secret: secret.consumer_secret
  access_token_key: secret.access_token_key
  access_token_secret: secret.access_token_secret

timestamp = () ->
  moment().format 'MM. DD. YYYY hh:mm:ss '

ifError = (errors) ->
  for error, index in errors
    console.log timestamp() + "Error#{index}(#{error.code}): #{error.message}"
    send_dm '1652780346', "Error#{index}(#{error.code}): #{error.message}"

favorite = (id) ->
  console.log timestamp() + "Favorite tweet #{id}"
  params = { id: id }
  tw.post 'favorites/create', params, (error, tweet, response) ->
    ifError error if error

send_dm = (id, message) ->
  console.log timestamp() + "Direct message for #{id}"
  params = { user_id: id, text: message }
  tw.post 'direct_messages/new', params, (error, tweet, response) ->
    ifError error if error

save_dm = (tweet_id, tweet_text, sender_name, sender_id) ->
  query = {}
  DirectMessages.findOrCreate
    where: id: tweet_id
    defaults:
      sender_name: sender_name
      sender_id: sender_id
      text: tweet_text
  .spread (result, created) ->
    query.result = result
    query.created = created
  if query.created
    query.result
  else
    false

console.log timestamp() + 'App started'

setInterval ->
  tw.get 'direct_messages', {}, (error, tweets, response) ->
    ifError error if error
    if tweets
      for tweet, index in tweets
        async.series ->
          result = save_dm tweet.id_str, tweet.text, tweet.sender.screen_name, tweet.sender.id_str
          console.log result
          if result
            console.log timestamp() + "@#{result.sender_name}> \"#{result.text}\""
            # send_dm result.sender_id, "Thanks for your message"
, 15000

# http://gettwitterid.com/
tw.stream 'user', {}, (stream) ->
  stream.on 'data', (tweet) ->
    if tweet.user
      console.log timestamp() + "@#{tweet.user.screen_name}: \"#{tweet.text}\""
      favorite tweet.id_str
  stream.on 'error', (error) ->
    throw error
