$(document).on('turbolinks:load',  ->
  if $('#calendar_events').length > 0
    $('#calendar').fullCalendar
      lang: 'ja',
      events: JSON.parse($('#calendar_events').attr('value')),
      contentHeight: 500 # high enough to avoid scrollbars
)
