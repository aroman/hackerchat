// Single-page routing + template inheritance == sadface?
var path = location.pathname;
if (path.indexOf("/app") != -1) {
  path = "/";
}
var link = $("a[href='" + path + "']");
link.parent().addClass('active');

/**
 * Dynamic Chatbox Sizing
 * @author Victor
 */
 $(document).ready(function() {
  $('#chatbox').height(
    $(window).height() - $('window').height() - 350
  );
});

$(window).resize(function() {
  $('#chatbox').height(
    $(window).height() - $('window').height() - 350
  );
});

/**
 * Demo for HTML5 Notification API
 * @targets webkit (chrome, safari, midori)
 * @author Paul
 */
 (function($) {
  $(document).ready(function() {
    init_document();
  });

    function init_document()
    {
      // Check browser support
      check_browser_support();
      // Request permission
      $('#ask_permission').on("click", request_permission);
      // Check if we have permission
      check_permission();
    }

    function check_browser_support()
    {
      if(!window.webkitNotifications){
        $('#message').removeClass()
        $('#notification_demo').hide();
        // .addClass("alert alert-error")
        // .text("Your browser does not support the Notification API please use Chrome for the demo.");
      }
      else 
      {
        $('#message').removeClass()
        $('#notification_demo').hide();

        // .addClass("alert alert-success")
        // .text("Your browser does support the Notification API.");
      }
    }
    function browser_support_notification()
    {
      if (window.webkitNotifications) {
        return true;
      }
      else {
        return false;
      }
    }
    function request_permission()
    {
      // 0 means permission to display notifications
      if (window.webkitNotifications.checkPermission() != 0) {
        window.webkitNotifications.requestPermission(check_permission);
        }
    }
    function check_permission() 
    {
      switch(window.webkitNotifications.checkPermission()) {
      case 0:
        // Continue
        $('#ask_permission').addClass('hidden');
        $('.half').removeClass('hidden');
        return true;
        break;
      case 2:
        $('#message').removeClass()
        .text("You have denied access to display notifications.");
        $('.half').addClass('hidden');
      break;
      default:
        // Fail
        $('#ask_permission').fadeIn();
        $('.half').addClass('hidden');
        return false;
        break;
      }
    }

    function plain_text_notification(image, title, content)
    {
      if (window.webkitNotifications.checkPermission() == 0) {
        return window.webkitNotifications.createNotification(image, title, content);
      }
    }

    function html_notification(url)
    {
      if (window.webkitNotifications.checkPermission() == 0) {
        return window.webkitNotifications.createHTMLNotification(url);
      }
    }
})(jQuery);
// notification.onshow = function() { setTimeout(notification.cancel, 1500) }
// jQuery(document).on('focus click', 'input',  function(e){
//         console.log("focused on " + $(e.target).attr('name'));
//         notification.cancel
// });