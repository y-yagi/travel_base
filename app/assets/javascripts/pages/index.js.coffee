$ ->
  $('#calendar').fullCalendar
    lang: 'ja',
    events: gon.events
    contentHeight: 500 # high enough to avoid scrollbars
