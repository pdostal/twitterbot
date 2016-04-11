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

Administrators = sequelize.define 'administrators',
  id: { type: Sequelize.INTEGER, primaryKey: true }
  name: { type: Sequelize.STRING }

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
    directmessage '1652780346', "Error#{index}(#{error.code}): #{error.message}"

favorite = (id) ->
  console.log timestamp() + "Favorite tweet #{id}"
  params = { id: id }
  tw.post 'favorites/create', params, (error, tweet, response) ->
    ifError error if error

directmessage = (id, message) ->
  console.log timestamp() + "Direct message for #{id}"
  params = { user_id: id, text: message }
  tw.post 'direct_messages/new', params, (error, tweet, response) ->
    ifError error if error

console.log timestamp() + 'App started'

# http://gettwitterid.com/
params = { follow: '1652780346' }
tw.stream 'statuses/filter', params, (stream) ->
  stream.on 'data', (tweet) ->
    if tweet.user
      console.log timestamp() + "@#{tweet.user.screen_name}: \"#{tweet.text}\""
      favorite tweet.id_str

  stream.on 'error', (error) ->
    throw error
