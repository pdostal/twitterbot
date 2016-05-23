require('better-require')()
mongodb = require 'mongodb'
assert = require 'assert'

secret = require './secret'

timestamp = require('./functions/timestamp').timestamp

console.log timestamp() + 'Seeding'

mongodb.connect secret.mongourl, (err, db) ->
  assert.equal null, err
  collection = db.collection 'admins'
  collection.insert { name: 'pdostal_test' }
  console.log timestamp() + "Seeded collection admins"
  db.close()

mongodb.connect secret.mongourl, (err, db) ->
  assert.equal null, err
  collection = db.collection 'users'
  collection.insert { name: 'pdostal_test' }
  console.log timestamp() + "Seeded collection users"
  db.close()

mongodb.connect secret.mongourl, (err, db) ->
  assert.equal null, err
  collection = db.collection 'hashtags'
  collection.insert { name: 'testbot' }
  console.log timestamp() + "Seeded collection hashtags"
  db.close()

mongodb.connect secret.mongourl, (err, db) ->
  assert.equal null, err
  collection = db.collection 'bans'
  collection.insert { name: 'twitter' }
  console.log timestamp() + "Seeded collection bans"
  db.close()

mongodb.connect secret.mongourl, (err, db) ->
  assert.equal null, err
  collection = db.collection 'tweets'
  collection.insert { id: 1, text: "", sender_name: "", sender_id: 1 }
  console.log timestamp() + "Seeded collection tweets"
  db.close()

mongodb.connect secret.mongourl, (err, db) ->
  assert.equal null, err
  collection = db.collection 'messages'
  collection.insert { id: 1, text: "", sender_name: "", sender_id: 1 }
  console.log timestamp() + "Seeded collection messages"
  db.close()
