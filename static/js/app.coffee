transformText = (text, cb) ->
  if text[0] is "\`"
    to_execute = text.slice 1
    output = eval to_execute
    cb to_execute + "<br><br>&gt;&gt; " + output
  else if text.slice(0,5) is "wget "
    to_wget = text.slice(5)
    return "<iframe src=#{to_wget}></iframe>"
  else if text.slice(0,5) is "xkcd "
    xkcd_id = text.match(/\d+/)[0]
    $.ajax({
        url: "http://dynamic.xkcd.com/api-0/jsonp/comic/#{xkcd_id}?callback=?",
        dataType: "json",
        jsonpCallback: "xkcddata",
        async: false,
        success: (data) ->
          cb "<img style='width:600px; height: auto' src='#{data.img}'>"
    }).responseText;
  else
    cb text

buildChatLine = (user, body, date, color) ->
  return "<span><span style='color:#{color}' class='userstamp'>#{user}</span>: #{body}<span class='timestamp'>#{date}</span></span>"

window.ChatView = Backbone.View.extend
  el: 'body'

  events:
    "keyup .sendbox": "onSendBoxKeyUp"
    "keyup #titleeditor": "onTitleEditorKeyUp"
    "dblclick #title": "enableEditTitle"

  initialize: (user, chat) ->
    @chat = chat
    @user = user

    socket.on 'new_msg', (data) =>
      @onNewMsg data.user, data.msg, data.date, data.color

    socket.on 'title_update', (title) =>
      @updateTitle title

    socket.emit 'subscribe', @chat._id

    if @chat.title
      @updateTitle @chat.title

    str = ""
    _.each chat.messages, (msg) ->
      str += "<br> #{buildChatLine(msg.username, msg.body, msg.date, msg.color)}"
    $("#chatbox").html str
    $("#sendbox").focus()

    $(window).on 'resize', @scrollToBottom

    $(window).load =>
      @scrollToBottom()

  enableEditTitle: ->
    title = $("#title")
    title.removeClass('animatedheader')
    title_edit_input = $("#titleeditor")
    title.hide()
    title_edit_input.show()
    title_edit_input.focus()

  onTitleEditorKeyUp: (e) ->
    title = $("#title")
    title_edit_input = $("#titleeditor")
    if e.keyCode == 13
      title.show()
      title_edit_input.hide()
    else
      new_val = title_edit_input.val()
      @updateTitle new_val
      socket.emit 'update_title', new_val

  updateTitle: (title) ->
    document.title = title
    $("#title").html(title);

  scrollToBottom: ->
    $("#chatbox").scrollTop $('#chatbox')[0].scrollHeight

  onNewMsg: (user, msg, date, color) ->
    console.log "OnNew Mesg"
    $("#chatbox").append("<br>" + buildChatLine(user, msg, date, color))
    @scrollToBottom()
    _.delay(@scrollToBottom, 250)

  onSendBoxKeyUp: (e) ->
    if e.keyCode == 13
      target = $(e.target)
      @sendMessage(target.val())
      target.val('')
    else
      @onTypeFired()

  sendMessage: (message) ->
      console.log "Sending message"
      transformText message, (le_text) => 
        console.log "transformed text: #{le_text}"
        socket.emit 'msg_send', @user.name, le_text, @user.color

  onTypeFired: () ->
    # console.log "User is typing...."