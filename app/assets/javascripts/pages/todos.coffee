$ ->
  $(".todo-finished").on ifChanged: (e) ->
    $.rails.handleRemote($(e.target.closest("form")))
    $(e.target.closest("tr")).toggleClass("line-through")
