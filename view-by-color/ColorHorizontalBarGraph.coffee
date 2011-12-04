window.ColorHorizontalBarGraph = Backbone.View.extend
  width: 840
  leftPadding: 70
  rightPadding: 30
  barHeight: 20
  barPadding: 3

  render: (vehicles) ->
    $(@el).empty()

    colors = d3.nest().
      key((d) -> d.color).
      rollup((d) -> d.length).
      entries(vehicles)

    colors.sort (a, b) -> b.values - a.values

    $(@el).append $("<h5>Most Popular Stolen Vehicle Colors</h5>")

    @height = (@barHeight + @barPadding) * colors.length

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", @leftPadding + @width + @rightPadding).
      attr("height", @height)

    y = d3.scale.linear().
      domain([0, colors.length]).
      range([0, @height])

    barwidth = d3.scale.linear().
      domain([0, d3.max(colors, (d) -> d.values)]).
      range([0, @width])

    svg.selectAll("rect").
      data(colors).
      enter().
      append("svg:rect").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("width", (d) -> barwidth(d.values)).
      attr("height", @barHeight).
      attr("fill", (d) -> d.key or "white").
      attr("stroke", "black")

    svg.selectAll("text.colorName").
      data(colors).
      enter().
      append("svg:text").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "end").
      attr("dominant-baseline", "central").
      attr("class", "labels").
      attr("dy", @barHeight/2).
      attr("dx", "-0.5em").
      text((d) -> d.key or "No Color").
      attr("class", "colorName")

    svg.selectAll("text.freq").
      data(colors).
      enter().
      append("svg:text").
      attr("x", (d) => @leftPadding + barwidth(d.values)).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "start").
      attr("dominant-baseline", "central").
      attr("class", "freq").
      attr("dy", @barHeight/2).
      attr("dx", "+0.5em").
      text((d) -> d.values)
