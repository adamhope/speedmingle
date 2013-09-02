$(document).ready(function() {
  $.getJSON('/sample_data/participants', updateScoreboard);
});
