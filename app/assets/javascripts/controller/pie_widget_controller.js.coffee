class PieWidgetController extends WidgetController
  constructor: ->
    super constructor
    self.pie_data =
      labels: []
      values: []

  # request new test data from the server
  reload_data: ->
    # parse data and convert to percentages
    $.get "/api/duration.json",
      (data) ->
        total = 0
        names = []
        durations = []
        response = data
        for job in data
          total = total + job.duration
        for job in data
          names.push(job.name)
          durations.push(job.duration / total * 100)
        self.pie_data =
          labels: names
          values: durations

      # data source for pie chart
  pie_data: ->
    self.pie_data

  # request new test data from the server
  #reload_test_data: ->
  #  # parse data and convert to percentages
  #  $.get "/api/test_report.json",
  #    (data) ->
  #      total = data.passed + data.failed + data.skipped;
  #      self.test_data =
  #        labels: ["Passed", "Skipped", "Failed"]
  #        values: [
  #          (data.passed / total) * 100,
  #          (data.failed / total * 100),
  #          (data.skipped / total * 100)
  #        ]

window.PieWidgetController = PieWidgetController
