moment = require 'moment'
twitter = require 'twitter'

# https://apps.twitter.com/
secret = require './secret'

tw = new twitter
  consumer_key: secret.consumer_key
  consumer_secret: secret.consumer_secret
  access_token_key: secret.access_token_key
  access_token_secret: secret.access_token_secret

timestamp = () ->
  moment().format 'MM. DD. YYYY hh:mm:ss '

console.log timestamp() + 'App started'

# http://gettwitterid.com/
params = { follow: '1652780346,2282016907,22844469,520207620,258508875' }
tw.stream 'statuses/filter', params, (stream) ->
  stream.on 'data', (tweet) ->
    if tweet.user && tweet.user.screen_name != 'pdostalbot'
        console.log timestamp() + "@#{tweet.user.screen_name}: \"#{tweet.text}\""

        params = { id: tweet.id_str }
        tw.post 'favorites/create/', params, (error, tweet, response) ->
          if error
            throw error

  stream.on 'error', (error) ->
    throw error
