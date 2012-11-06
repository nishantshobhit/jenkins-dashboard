class ChartsController

  constructor: ->

  generate_donut: (url,div) ->

    false unless div

    width = 500
    height = 500
    radius = Math.min(width, height) / 2
    color = d3.scale.ordinal().domain(["built","failed"]).range(["#54cd42", "#db5151"])

    arc = d3.svg.arc().outerRadius(radius - 10).innerRadius(radius - 120)

    pie = d3.layout.pie().sort(null).value((d) ->
      d.count
    )

    svg = d3.select(div).append("svg").attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

    $.get url, (data) ->
      data.forEach (d) ->
        d.count = +d.count

      g = svg.selectAll(".arc").data(pie(data)).enter().append("g").attr("class", "arc")
      g.append("path").attr("d", arc).style "fill", (d) ->
        color d.data.key

      g.append("text").attr("transform", (d) ->
        "translate(" + arc.centroid(d) + ")"
      ).attr("dy", ".35em").style("text-anchor", "middle").text (d) ->
        d.data.key if d.data.count > 0

  generate_stack: (url,div) ->

    false unless div

    margin =
      top: 20
      right: 20
      bottom: 30
      left: 40

    width = 960 - margin.left - margin.right
    height = 500 - margin.top - margin.bottom
    x = d3.scale.ordinal().rangeRoundBands([0, width], .1)
    y = d3.scale.linear().rangeRound([height, 0])
    color = d3.scale.ordinal().range(["#54cd42", "#db5151","#e6f449"])
    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("left").tickFormat(d3.format(".2s"))
    svg = d3.select(div).append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    $.get url, (data) ->
      color.domain d3.keys(data[0]).filter((key) ->
        key isnt "day"
      )
      data.forEach (d) ->
        y0 = 0
        d.tests = color.domain().map((name) ->
          name: name
          y0: y0
          y1: y0 += +d[name]
        )
        d.total = d.tests[d.tests.length - 1].y1

      data.sort (a, b) ->
        b.total - a.total

      x.domain data.map((d) ->
        d.day
      )
      y.domain [0, d3.max(data, (d) ->
        d.total
      )]
      svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
      svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text "Tests"
      day = svg.selectAll(".state").data(data).enter().append("g").attr("class", "g").attr("transform", (d) ->
        "translate(" + x(d.day) + ",0)"
      )
      day.selectAll("rect").data((d) ->
        d.tests
      ).enter().append("rect").attr("width", x.rangeBand()).attr("y", (d) ->
        y d.y1
      ).attr("height", (d) ->
        y(d.y0) - y(d.y1)
      ).style "fill", (d) ->
        color d.name

      legend = svg.selectAll(".legend").data(color.domain().slice().reverse()).enter().append("g").attr("class", "legend").attr("transform", (d, i) ->
        "translate(0," + i * 20 + ")"
      )
      legend.append("rect").attr("x", width - 18).attr("width", 18).attr("height", 18).style "fill", color
      legend.append("text").attr("x", width - 24).attr("y", 9).attr("dy", ".35em").style("text-anchor", "end").text (d) ->
        d

  generate_multiline: (url,div) ->

    return false unless div

    margin =
      top: 20
      right: 250
      bottom: 30
      left: 50

    width = 1500 - margin.left - margin.right
    height = 500 - margin.top - margin.bottom
    parseDate = d3.time.format("%Y-%m-%d").parse
    x = d3.time.scale().range([0, width])
    y = d3.scale.linear().range([height, 0])
    color = d3.scale.category10()
    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("left")

    line = d3.svg.line().interpolate("basis").x((d) ->
      console.log(d.date)
      x d.date
    ).y((d) ->
      y d.duration
    )

    svg = d3.select(div).append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    $.get url, (data) ->

      color.domain data.map((object) ->
        d3.keys(object).filter((key) ->
          key isnt "date"
          )
      )

      data.forEach((d) ->
        d.date = parseDate(d.date);
      )

      jobs = color.domain().map((name) ->
        name: name
        values: data.map((d) ->
          if d.date and d[name]
            date: d.date
            duration: +d[name]
          else
            false
        )
      )

      jobs.forEach((job) ->
        values = job.values.filter((value) ->
          value isnt false
        )
        job.values = values.map((job) ->
          date: job.date
          duration: job.duration
        )
      )

      x.domain d3.extent(data, (d) ->
        d.date
      )
      y.domain [d3.min(jobs, (c) ->
        d3.min c.values, (v) ->
          v.duration

      ), d3.max(jobs, (c) ->
        d3.max c.values, (v) ->
          v.duration
      )]

      svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
      svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text "duration (seconds)"
      job = svg.selectAll(".job").data(jobs).enter().append("g").attr("class", "job")
      job.append("path").attr("class", "line").attr("d", (d) ->
        line d.values
      ).style("stroke", (d) ->
        color d.name
      ).style("fill", "none")

      job.append("text").datum((d) ->
        name: d.name
        value: d.values[d.values.length - 1]
      ).attr("transform", (d) ->
        "translate(" + x(d.value.date) + "," + y(d.value.duration) + ")"
      ).attr("x", 3).attr("dy", ".35em").text (d) ->
        d.name


  window.ChartsController = new ChartsController()
