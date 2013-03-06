class WidgetsController

  constructor: ->
    self = @
    $ ->
      self.start_reload_timer()

  start_reload_timer: ->
    self = @
    @timer = setInterval ->
      self.reload_data()
    , 2000

  clear_timers: ->
    window.clearInterval

  reload_data: ->
    self = @
    if $(".project-development-stats")
      @job_id = $(".project-development-stats").data("job-id")
      $.get "/api/jobs/#{@job_id}.json",
        (data) ->
          self.parse_data(data)

  parse_data:(data) ->
    WidgetView.set_insertions(data.insertions)

window.WidgetsController = new WidgetsController()
