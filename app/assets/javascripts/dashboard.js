$(function() {
  $("#unavailable_until").datepicker("disable");
  var declineDialog = $("#decline-form-dialog").dialog({
    autoOpen: false,
    height: 300,
    width: 350,
    modal: true,
    buttons: {
      "Decline All": declineAll,
      Cancel: function() {
        declineDialog.dialog("close");
      }
    },
    open: function(event, ui) {
      $("#unavailable_until").datepicker("enable");
    },
    close: function(event, ui) {
      $("#unavailable_until").datepicker("disable");
    }
  });

  function declineAll() {
    $('#decline-form').submit();
  };

  $("#decline_all_link").click(function() {
    declineDialog.dialog("open");
  });
});
