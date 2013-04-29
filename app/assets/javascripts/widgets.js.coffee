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
    data_type = $("#data-type").val()
    layout = $("#layout").val()
    size = $("#size").val()
    if $("#job").text() != "All"
        job_id = $("#job").val()
    from = $("#widget_from").val()
    to = $("#widget_to").val()

    $.post url,
      widget:
        name: name
        dashboard_id: dashboard_id
        job_id: job_id
        data_type: data_type
        layout: layout
        size: size
        to: to
        from: from
      (data) ->
        $("#modal").modal('hide')
        location.reload() #TODO nice reload
    false
