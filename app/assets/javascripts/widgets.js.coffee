# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

  $(".from").datepicker()
  $(".to").datepicker()

  $("#new-widget").click ->
    url = $("#new-widget").attr("href")
    name = $("#widget_name").val()
    dashboard_id = $("#dashboard_id").val()
    $.post url,
      widget:
        name: name
        dashboard_id: dashboard_id
      (data) ->
        $("#modal").modal('hide')
        location.reload() #TODO nice reload
    false
