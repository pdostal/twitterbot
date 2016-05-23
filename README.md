# twitterbot

Twitter bot written in NodeJS

## How to run
1. Create `secret.json`
2. Compile coffee
3. Profit !

## Twitter ID's
* Obtain it [here](http://gettwitterid.com/)

## Functions
* global methods
  * **timestamp**
  * ifError
* old events handling
  * **dm_save**
  * **tw_save**
* twitter actions
  * **dm_send**
  * **tw_fav**
  * **tw_rt**
* complex structures
  * **hashtag_retweet**
* direct message commands
  * **hashtag_add** `add hashtag #hashtag`
  * **hashtag_del** `del hashtag #hashtag`
  * **admin_add** `add admin @user`
  * **admin_del** `del admin @user`
  * **user_add** `add user @user`
  * **user_del** `add user @user`
  * **ban_add** `add ban @user`
  * **ban_del** `del ban @user`

## Database
* **tweets** - received tweets
* **messages** - received direct messages
* **admins** - list of admins permited to change settings
* **users** - list of users who can be retweeted
* **bans** - list of bans
* **hashtags** - list of hashtags which can be retweeted
