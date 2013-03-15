class WidgetsController

  constructor: ->
    self = @
    $ ->
      self.start_reload_timer()
      self.cycle_widgets()

  # start a timer to reload the widget data
  start_reload_timer: ->
    self = @
    @reload_timer = setInterval ->
      self.reload_data()
    , 3000

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
        hideSequentially(first.find("li"), 100, ->
          first.find("li").removeClass("out")
          first.hide()
          second.show()
          second.children("h1").fadeIn(1000, ->
            first.remove().appendTo(".widgets")
          )
        )
    , 60000

  # request new data from the server
  reload_data: ->
    self = @
    $(".widget").each( ->
      @job_id = $(this).data("job-id")
      $.get "/api/jobs/#{@job_id}.json",
        (data) ->
          self.parse_data(data, $(this))
    )

  # load then new data into the widget
  parse_data:(data, widget) ->
    widgetView = new WidgetView(widget)
    widgetView.set_insertions(data.insertions)
    widgetView.set_deletions(data.deletions)
    widgetView.set_passed_tests(data.passed_tests)
    widgetView.set_failed_tests(data.failed_tests)
    widgetView.set_skipped_tests(data.skipped_tests)
    widgetView.set_failed_builds(data.failed_builds)
    widgetView.set_successful_builds(data.successful_builds)
    widgetView.set_build_breaker(data.build_breaker)
    widgetView.set_most_commits(data.most_commits)

window.WidgetsController = new WidgetsController()
