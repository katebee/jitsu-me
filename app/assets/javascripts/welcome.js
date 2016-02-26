const jitsuIcon = L.AwesomeMarkers.icon({
    icon: 'star',
    prefix: 'fa',
    markerColor: 'lightgray'
  });

const userIcon = L.AwesomeMarkers.icon({
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

function getClubLocations() {
  // TODO if clubLocations is empty, fetch
  clubLocations = $.get("/locations.json");
}

function addClubMarkers(map, clubLocations) {
  $.get("/locations.json", function(data){
    data.map(function(location) {
      L.marker([location.location_lat, location.location_lng], {icon: jitsuIcon}).addTo(map).bindPopup(location.name);
    });
  });
}

function removeClubMarkers() {
  // TODO
}

function upcomingSessions() {
  // TODO
}

function findNearbySessions() {
  // TODO
}

function upcomingSessionMarkers(map, userMarker) {
  var userLat = userMarker.LatLng.lat;
  var userLng = userMarker.LatLng.lng;
  console.log(userLat);
  // for club in upcomingSessions, compare clublatlng to userlatlng
  // var nearestSessions = [] sort by ascending distance from user
  // there must be a elegant way to compare geolocations....
  // place markers on the map
}

$(document).ready(function(){

  const map = L.map('map').setView([51.515, -0.0895], 14);
  const userMarker = new L.marker([], {draggable: true, icon: userIcon});
  const clubLocations = getClubLocations();
  const userPosition = {lat: "", lng: ""};

  renderMap(map);
  addClubMarkers(map, clubLocations);

  $('#find-me-button').on('click', function(){
    $(this).addClass('active');
    map.locate({setView: false});
    if (userMarker) {
      map.removeLayer(userMarker);
    }
  });

  $('#jitsu-me-button').on('click', function(){
    $(this).addClass('active');
    console.log(userMarker);
    console.log(userPosition);
    $(this).removeClass('active');
  });

  function onLocationFound(e) {
    userPosition.lat = e.latlng.lat;
    userPosition.lng = e.latlng.lng;
    userMarker.setLatLng(e.latlng);
    userMarker.addTo(map);
    map.panTo(e.latlng);
    $('#find-me-button').removeClass('active');
  }

  function onLocationError(e) {
    map.setView([51.505, -0.09], 12);
    alert(e.message);
  }

  map.on('locationfound', onLocationFound);
  map.on('locationerror', onLocationError);
});
