setInterval(function () {
  $.getJSON('/sample_data/links', updateGraph);
}, 2000);

$(document).ready(function() {
  $.getJSON('/sample_data/links', initGraph);
});
