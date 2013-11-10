// Single-page routing + template inheritance == sadface?
var path = location.pathname;
if (path.indexOf("/app") != -1) {
  path = "/";
}
var link = $("a[href='" + path + "']");
link.parent().addClass('active');

$(window).resize(function() {
    $('#chatbox').height(
        $(window).height() - $('window').height() - 330
    );

});

$(document).ready(function() {
    $('#chatbox').height(
        $(.nameprompt).height() - $('window').height() - 330
    );
});

$(window).resize(function() {
    $('.sendbox').width(
        $(window).width() - $('.nameprompt').width() - 65
    );
});


$(document).ready(function() {
    $('.sendbox').width(
        $(.nameprompt).width() - $('.nameprompt').width() - 65
    );
});