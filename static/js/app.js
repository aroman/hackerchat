var buildChatLine, root, transformText;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

window.hacks = [];

window.TURNED_ON = false;

transformText = function(text, cb) {
  var output, to_execute, to_wget, xkcd_id;
  if (text.slice(0, 6) === "<hack>") {
    $('#hackmodal').modal({
      backdrop: 'static'
    });
    return $("#hackmodal").on('shown.bs.modal', function() {
      return window.editor.refresh();
    });
  } else if (text[0] === "\`") {
    if (TURNED_ON) {
      to_execute = text.slice(1);
      output = eval(to_execute);
      return cb(to_execute + "<br>&gt;&gt; " + output);
    } else {
      return cb(text);
    }
  } else if (text.slice(0, 5) === "clear") {
    $("#chatbox").append("<span style='height:500px;width:100px; color:red'></span>");
    window.chat.scrollToBottom();
    return $(".sendbox").val('');
  } else if (text.slice(0, 5) === "wget ") {
    to_wget = text.slice(5);
    if (to_wget.slice(0, 4) !== "http") {
      to_wget = "http://" + to_wget;
    }
    return cb("<iframe style='width:100%; height: 350px' sandbox='sandbox', frameborder=0, src=" + to_wget + "></iframe>");
  } else if (text.slice(0, 5) === "xkcd ") {
    xkcd_id = text.match(/\d+/)[0];
    return $.ajax({
      url: "http://dynamic.xkcd.com/api-0/jsonp/comic/" + xkcd_id + "?callback=?",
      dataType: "json",
      jsonpCallback: "xkcddata",
      async: false,
      success: function(data) {
        return cb("<img style='width:600px; height: auto' src='" + data.img + "'/>");
      }
    }).responseText;
  } else {
    return cb(text);
  }
};

buildChatLine = function(user, body, date, color) {
  date = moment(date).format('h:mm a');
  return "<span><span style='color:" + color + "' class='userstamp'>" + user + "</span><span class='timestamp'>" + date + "</span>: " + body + "</span>";
};

$("#propogate-hack").click(function() {
  var hack_body;
  console.log("PROPOGATING HACK TO SERVER");
  hack_body = editor.doc.getValue();
  socket.emit("propogate_hack", hack_body);
  return $("#hackmodal").modal('hide');
});

window.ChatView = Backbone.View.extend({
  el: 'body',
  events: {
    "keyup .sendbox": "onSendBoxKeyUp",
    "click .sendbutton": "sendFromButton",
    "keyup #title": "onTitleEditorKeyUp"
  },
  initialize: function(user, chat) {
    var str,
      _this = this;
    this.chat = chat;
    this.user = user;
    socket.on('new_msg', function(data) {
      return _this.onNewMsg(data.user, data.msg, data.date, data.color);
    });
    socket.on('title_update', function(title) {
      return _this.updateTitle(title);
    });
    socket.emit('subscribe', this.chat._id);
    socket.on("new_hack", function(hack_body) {
      console.log("RECIEVED HACK!!");
      window.hacks.push(hack_body);
      console.log("window.hacks is below");
      console.log(window.hacks);
      return window.TURNED_ON = true;
    });
    if (this.chat.title) {
      this.updateTitle(this.chat.title);
    }
    str = "";
    _.each(chat.messages, function(msg) {
      return str += "<span class='prevmsg'>" + (buildChatLine(msg.username, msg.body, msg.date, msg.color)) + "</span>";
    });
    $("#chatbox").html(str);
    window.editor = CodeMirror.fromTextArea($('textarea')[0], {
      mode: "text/javascript",
      theme: 'monokai',
      lineNumbers: true,
      matchBrackets: true
    });
    $(window).on('resize', this.scrollToBottom);
    $(window).load(function() {
      return _this.scrollToBottom();
    });
    return $(".sendbox").focus();
  },
  onTitleEditorKeyUp: function(e) {
    var new_val, title;
    title = $("#title");
    new_val = title.val();
    socket.emit('update_title', new_val);
    return document.title = new_val;
  },
  updateTitle: function(title) {
    document.title = title;
    return $("#title").val(title);
  },
  scrollToBottom: function() {
    return $("#chatbox").scrollTop($('#chatbox')[0].scrollHeight);
  },
  onNewMsg: function(user, msg, date, color) {
    var notification;
    console.log("OnNew Mesg");
    $("#chatbox").append("<br>" + buildChatLine(user, msg, date, color));
    this.scrollToBottom();
    _.delay(this.scrollToBottom, 250);
    notification = window.webkitNotifications.createNotification('/img/favicon.png', user, msg);
    notification.show();
    return notification.ondisplay(function() {
      return delay(1000, function() {
        return notification.cancel();
      });
    });
  },
  sendFromButton: function() {
    this.sendMessage($(".sendbox").val());
    return $(".sendbox").val('');
  },
  onSendBoxKeyUp: function(e) {
    var target, target_val;
    target = $(e.target);
    target_val = target.val();
    if (target_val) {
      $(".sendbutton").prop('disabled', false);
    } else {
      $(".sendbutton").prop('disabled', true);
    }
    if (e.keyCode === 13) {
      target = $(e.target);
      target_val = target.val();
      if (!target_val) {
        return;
      }
      this.sendMessage(target_val);
      return target.val('');
    } else {
      return this.onTypeFired();
    }
  },
  sendMessage: function(message) {
    var _this = this;
    console.log("Sending message");
    return transformText(message, function(le_text) {
      console.log("transformed text: " + le_text);
      return socket.emit('msg_send', _this.user.name, le_text, _this.user.color);
    });
  },
  onTypeFired: function() {}
});
