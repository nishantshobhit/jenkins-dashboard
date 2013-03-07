class WidgetsController

  constructor: ->
    self = @
    $ ->
      self.start_reload_timer()
      self.cycle_widgets()

  start_reload_timer: ->
    self = @
    @reload_timer = setInterval ->
      self.reload_data()
    , 2000

  clear_timers: ->
    window.clearInterval()

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
        hideSequentially(first.find("li"), 100, ->
          first.find("li").removeClass("out")
          first.hide()
          second.show()
          second.children("h1").fadeIn(1000, ->
            first.remove().appendTo(".widgets")
          )
        )
    , 120000

  reload_data: ->
    self = @
    $(".widget").each( ->
      @job_id = $(this).data("job-id")
      $.get "/api/jobs/#{@job_id}.json",
        (data) ->
          self.parse_data(data, $(this))
    )

  parse_data:(data, widget) ->
    widgetView = new WidgetView(widget)
    widgetView.set_insertions(data.insertions)
    widgetView.set_deletions(data.deletions)
    widgetView.set_passed(data.passed_tests)
    widgetView.set_failed(data.failed_tests)
    widgetView.set_skipped(data.skipped_tests)

window.WidgetsController = new WidgetsController()
