class WidgetView

  set_insertions:(insertions) ->
    self = @
    oldValue = $(".lines-added span").html()
    unless oldValue == insertions
      self.set_old_value(".lines-added", oldValue)
      self.set_new_value(".lines-added", insertions)
      window.updateFigures('.lines-added .figure')

  set_old_value: (selector, oldValue) ->
    $(""+selector+" .figure").attr("data-old-value", oldValue)

  set_new_value: (selector, newValue) ->
    $(""+selector+" .figure").html(newValue)

window.WidgetView = new WidgetView()
