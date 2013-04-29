class BaseModel
  assignProperty: (name, data) ->
    @[name] = null
    return if typeof data == "undefined"
    @[name] = data[name] if typeof data[name] != "undefined"

window.BaseModel = BaseModel
