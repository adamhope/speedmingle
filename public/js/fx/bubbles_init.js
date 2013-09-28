$(document).ready(function() {
  $.getJSON('/participants/bubbles', function(data) {
    bubble(data, {width: window.innerWidth, height: window.innerHeight});
  });
});
