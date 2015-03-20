$ ->
  $('[data-dismiss="info-box"]').click ->
    $(".info-box").remove()

  $("#alert-info").fadeTo(2000, 500).slideUp(500, ->
    $("#alert-info").alert('close')
  )

Turbolinks.enableProgressBar
