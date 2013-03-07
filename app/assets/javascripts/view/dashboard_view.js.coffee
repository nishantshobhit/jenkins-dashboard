class DashboardView

  constructor: ->

  hide_toolbar: ->
    $(".navbar").slideUp()

  show_toolbar: ->
    $(".navbar").slideDown()

window.DashboardView = new DashboardView()
