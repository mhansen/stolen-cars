window.MakeHorizontalBarGraph = Backbone.View.extend
  width: 790
  leftPadding: 120
  rightPadding: 30
  barHeight: 20
  barPadding: 3

  render: (vehicles) ->
    $(@el).empty()
    makeColors =
      Nissan: "#1f77b4", Toyota: "#ff7f0e"
      Trailer: "#2ca02c", Subaru: "#d62728"
      Mitsubishi: "#9467bd", Honda: "#8c564b"
      Mazda: "#e377c2", Ford: "#7f7f7f"
      Holden: "#bcbd22", Suzuki: "#17becf"

    makes = d3.nest().
      key((d) -> d.make).
      entries(vehicles)

    makes.sort (a, b) ->
      b.values.length - a.values.length

    $(@el).append $("<h5>Most Popular Stolen Vehicle Makes</h5>")

    @height = (@barHeight + @barPadding) * makes.length

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", @leftPadding + @width + @rightPadding).
      attr("height", @height)

    y = d3.scale.linear().
      domain([0, makes.length]).
      range([0, @height])

    barwidth = d3.scale.linear().
      domain([0, d3.max(makes, (d) -> d.values.length)]).
      range([0, @width])

    svg.selectAll("rect").
      data(makes).
      enter().
      append("svg:rect").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("width", (d) -> barwidth(d.values.length)).
      attr("height", @barHeight).
      attr("fill", (d) -> makeColors[d.key] or "grey").
      attr("stroke", "black")

    svg.selectAll("text.yLabel").
      data(makes).
      enter().
      append("svg:text").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "end").
      attr("dominant-baseline", "central").
      attr("class", "yLabel").
      attr("dy", @barHeight/2).
      attr("dx", "-0.5em").
      text((d) -> d.key or "No Make")

    svg.selectAll("text.freq").
      data(makes).
      enter().
      append("svg:text").
      attr("x", (d) => @leftPadding + barwidth(d.values.length)).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "start").
      attr("dominant-baseline", "central").
      attr("class", "freq").
      attr("dy", @barHeight/2).
      attr("dx", "+0.5em").
      text((d) -> d.values.length)
