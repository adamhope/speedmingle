var connectParticipants = function(connectFrom, connectTo) {
  $.ajax({
    url: '/participants/connect',
    accepts: "application/json",
    dataType: 'json',
    type: 'POST',
    data : JSON.stringify({ 
      "from_phone_number": connectFrom,
      "to_pin": connectTo
    }),
    success: function(json) {
      location.reload();
    },
    error: function(xhr, errorType, exception) {
      $.each(xhr.responseJSON, function(key, value) {
        $("#errors .col-lg-12").html(
          "<div class='alert alert-danger'><strong>Error: </strong>" + key + ' ' + value + "</div>"
         )
      });
    }
  });
};

    