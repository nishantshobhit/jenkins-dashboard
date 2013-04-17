class WidgetsController

  constructor: ->
    self = @
    self.test_data =
      labels: ["Passed", "Skipped", "Failed"]
      values: [0, 0, 0]
    $ ->
      self.reload_test_data()
      self.start_reload_timer()
      self.cycle_widgets()

  # start a timer to reload the widget data
  start_reload_timer: ->
    self = @
    @reload_timer = setInterval ->
      self.reload_stats_data()
      self.reload_test_data()
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
            first.hide()
            second.show()
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

  # data source for pie chart
  global_test_data: ->
    self.test_data

  # request new test data from the server
  reload_test_data: ->
    # parse data and convert to percentages
    $.get "/api/test_report.json",
      (data) ->
        total = data.passed + data.failed + data.skipped;
        self.test_data =
          labels: ["Passed", "Skipped", "Failed"]
          values: [
            (data.passed / total) * 100,
            (data.failed / total * 100),
            (data.skipped / total * 100)
          ]

  # request new data from the server
  reload_stats_data: ->
    self = @
    $(".widget").each( ->
      if $(this).hasClass("project-development-stats")
        # commit data
        @job_id = $(this).data("job-id")
        $.get "/api/jobs/#{@job_id}.json",
          (data) ->
            self.parse_text_data(data, $(this))
    )

  # load then new data into the widget
  parse_text_data:(data, widget) ->
    widgetView = new WidgetView(widget)
    job = data.job
    widgetView.set_insertions(job.insertions)
    widgetView.set_deletions(job.deletions)
    widgetView.set_passed_tests(job.passed_tests)
    widgetView.set_failed_tests(job.failed_tests)
    widgetView.set_skipped_tests(job.skipped_tests)
    widgetView.set_failed_builds(job.failed_builds)
    widgetView.set_successful_builds(job.successful_builds)
    widgetView.set_build_breaker(job.build_breaker)
    widgetView.set_most_commits(job.most_commits)

window.WidgetsController = new WidgetsController()
