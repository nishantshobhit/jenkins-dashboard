class AddWidgetController extends WidgetController

  constructor: ->
    self = @
    $ ->
      self.start_reload_timer()
      self.add_widget_listener()

  add_widget_listener: ->
    alert("Hello")
    self = @
    $("#add-widget").click ->
      self.new_widget_listener()
      # listen for form updates

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

window.AddWidgetController = new AddWidgetController
