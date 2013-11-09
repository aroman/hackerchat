// Single-page routing + template inheritance == sadface?
var path = location.pathname;
if (path.indexOf("/app") != -1) {
  path = "/";
}
var link = $("a[href='" + path + "']");
link.parent().addClass('active');