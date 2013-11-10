express = require 'express'
sio = require 'socket.io'
http = require 'http'
path = require 'path'

mongoose = require 'mongoose'
colors = require 'colors'

models = require './models'

TITLE = "HackerChat"
PORT = process.env.PORT || 3000

app = express()
server = http.createServer app
io = sio.listen server

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger 'dev'
app.use express.json()
app.use express.urlencoded()
app.use(express.bodyParser())
app.use(express.cookieParser())
app.use(express.cookieSession(secret: "supersecret"))
app.use express.methodOverride()
app.use app.router
app.use express.errorHandler()
app.use(require('less-middleware')({ src: __dirname + '/static', force: true, sourceMap: true }))
app.use express.static(path.join(__dirname, 'static'))

mongoose.connect 'mongodb://dbuser:pilotpwva@ds053808.mongolab.com:53808/hackerchat', ->
  console.log "Database connection established".yellow
  server.listen PORT

app.get '/', (req, res) ->
  if req.session.user_id
    res.redirect "/chats"
  else
    res.render 'index', {title: TITLE}

app.post '/', (req, res) ->
  name = req.body.name
  if name
    console.log "Got POST with name #{name}"
    user = models.User.findOne {name: name}, (err, user) ->
      if err
        res.send(500, err)
      else if user isnt null
        console.log "User NOT null!"
        req.session.user_id = user._id
        res.redirect "/chats"
      else
        console.log "User IS null!"
        user = new models.User()
        user.name = req.body.name
        user.save (err) ->
          if err
            res.send(500, err);
          req.session.user_id = user._id
          res.redirect "/chats"
  else
    res.send "You EEEEDIOT!!! YOU FORGOT THE `name` PARAM!!!"

app.get '/chats', (req, res) ->
  if not req.session.user_id
    res.redirect "/"
  user = models.User.findOne {_id: req.session.user_id}, (err, user) ->
    if err
      res.send(500, err)
    else if user is null
      req.session.user_id = undefined
      res.redirect "/"
    else
      res.render 'chats', {title: TITLE, user: user}

app.get '/new-chat', (req, res) ->
  if not req.session.user_id
    res.redirect "/"
  user = models.User.findOne {_id: req.session.user_id}, (err, user) ->
    if err
      res.send(500, err)
    else if user is null
      req.session.user_id = undefined
      res.redirect "/"
    else
      chat = new models.Chat()
      chat.user = user
      chat.save (err) ->
        if err
          res.send(500, err)
        else
          user.chats.push chat
          user.save (err) ->
            if err
              res.send(500, err)
            else
              res.redirect "/chats/#{chat._id}"

app.get '/chats/:chat_id', (req, res) ->
  if not req.session.user_id
    res.redirect "/"
  user = models.User.findOne {_id: req.session.user_id}, (err, user) ->
    if err
      res.send(500, err)
    else
        chat = models.Chat.findOne {_id: req.params.chat_id}, (err, chat) ->
          if err
            res.send(500, err)
          else 
            res.render 'chat', {title: TITLE, user: JSON.stringify(user), chat: JSON.stringify(chat)}

app.get '/logout', (req, res) ->
  req.session = null
  res.redirect '/'

io.sockets.on 'connection', (socket) ->

  room = null

  socket.on 'subscribe', (chat_id) ->
    console.log "JOINING #{chat_id}"
    socket.join chat_id
    room = chat_id

  socket.on 'msg_send', (user, msg) ->
    io.sockets.in(room).emit 'new_msg', {user: user, msg: msg}
    msg_obj = {
      username: user
      body: msg
      date: new Date().toISOString()
    }
    models.Chat.update {_id: room}, {$push: {messages: msg_obj}}, (err) ->
      if err
        console.error "ERROR SAVING MESSAGE TO CHAT #{room}: #{err}"
      else
        console.error "success"