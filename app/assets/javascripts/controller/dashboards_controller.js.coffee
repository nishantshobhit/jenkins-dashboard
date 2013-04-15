class DashboardsController

  constructor: ->
    self = @
    $ ->
      DashboardView.hide_toolbar()
      self.toolbar_listener()
      self.start_reload_timer()

  # listen for toolbar hover to show/hide
  toolbar_listener: ->
    $(document).mousemove (e) ->
      if e.pageY <= 70
        DashboardView.show_toolbar()
      else
        DashboardView.hide_toolbar()

  # start a timer to reload the dasbhoard
  start_reload_timer: ->
    self = @
    @reload_timer = setInterval ->
      self.check_root()
    , 24000

  # request new data from the server
  check_root: ->
    self = @
    $.get "/api/current_path.json",
      (data) ->
        self.parse_data(data)

  # load then new data into the widget
  parse_data:(data) ->
    path = data["path"]
    if localStorage.jenkins_path
      stored_path = localStorage.jenkins_path
      if stored_path != path
        console.log("reloading")
        localStorage.jenkins_path = path
        window.location = window.location
    else
      localStorage.jenkins_path = path

  createDashboard: (name) ->

  deleteDashboard: (id) ->

  window.DashboardsController = new DashboardsController()
