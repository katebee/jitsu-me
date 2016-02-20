// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function(){

  $('#calendar').fullCalendar({
      defaultDate: moment(),
      header: {
          left: 'prev,next today',
          center: 'title',
          right: 'month,agendaWeek,agendaDay'
      },
      defaultView: 'agendaWeek',
      minTime: "10:00:00",
      maxTime: "25:00:00",

      events: '/events.json',

      eventClick: function(event) {
        if (event.url) {
          window.open(event.url);
          return false;
        }
      }

  }); // end of fullCalendar

});
