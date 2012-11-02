# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready( ->
  window.ChartsController.generate_stack("/jobs/test_report.json","#global-test-report-container")
  window.ChartsController.generate_stack("#{document.URL}.json","#test-report-container")
);
