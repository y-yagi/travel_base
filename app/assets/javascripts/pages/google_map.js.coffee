class GoogleMap
  attachMessage = (marker, msg) ->
    google.maps.event.addListener(marker, 'click', (event) ->
      new google.maps.InfoWindow({content: msg}
      ).open(marker.getMap(), marker)
    )

  show: (places, zoom) ->
    mapOptions =
      zoom: zoom
      center: new google.maps.LatLng(places[0]['latitude'], places[0]['longitude'])
      mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions)

    data = new Array()
    i = 0
    places.forEach((place) ->
      data.push({position: new google.maps.LatLng(place['latitude'], place['longitude']), content: place['name']})
      myMarker = new google.maps.Marker({
        position: data[i].position,
        map: map,
        icon: "//chart.apis.google.com/chart?chst=d_map_pin_letter&chld=#{i+1}|ff6633|000000"
      })
      attachMessage(myMarker, data[i].content)
      i++
    )

$ ->
  if $('#places_for_map').length > 0
    places = JSON.parse($('#places_for_map').attr('value'))
    zoom = parseInt($('#map_zoom').attr('value'), 12)
    new GoogleMap().show(places, zoom)
