$(document).ready(function(){

  var map = L.map('map').setView([51.505, -0.09], 13);

  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpandmbXliNDBjZWd2M2x6bDk3c2ZtOTkifQ._QA7i5Mpkd_m30IGElHziw', {
    maxZoom: 18,
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
      '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
      'Imagery © <a href="http://mapbox.com">Mapbox</a>',
    id: 'mapbox.streets'
  }).addTo(map);

  $(document).ready(function(){
    $.get("/clubs.json", function(data){
      data.map(function(club) {
        L.marker([club.location_lat, club.location_lng]).addTo(map).bindPopup(club.name);
      })
    })
  });

  $('#jitsu-me-button').on('click', function(){
    map.locate({setView: true, maxZoom: 18});
  });

  function onLocationFound(e) {
    L.marker(e.latlng, {draggable: true}).addTo(map);
  }

  function onLocationError(e) {
  map.setView([51.505, -0.09], 10);
  alert(e.message);
  }

  map.on('locationfound', onLocationFound);
  map.on('locationerror', onLocationError);

});
