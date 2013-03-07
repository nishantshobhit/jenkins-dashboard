class DashboardView

  constructor: ->

  hide_toolbar: ->
    $(".navbar").slideUp()
    console.log("hello")

  show_toolbar: ->
    $(".navbar").slideDown()

window.DashboardView = new DashboardView()
