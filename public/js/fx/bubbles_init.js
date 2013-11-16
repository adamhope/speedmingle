var bubbleChart = function() {
  var render = function () { 
    $.getJSON('/participants/bubbles', graph.render);
  }
  
  var graph = new bubble({width: $(".visualization").width(), height: $(".visualization").innerHeight() });
  render()
  setInterval(render, 2000);
};

$(document).ready(function() {
  bubbleChart();
});




