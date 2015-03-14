$ ->
  $('[data-dismiss="info-box"]').click ->
    $(".info-box").remove()

  $(".alert").fadeTo(2000, 500).slideUp(500, ->
    $(".alert").alert('close')
  )
