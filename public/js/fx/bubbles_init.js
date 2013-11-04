var bubbleChart = function() {
  var graph = new bubble({width: $(".visualization").width(), height: $(".visualization").innerHeight() });

  $.getJSON('/participants/bubbles', function(data) {
    graph.init(data);
  });

  setInterval(function () {
    $.getJSON('/participants/bubbles', graph.update);
  }, 2000);
};

$(document).ready(function() {
  bubbleChart();
});




