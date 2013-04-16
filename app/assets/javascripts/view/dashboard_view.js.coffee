class DashboardView

  constructor: ->

  hide_toolbar: ->
    $(".navbar").fadeOut(2000)

  show_toolbar: ->
    $(".navbar").fadeIn(1000)

window.DashboardView = new DashboardView()
