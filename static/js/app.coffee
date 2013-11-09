# This is the main app file

window.Chat = Backbone.Model.extend
  idAttribute: "_id"

  initialize: () ->
    @set unread: 0

socket = io.connect()

  # socket.on 'derp', (data) ->
  # alert "Got this from the server: #{data}"
  # socket.emit "derp", "Hello from the client"

window.killBrain = ->
  localStorage.removeItem("user")
  console.log "The deed is done"

window.AppView = Backbone.View.extend
  el: 'body'

  events:
    "keyup input": "onKeyUp"

  initialize: ->
    user = localStorage.getItem("user")
    if _.isNull(user)
      console.log "User is NEW, we must auth!"
      socket.emit "derp", "Data"
      namebox = $("#namebox")
      namebox.keyup (e) ->
        if e.keyCode == 13
          socket.emit "auth", {event: 'new user', name: namebox.val()}
          socket.on "auth", (new_usr) ->
            console.log new_usr
            localStorage.setItem("user", JSON.stringify(new_usr))
    else
      user = JSON.parse(user)
      console.log user
      console.log "Welcome back, #{user.name}"

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