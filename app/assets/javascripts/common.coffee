$(document).on('ready turbolinks:load',  ->
  $('[data-dismiss="info-box"]').click ->
    $(".info-box").remove()

  $("#alert-info").fadeTo(2000, 500).slideUp(500, ->
    $("#alert-info").alert('close')
  )
  $("input[data-role=tagsinput], select[multiple][data-role=tagsinput]").tagsinput()
)
