class WidgetModel extends BaseModel
  constructor: (data) ->
    @assignProperty("name", data)
    @assignProperty("dashboard_id", data)
    @assignProperty("job_id", data)
    @assignProperty("data_type", data)
    @assignProperty("layout", data)
    @assignProperty("size", data)
    @assignProperty("from", data)
    @assignProperty("to", data)

  toJSON: ->
    widget:
      name: @name
      dashboard_id: @dashboard_id
      job_id: @job_id
      data_type: @data_type
      layout: @layout
      size: @size
      to: @to
      from: @from

window.WidgetModel = ChalkboardModel
