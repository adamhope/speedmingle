var bubbleChart = function() {
  var render = function () {
    return $.getJSON('/participants/bubbles', graph.render);
  }

  var graph = new bubble({width: $(".visualization").width(), height: $(".visualization").innerHeight() });
  render()

  setTimeout(function keepUpdate() {
    render()
      .always(function() {
        setTimeout(keepUpdate, 3000);
      });
  }, 3000);
};

$(document).ready(function() {
  bubbleChart();
});
