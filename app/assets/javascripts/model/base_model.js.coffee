class BaseModel
  assignProperty: (name, data) ->
    @[name] = null
    return if typeof data == "undefined"
    @[name] = data if typeof data != "undefined"

window.BaseModel = BaseModel
