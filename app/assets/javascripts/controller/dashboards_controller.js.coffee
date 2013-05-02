class DashboardsController

  constructor: ->
    self = @
    $ ->
      if typeof DashboardView != "undefined"
        DashboardView.hide_toolbar()
        self.toolbar_listener()
        self.start_reload_timer()
        self.cycle_widgets()
        self.new_widget_listener()
      self.save_listener()
      self.delete_listener()
      self.add_listener()

  save_listener: ->
    $("#save-dashboard").click ->
      name = $("#dashboard_name").val()
      $.post this.href,
        dashboard:
          name: name
        (data) ->
          $("#modal").modal('hide')
          location.reload() #TODO load the content in nicely
      false

  delete_listener: ->
    $(".delete-dashboard").click ->
      button = $(this)
      $.ajax this.href,
        type: "DELETE"
        success: (data, textStatus, jqXHR) ->
          button.parent().fadeOut()
      false

  add_listener: ->
    $("#add-dashboard").click ->
      $("#modal").modal('show')

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

  new_widget_listener: ->
    $("#new-widget").click ->
      widget = new window.WidgetModel($("form#new_widget"))
      url = $("#new-widget").attr("href")
      $.post url,
        widget: widget.toJSON()
        (data) ->
          $("#modal").modal('hide')
          location.reload() #TODO nice reload
      false


  window.DashboardsController = new DashboardsController()
