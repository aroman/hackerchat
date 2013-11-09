# This is the main app file

window.Chat = Backbone.Model.extend
  idAttribute: "_id"

  initialize: () ->
    @set unread: 0

socket = io.connect()

  # socket.on 'derp', (data) ->
  # alert "Got this from the server: #{data}"
  # socket.emit "derp", "Hello from the client"

window.AppView = Backbone.View.extend
  el: 'body'

  events:
    "keyup input": "onKeyUp"

  initialize: ->
    # Stuff goes in here
    console.log "in AppView initialize"
    name = prompt("What's your name?")
    socket.emit "auth", {event: 'new user', name: name}
    socket.on "auth", (user) ->
      console.log user

  onKeyUp: (e) ->
    if e.keyCode == 13
      @sendMessage($(e.target).val())
    else
      @onTypeFired()

  sendMessage: (message) ->
      console.log "Sending message"
      socket.emit "derp", message

  onTypeFired: () ->
    # console.log "User is typing...."