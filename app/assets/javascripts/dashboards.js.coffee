# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

  $("#save-dashboard").click ->
    name = $("#dashboard_name").val()
    $.post this.href,
      dashboard:
        name: name
      (data) ->
        $("#modal").modal('hide')
        location.reload() #TODO load the content in nicely
    false

  $(".delete-dashboard").click ->
    button = $(this)
    $.ajax this.href,
      type: "DELETE"
      success: (data, textStatus, jqXHR) ->
        button.parent().fadeOut()
    false

  $("#add-dashboard").click ->
    $("#modal").modal('show')
