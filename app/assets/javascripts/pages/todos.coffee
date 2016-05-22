$(document).on('ready turbolinks:load',  ->
  $(".todo-finished").on ifChanged: (event) ->
    $.rails.handleRemote($($(event.target).closest("form")))
    $($(event.target).closest("tr")).toggleClass("line-through")
)
