window.YearHistogram = Backbone.View.extend
  bottomPadding: 50
  topPadding: 30
  barPadding: 0
  barWidth: 15
  height: 500
  leftPadding: 30

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
      key((d) -> d.year or "NA").
      rollup((d) -> d.length).
      entries(vehicles)
    years.sort (a, b) ->
      if a.key > b.key then 1
      else if a.key < b.key then -1
      else 0

    $(@el).append $("<h5>Age of Stolen Vehicles</h5>")

    @width = (@barWidth + @barPadding) * years.length

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", @leftPadding + @width).
      attr("height", @topPadding + @height + @bottomPadding)

    x = d3.scale.linear().
      domain([0, years.length]).
      range([@leftPadding, @leftPadding + @width])

    barHeight = d3.scale.linear().
      domain([0, d3.max(years, (d) -> d.values)]).
      range([0, @height])

    svg.selectAll("rect.bar").
      data(years).
      enter().
      append("svg:rect").
      attr("class", "bar").
      attr("x", (d, i) -> x(i)).
      attr("y", (d, i) => @topPadding + @height - barHeight(d.values)).
      attr("width", @barWidth).
      attr("height", (d) -> barHeight d.values).
      attr("fill", (d) -> colorScale(d.key)).
      attr("stroke", "black")

    svg.selectAll("text.yLabel").
      data(years).
      enter().
      append("svg:text").
      attr("y", (d, i) -> -x(i)).
      attr("x", @height + @topPadding).
      attr("text-anchor", "start").
      attr("dominant-baseline", "central").
      attr("class", "yLabel").
      attr("dy", -@barWidth/2).
      attr("dx", 10).
      text((d) -> if d.key.match /\d{4}/ then "'#{d.key.substring(2)}" else d.key).
      attr("transform", "rotate(90)")

    @$("rect.bar").twipsy
      html: false
      title: -> "" + "#{@__data__.key}: #{@__data__.values} Vehicles"
      offset: 2
      placement: "above"
