var bubbleChart = function() {
  $.getJSON('/participants/bubbles', function(data) {
    console.log(data);
    bubble(data, {width: window.innerWidth, height: window.innerHeight});
  });
};

$(document).ready(function() {
  bubbleChart();
});


