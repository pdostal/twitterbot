timestamp = require('./timestamp').timestamp
twitter = require 'twitter'

secret = require '../secret'
tw = new twitter
  consumer_key: secret.consumer_key
  consumer_secret: secret.consumer_secret
  access_token_key: secret.access_token_key
  access_token_secret: secret.access_token_secret

exports.tw_fav = (id) ->
  console.log timestamp() + "Favorite tweet #{id}"
  params = { id: id }
  tw.post 'favorites/create', params, (error, tweet, response) ->
    ifError error if error
