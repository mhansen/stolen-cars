window.YearHistogram = Backbone.View.extend
  bottomPadding: 50
  topPadding: 30
  barPadding: 0
  barWidth: 15
  height: 500
  leftPadding: 20
  rightPadding: 20

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
    for year in years
      year.toString = -> @key

    $(@el).append $("<h5>Age of Stolen Vehicles</h5>")

    @width = (@barWidth + @barPadding) * years.length

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", @leftPadding + @width + @rightPadding).
      attr("height", @topPadding + @height + @bottomPadding)

    x = d3.scale.ordinal().
      domain(years).
      rangeBands([@leftPadding, @leftPadding + @width])

    barHeight = d3.scale.linear().
      domain([0, d3.max(years, (d) -> d.values)]).
      range([0, @height])

    svg.selectAll("rect.bar").
      data(years, (d) -> d.key).
      enter().
      append("svg:rect").
      attr("class", "bar").
      attr("x", (d, i) -> x(i)).
      attr("y", @topPadding + @height).
      attr("width", @barWidth).
      attr("height", 0).
      attr("fill", (d) -> colorScale(d.key)).
      attr("stroke", "black").
      on("mouseover.highlight", ->
        d3.select(this).attr("fill", "white")
      ).
      on("mouseout.highlight", (d) ->
        d3.select(this).attr("fill", colorScale(d.key))
      ).
      transition().
      duration(1000).
      delay((d, i) -> i * 40).
      attr("height", (d) -> barHeight d.values).
      attr("y", (d, i) => @topPadding + @height - barHeight(d.values))

    svg.selectAll("text.yLabel").
      data(years).
      enter().
      append("svg:text").
      attr("x", (d, i) -> x(i)).
      attr("y", @height + @topPadding).
      attr("text-anchor", "middle").
      attr("dominant-baseline", "central").
      attr("class", "yLabel").
      attr("dx", +@barWidth/2).
      attr("dy", 10).
      text((d) ->
        number = parseInt(d.key)
        if not number
          d.key
        else if number % 10 == 0
          d.key
        else
          ""
      )

    @$("rect.bar").twipsy
      html: false
      title: -> "" + "#{@__data__.key}: #{@__data__.values} Vehicles"
      offset: 2
      placement: "above"
