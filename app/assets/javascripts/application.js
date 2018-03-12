// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require rails-ujs
//= require turbolinks
//= require semantic-ui
//= require semantic-ui-calendar/dist/calendar
//= require_tree .

document.addEventListener("turbolinks:load", function() {
  // $('.ui.dropdown').dropdown();

  $('#start-date').calendar({
    type: 'date',
    maxDate: new Date()
  });

  $('#end-date').calendar({
    type: 'date',
    maxDate: new Date()
  });

  $('.message .close')
  .on('click', function() {
    $(this)
      .closest('.message')
      .transition('fade')
      $('#push p').empty();
  });

  $(".custom-filter").hide();
  $(".custom-filter-button").click(function() {

      $(".custom-filter").show();
      $(".default-filter").hide();
  });
  $(".custom-filter .close").click(function() {

      $(".custom-filter").hide();
      $(".default-filter").show();
  });



  $(".navbar .item").on("click", function() {

      $(this).addClass("play");
  });

  $("#filter-form").on("ajax:success", function(event) {
      $(".dimmer").addClass("active");


  }).on("ajax:error", function(event) {

  });
  $("#auth-form").on("ajax:success", function(event) {
    location.reload();

  })



})
