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

COLOR_ID = 0

getSaneColor = ->
  sane_colors = [
    "#FFD350"
    "#FF8250"
    "#6464F1"
    "#4BF0A9"
  ]
  to_return = sane_colors[COLOR_ID]
  COLOR_ID += 1
  if COLOR_ID == sane_colors.length
    COLOR_ID = 0
  return to_return

ensureSession = (req, res, next) ->
  if not req.session.user_id
    res.redirect "/?whence=#{req.url}"
  else
    next()

app.get '/', (req, res) ->
  if req.session.user_id
    res.redirect "/chats"
  else
    res.render 'index', {title: TITLE}

app.post '/', (req, res) ->
  name = req.body.name
  whence = req.query.whence

  doRedirect = ->
    if whence
      res.redirect whence
    else
      res.redirect "/chats"

  if name
    console.log "Got POST with name #{name}"
    user = models.User.findOne {name: name}, (err, user) ->
      if err
        res.send(500, err)
      if user isnt null
        console.log "User NOT null!"
        req.session.user_id = user._id
        doRedirect()
      else
        console.log "User IS null!"
        user = new models.User()
        user.name = req.body.name
        user.color = getSaneColor()
        console.log user
        user.save (err) ->
          if err
            res.send(500, err);
          req.session.user_id = user._id
          doRedirect()

  else
    res.send "You EEEEDIOT!!! YOU FORGOT THE `name` PARAM!!!"

app.get '/chats', ensureSession, (req, res) ->
  user = models.User.findOne {_id: req.session.user_id}, (err, user) ->
    if err
      res.send(500, err)
    else if user is null
      req.session.user_id = undefined
      res.redirect "/"
    else
      res.render 'chats', {title: TITLE, user: user}

app.get '/new-chat', ensureSession, (req, res) ->
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

app.get '/chats/:chat_id', ensureSession, (req, res) ->
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

  socket.on 'msg_send', (user, msg, color) ->
    date = new Date().toISOString()
    io.sockets.in(room).emit 'new_msg', {user: user, msg: msg, date: date, color: color}
    msg_obj = {
      username: user
      body: msg
      date: date
      color: color
    }
    models.Chat.update {_id: room}, {$push: {messages: msg_obj}}, (err) ->
      if err
        console.error "ERROR SAVING MESSAGE TO CHAT #{room}: #{err}"
      else
        console.error "success"