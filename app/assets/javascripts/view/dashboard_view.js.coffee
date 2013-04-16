class DashboardView

  constructor: ->

  hide_toolbar: ->
    $(".navbar").fadeOut()

  show_toolbar: ->
    $(".navbar").fadeIn()

window.DashboardView = new DashboardView()
