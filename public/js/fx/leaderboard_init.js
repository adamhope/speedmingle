$(document).ready(function() {
  $.getJSON('/sample_data/participants', updateLeaderboard);
  setInterval(function () {
    $.getJSON('/sample_data/participants', updateLeaderboard);
  }, 2000);
});
