class WidgetController

  constructor: ->
    self = @
    $ ->
      self.reload_data()
      self.start_reload_timer()

  # start a timer to reload the widget data
  start_reload_timer: ->
    self = @
    @reload_timer = setInterval ->
      self.reload_data()
    , 10000

  # clear all timeout timers
  clear_timers: ->
    window.clearInterval()

  reload_data: ->

window.WidgetController = WidgetController
