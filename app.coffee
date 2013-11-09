express = require 'express'
http = require 'http'
path = require 'path'

colors = require 'colors'
mongoose = require 'mongoose'

models = require './models'

app = express()

app.set 'port', process.env.PORT || 3000
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger('dev')
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, 'static'))
app.use express.errorHandler()

app.get '/', (req, res) ->
  res.render 'index', {title: 'HackerChat'}

app.get '/app', (req, res) ->
  res.render 'app', {title: 'HackerChat'}

mongoose.connect 'mongodb://dbuser:pilotpwva@ds053808.mongolab.com:53808/hackerchat', ->
  console.log "Database connection established".yellow
  http.createServer(app).listen app.get('port'), ->
    port = app.get("port")
    console.log "HackerChat locked & loaded on port #{port}".yellow