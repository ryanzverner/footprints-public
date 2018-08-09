$(function() {
  $('.edit-note').click(editHandler);
})

function editHandler(e) {
  e.preventDefault();
  getNoteForm.apply(this);
}

function getNoteForm() {
  $.ajax({
    type: 'GET',
    url: this,
    async: false,
    success: function(form) {
      $(this).parent().html(form);
    }.bind(this)
  });
}

