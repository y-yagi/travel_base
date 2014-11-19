$ ->
  $('#tabs a').click(e) ->
    e.preventDefault()
    $(@).tab('show')
