class DashboardsController

  constructor: ->
    self = @
    $ ->
      DashboardView.hide_toolbar()
      self.toolbar_listener()

  toolbar_listener: ->
    $(document).mousemove (e) ->
      if e.pageY <= 70
        DashboardView.show_toolbar()
      else
        DashboardView.hide_toolbar()

  createDashboard: (name) ->

  deleteDashboard: (id) ->

  window.DashboardsController = new DashboardsController()
