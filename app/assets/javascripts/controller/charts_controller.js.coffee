class ChartsController
  
  constructor: ->

  generate_donut: (url,div) ->
    width = 500
    height = 500
    radius = Math.min(width, height) / 2

    color = d3.scale.ordinal().range(["#54cd42", "#db5151"])

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
        color d.data.count

      g.append("text").attr("transform", (d) ->
        "translate(" + arc.centroid(d) + ")"
      ).attr("dy", ".35em").style("text-anchor", "middle").text (d) ->
        d.data.key if d.data.count > 0

  window.ChartsController = new ChartsController()