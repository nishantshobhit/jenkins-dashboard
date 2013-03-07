class WidgetView

  constructor:(widget) ->
    @widget = widget

  set_insertions:(insertions) ->
    @insertions = insertions
    @set_value((@insertions - @deletions), ".total-lines")
    @set_value(insertions, ".lines-added")

  set_deletions:(deletions) ->
    @deletions = deletions
    @set_value((@insertions - @deletions), ".total-lines")
    @set_value(deletions, ".lines-removed")

  set_failed_builds:(failed) ->
    @set_value(failed, ".builds-failed")

  set_successful_builds:(successful) ->
    @set_value(successful, ".builds-successful")

  set_passed_tests:(passed) ->
    @set_value(passed, ".tests-passed")

  set_failed_tests:(failed) ->
    @set_value(failed, ".tests-failed")

  set_skipped_tests:(skipped) ->
    @set_value(skipped, ".tests-skipped")

  set_value:(value, selector) ->
    self = @
    oldValue = @widget.find(""+selector+" span").html()
    unless oldValue == value
      self.set_old_value(""+selector+"", oldValue)
      self.set_new_value(""+selector+"", value)
      window.updateFigures(""+selector+" .figure")

  set_old_value: (selector, oldValue) ->
    @widget.find(""+selector+" .figure").attr("data-old-value", oldValue)

  set_new_value: (selector, newValue) ->
    @widget.find(""+selector+" .figure").html(newValue)

  set_widget:(widget) ->
    @widget = widget

  widget: ->
    @widget

window.WidgetView = WidgetViewg
