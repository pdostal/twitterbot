moment = require 'moment'
twitter = require 'twitter'

tw = new twitter
  consumer_key: 'K9UJACpvOJMeGYsjPTMvxeHgW'
  consumer_secret: 'LiJVBgjSg1uWGfT9jMt8NCaITBlResinZIwdFGk0qrabshaPkB'
  access_token_key: '718563598008721409-lWsbzow3Ha8ay57yRRJwbFdDfhAIDu6'
  access_token_secret: 'eqb3H2HnNN3QZiezRBZdd57ubjczwhSiRR2NZNYU4mKyf'

timestamp = () ->
  moment().format 'MM. DD. YYYY hh:mm:ss '

console.log timestamp() + 'App started'

# http://gettwitterid.com/
params = { follow: '1652780346,2282016907,22844469,520207620,258508875' }
tw.stream 'statuses/filter', params, (stream) ->
  stream.on 'data', (tweet) ->
    if tweet.user && tweet.user.screen_name != 'pdostalbot'
        console.log timestamp() + "@#{tweet.user.screen_name}: \"#{tweet.text}\""

        params = { id: tweet.id }
        tw.post 'favorites/create', params, (error, tweet, response) ->
          if(error) throw error

  stream.on 'error', (error) ->
    throw error

# params = { status: "@#{tweet.user.screen_name} baf! To je rychlovka co?? Kdyztak odpovez \"stop\"...", in_reply_to_status_id: tweet.id }
# tw.post 'statuses/update', params, (error, tweet, response) ->
#   if error
#     throw error
#   else
#     console.log timestamp() + "#{tweet.id} #{tweet.user.screen_name} #{tweet.text}"

# tw.get 'statuses/user_timeline', screen_name: 'pdostal_en', (error, tweets, response) ->
#   if !error
#     console.log tweets
