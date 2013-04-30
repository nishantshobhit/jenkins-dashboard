class TextWidgetController extends WidgetController
  constructor: ->
    super constructor

  # request new data from the server
  reload_data: ->
    self = @
    $(".widget").each( ->
      widget = $(this)
      if widget.hasClass("project-development-stats")
        # commit data
        @job_id = widget.data("job-id")
        $.get "/api/jobs/#{@job_id}.json",
          (data) ->
            self.parse_data(data, widget)
    )

  # load then new data into the widget
  parse_data:(data, widget) ->
    widgetView = new TextWidgetView(widget)
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

window.TextWidgetController = TextWidgetController
