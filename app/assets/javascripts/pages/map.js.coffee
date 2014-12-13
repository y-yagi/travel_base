attachMessage = (marker, msg) ->
  google.maps.event.addListener(marker, 'click', (event) ->
    new google.maps.InfoWindow({content: msg}
    ).open(marker.getMap(), marker)
  )

initialize = () ->
  mapOptions = {
    zoom: gon.zoom,
    center: new google.maps.LatLng(gon.places[0]['latitude'], gon.places[0]['longitude']),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions)

  data = new Array()
  i = 0
  gon.places.forEach((place) ->
    data.push( {position: new google.maps.LatLng(place['latitude'], place['longitude']), content: place['name']})
    myMarker = new google.maps.Marker({position: data[i].position, map: map })
    attachMessage(myMarker, data[i].content)
    i++
  )

google.maps.event.addDomListener(window, 'load', initialize)
