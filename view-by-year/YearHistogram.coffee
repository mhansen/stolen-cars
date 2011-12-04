window.YearHistogram = Backbone.View.extend
  width: 790
  leftPadding: 120
  rightPadding: 30
  barHeight: 20
  barPadding: 3

  render: (vehicles) ->
    $(@el).empty()

    colorScale = d3.scale.linear().
      # Each decade gets its own color, fading into white.
      domain([1980,     1989,   1990,  1999,
              2000,     2009,   2010,  2012  ]).
      range([ "#704214","white","red", "white",
              "green",  "white","blue","white"]).
      clamp(true)

    years = d3.nest().
      key((d) -> d.year or "No Year").
      rollup((d) -> d.length).
      entries(vehicles)
    years.sort (a, b) -> b.key - a.key

    $(@el).append $("<h5>Most Popular Stolen Vehicle Years</h5>")

    @height = (@barHeight + @barPadding) * years.length

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", @leftPadding + @width + @rightPadding).
      attr("height", @height)

    y = d3.scale.linear().
      domain([0, years.length]).
      range([0, @height])

    barwidth = d3.scale.linear().
      domain([0, d3.max(years, (d) -> d.values)]).
      range([0, @width])

    svg.selectAll("rect").
      data(years).
      enter().
      append("svg:rect").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("width", (d) -> barwidth(d.values)).
      attr("height", @barHeight).
      attr("fill", (d) -> colorScale(d.key)).
      attr("stroke", "black")

    svg.selectAll("text.yLabel").
      data(years).
      enter().
      append("svg:text").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "end").
      attr("dominant-baseline", "central").
      attr("class", "yLabel").
      attr("dy", @barHeight/2).
      attr("dx", "-0.5em").
      text((d) -> d.key)

    svg.selectAll("text.freq").
      data(years).
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
