class WidgetController

  constructor: ->
    self = @
    $ ->
      self.reload_data()
      self.start_reload_timer()
      self.cycle_widgets()

  # start a timer to reload the widget data
  start_reload_timer: ->
    self = @
    @reload_timer = setInterval ->
      self.reload_data()
    , 10000

  # clear all timeout timers
  clear_timers: ->
    window.clearInterval()

  # cycle inbetween all widgets in a dashboard
  cycle_widgets: ->
    self = @
    $(".widget").not(":first").hide()
    $(".widget").not(":first").children("h1").hide()
    @cycle_timer = setInterval ->
      widgets = $(".widget")
      if widgets.length > 1
        first = widgets.eq(0)
        second = widgets.eq(1)
        first.children("h1").fadeOut(1000)
        if first.hasClass("project-development-stats")
          hideSequentially(first.find("li"), 100, ->
            first.find("li").removeClass("out")
            first.fadeOut(1000)
            second.fadeIn(1000)
            second.children("h1").fadeIn(1000, ->
              first.remove().appendTo(".widgets")
            )
          )
        else
          first.fadeOut(1000)
          second.fadeIn(1000)
          second.children("h1").fadeIn(1000, ->
            first.remove().appendTo(".widgets")
          )
    , 30000

  reload_data: ->

window.WidgetController = WidgetController
