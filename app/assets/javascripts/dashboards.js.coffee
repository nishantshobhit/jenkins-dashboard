# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

  $("#save-dashboard").click ->
    name = $("#dashboard_name").val()
    console.log(this.href)
    $.post this.href,
      dashboard:
        name: name
      (data) ->
        alert("Added")
        $("#modal").modal('hide')
    false

  $("#add-dashboard").click ->
    $("#modal").modal('show')
