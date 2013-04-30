class WidgetModel extends BaseModel
  constructor: (form) ->
    @assignProperty("name", form.find("#widget_name").val())
    @assignProperty("dashboard_id", form.find("#dashboard_id").val())
    @assignProperty("job_id", form.find("#job_id").val())
    @assignProperty("data_type", form.find("#data_type").val())
    @assignProperty("layout", form.find("#layout").val())
    @assignProperty("size", form.find("#size").val())

  toJSON: ->
    name: @name
    dashboard_id: @dashboard_id
    job_id: @job_id
    data_type: @data_type
    layout: @layout
    size: @size

window.WidgetModel = WidgetModel
