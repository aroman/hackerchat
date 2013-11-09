# This is the main app file

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
    socket.emit "derp", "Hello from AppView!"

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