$ ->
  if $('#future_travels').length > 0
    $('#calendar').fullCalendar
      lang: 'ja',
      events: JSON.parse($('#future_travels').attr('value')),
      contentHeight: 500 # high enough to avoid scrollbars
