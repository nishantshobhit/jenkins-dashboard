class AddWidgetController extends WidgetController

  constructor: ->
    self = @
    $ ->
      self.start_reload_timer()
      self.add_widget_listener()

  add_widget_listener: ->
    self = @
    $("#modal").on("shown",  ->
      self.new_widget_listener()
      # set form listeners
      $("#job_id").change ->
        self.job_updated($(this).val())
      $("#data_type").change ->
        self.data_updated($(this).val())
      $("#layout").change ->
        self.layout_updated($(this).val())
      self.job_updated("")
    )

  new_widget_listener: ->
    $("#new-widget").click ->
      widgetView = new window.WidgetView
      widget = new window.WidgetModel($("form#new_widget"))
      url = $("#new-widget").attr("href")
      $.post url,
        widget: widget.toJSON()
        (data) ->
          $("#modal").modal('hide')
          location.reload() #TODO nice reload
      false

  job_updated: (job) ->
    console.log(job)
    data_type = $("#data_type")
    data_type.empty()
    if job != ""
      data_type.append("<option value='gitstats'>gitstats</option>")
    else
      data_type.append("<option value='build_durations'>build_durations</option>")
    @.data_updated(data_type.val())

  layout_updated: (layout) ->
    console.log(layout)

  data_updated: (data) ->
    console.log(data)
    layout = $("#layout")
    layout.empty()
    if data == "gitstats"
      layout.append("<option value='text'>text</option>")
    else
      layout.append("<option value='pie'>pie</option>")
    @.layout_updated(layout.val())

window.AddWidgetController = new AddWidgetController
