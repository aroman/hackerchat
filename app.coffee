express = require 'express'
sio = require 'socket.io'
http = require 'http'
path = require 'path'

mongoose = require 'mongoose'
colors = require 'colors'

models = require './models'

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
    res.render 'index', {title: 'HackerChat'}

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
  else
    user = models.User.findOne {_id: req.session.user_id}, (err, user) ->
      if err
        res.send(500, err)
      else if user is null
        req.session.user_id = undefined
        res.redirect "/"
      else
        res.render 'chats', {title: 'HackerChat', user: user}

app.get '/logout', (req, res) ->
  req.session = null
  res.redirect '/'

app.get '/chats/:id', (req, res) ->
  res.render 'chat', {title: 'HackerChat'}

io.sockets.on 'connection', (socket) ->
