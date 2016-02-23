var jitsuIcon = L.AwesomeMarkers.icon({
    icon: 'star',
    prefix: 'fa',
    markerColor: 'lightgray'
  });

  var userIcon = L.AwesomeMarkers.icon({
      icon: 'fa-male',
      prefix: 'fa',
      markerColor: 'blue'
    });

$(function(){
  var spinnerHTML = '&nbsp;&nbsp;<i class="fa fa-spinner fa-pulse"></i>',
    spinnerObjects = $(".has-spinner");
    spinnerObjects.append(spinnerHTML);
});

function renderMap(map) {
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpandmbXliNDBjZWd2M2x6bDk3c2ZtOTkifQ._QA7i5Mpkd_m30IGElHziw', {
    maxZoom: 18,
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
      '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
      'Imagery © <a href="http://mapbox.com">Mapbox</a>',
    id: 'mapbox.dark'
  }).addTo(map);
}

function addClubMarkers(map) {
  $.get("/locations.json", function(data){
    data.map(function(location) {
      L.marker([location.location_lat, location.location_lng], {icon: jitsuIcon}).addTo(map).bindPopup(location.name);
    });
  });
}

$(document).ready(function(){

  var map = L.map('map').setView([51.515, -0.0895], 14);
  var userMarker = new L.marker([], {draggable: true, icon: userIcon});

  renderMap(map);
  addClubMarkers(map);

  $('#jitsu-me-button').on('click', function(){
    $(this).addClass('active');
    map.locate({setView: true});
    if (userMarker) {
      map.removeLayer(userMarker);
    }
  });

  function onLocationFound(e) {
    userMarker.setLatLng(e.latlng);
    userMarker.addTo(map);
    $('#jitsu-me-button').removeClass('active');
  }

  function onLocationError(e) {
    map.setView([51.505, -0.09], 12);
    alert(e.message);
  }

  function startLocation(marker) {
    var position = userMarker.latlng;
    console.log(position);
  }

  map.on('locationfound', onLocationFound);
  map.on('locationerror', onLocationError);
});
