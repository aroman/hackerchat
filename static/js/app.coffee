window.ChatView = Backbone.View.extend
  el: 'body'

  events:
    "keyup input": "onKeyUp"

  initialize: (user, chat) ->
    @chat = chat
    @user = user

    socket.on 'new_msg', (data) =>
      @onNewMsg data.user, data.msg

    socket.emit 'subscribe', @chat._id

    str = ""
    _.each chat.messages, (msg) ->
      str += "<br>#{msg.username}: #{msg.body}"
    $("#chatbox").html str

  onNewMsg: (user, msg) ->
    prev = $("#chatbox").html()
    $("#chatbox").html(prev + "<br>#{user}: #{msg}")

  onKeyUp: (e) ->
    if e.keyCode == 13
      target = $(e.target)
      @sendMessage(target.val())
      target.val('')
    else
      @onTypeFired()

  sendMessage: (message) ->
      console.log "Sending message"
      socket.emit 'msg_send', @user.name, message

  onTypeFired: () ->
    # console.log "User is typing...."