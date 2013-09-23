setInterval(function () {
  $.getJSON('/participants/links', updateGraph);
}, 2000);

$(document).ready(function() {
  $.getJSON('/participants/links', function(data) {
    initGraph(data, {width: window.innerWidth, height: window.innerHeight});
  });
});
