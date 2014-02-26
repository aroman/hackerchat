mongoose = require 'mongoose'

ChatSchema = new mongoose.Schema
  title: String
  users: [{type: mongoose.Schema.ObjectId, ref: 'user'}]
  messages: []
  code: String

UserSchema = new mongoose.Schema
  name: String
  color: String
  chats: [{type: mongoose.Schema.ObjectId, ref: 'chat'}]

module.exports =
  Chat: mongoose.model 'chat', ChatSchema
  User: mongoose.model 'user', UserSchema