$ ->
  $.fn.editable.defaults.ajaxOptions = {type: "PATCH"};
  $('.schedule-memo').editable()
  params: (params) ->
    params._method = 'patch'
    return params
