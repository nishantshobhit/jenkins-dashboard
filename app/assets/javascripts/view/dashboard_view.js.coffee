class DashboardView

  constructor: ->

  hide_toolbar: ->
    $(".navbar").slideUp(2000)

  show_toolbar: ->
    $(".navbar").slideDown(1000)

window.DashboardView = new DashboardView()
