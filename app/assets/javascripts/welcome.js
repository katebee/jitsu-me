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
  var spinnerHTML = '&nbsp;&nbsp;<i class="fa fa-spinner fa-pulse"></i>';
  spinnerObjects = $(".has-spinner");
  spinnerObjects.append(spinnerHTML);
});

function renderMap(map) {
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpandmbXliNDBjZWd2M2x6bDk3c2ZtOTkifQ._QA7i5Mpkd_m30IGElHziw', {
    maxZoom: 18,
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
      '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
      'Imagery © <a href="http://mapbox.com">Mapbox</a>',
    id: 'mapbox.light'
  }).addTo(map);
}

function getClubLocations() {
  // TODO if clubLocations is empty, fetch
  clubLocations = $.get("/locations.json");
}

function addClubMarkers(map, clubLocations) {
  $.get("/locations.json", function(data){
    data.map(function(location) {
      L.marker(
        [location.location_lat, location.location_lng],
        {icon: jitsuIcon}).addTo(map).bindPopup(location.name);
    });
  });
}

function updateCitymapperLinks(lat, lng) {
  var userLatitude, userLongitude;
  if (lat !== undefined && lng !== undefined) {
    userLatitude = lat;
    userLongitude = lng;
  }
  else if (storageAvailable('localStorage')) {
    userLatitude = localStorage.getItem("userLat");
    userLongitude = localStorage.getItem("userLng");
  }
  else if (userMarker) {
    userLatitude = userMarker.LatLng.lat;
    userLongitude = userMarker.LatLng.lng;
  }
  else {
    userLatitude = '51.501806';
    userLongitude = '-0.140778';
  }
  $('.js-citymapper-link').attr('href', function(index, href) {
    return href.split('&startcoord=')[0] + '&startcoord=' + userLatitude + '%2C'+ userLongitude;
  });
}

function storageAvailable(type) {
	try {
		var storage = window[type],
			x = '__storage_test__';
		storage.setItem(x, x);
		storage.removeItem(x);
		return true;
	}
	catch(e) {
		return false;
	}
}

function storeUserLocation(lat, lng) {
  if (storageAvailable('localStorage')) {
  	localStorage.setItem("userLat", lat);
    localStorage.setItem("userLng", lng);
  }
  else {
  	// no localStorage, do something else
  }
}

function addUserMarker(marker, map) {
  if (storageAvailable('localStorage')) {
    var coords = {
      lat: localStorage.getItem("userLat"),
      lng: localStorage.getItem("userLng")
    };
    marker.setLatLng(coords);
    marker.addTo(map);
  }
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
  // for club in upcomingSessions, compare clublatlng to userlatlng
  // var nearestSessions = [] sort by ascending distance from user
  // there must be a elegant way to compare geolocations....
  // place markers on the map
}

$(document).ready(function(){

  const map = L.map('map').setView([51.515, -0.0895], 14);
  const userMarker = new L.marker([], {draggable: true, icon: userIcon});
  const clubLocations = getClubLocations();

  renderMap(map);
  addClubMarkers(map, clubLocations);
  addUserMarker(userMarker, map);
  updateCitymapperLinks();

  userMarker.on('dragend', function(event){
    var coords = event.target.getLatLng();
    console.log(coords);
    storeUserLocation(coords.lat, coords.lng);
    userMarker.setLatLng(coords);
    updateCitymapperLinks(coords.lat, coords.lng);
  });

  $('#find-me-button').on('click', function(){
    $(this).addClass('active');
    map.locate({setView: false});
    if (userMarker) {
      map.removeLayer(userMarker);
    }
  });

  $('#jitsu-me-button').on('click', function(){
    $(this).addClass('active');
    console.log(localStorage.getItem("userLat"));
    console.log(localStorage.getItem("userLng"));
    // $(this).removeClass('active');
  });

  function onLocationFound(event) {
    userMarker.setLatLng(event.latlng);
    userMarker.addTo(map);
    map.panTo(event.latlng);
    updateCitymapperLinks(event.latlng.lat, event.latlng.lng);
    storeUserLocation(event.latlng.lat, event.latlng.lng);
    $('#find-me-button').removeClass('active');
  }

  function onLocationError(error) {
    map.setView([51.505, -0.09], 12);
    alert(error.message);
  }

  map.on('locationfound', onLocationFound);
  map.on('locationerror', onLocationError);
});
