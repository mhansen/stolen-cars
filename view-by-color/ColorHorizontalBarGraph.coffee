window.ColorHorizontalBarGraph = Backbone.View.extend
  width: 840
  leftPadding: 70
  rightPadding: 30
  barHeight: 20
  barPadding: 3

  render: (vehicles) ->
    h = {}
    for car in vehicles
      if h[car.color]
        h[car.color]++
      else
        h[car.color] = 1
    freqs = for key, freq of h
      { text: key or "No Color", color: key, freq: freq }
    freqs.sort (a, b) -> b.freq - a.freq

    $(@el).append $("<h5>Most Popular Stolen Vehicle Colors</h5>")

    @height = (@barHeight + @barPadding) * freqs.length

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", @leftPadding + @width + @rightPadding).
      attr("height", @height)

    y = d3.scale.linear().
      domain([0, freqs.length]).
      range([0, @height])

    barwidth = d3.scale.linear().
      domain([0, d3.max(freqs, (d) -> d.freq)]).
      range([0, @width])

    svg.selectAll("rect").
      data(freqs).
      enter().
      append("svg:rect").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("width", (d) -> barwidth(d.freq)).
      attr("height", @barHeight).
      attr("fill", (d) -> d.color or "white").
      attr("stroke", "black")

    svg.selectAll("text.colorName").
      data(freqs).
      enter().
      append("svg:text").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "end").
      attr("dominant-baseline", "central").
      attr("class", "labels").
      attr("dy", @barHeight/2).
      attr("dx", "-0.5em").
      text((d) -> d.text).
      attr("class", "colorName")

    svg.selectAll("text.freq").
      data(freqs).
      enter().
      append("svg:text").
      attr("x", (d) => @leftPadding + barwidth(d.freq)).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "start").
      attr("dominant-baseline", "central").
      attr("class", "freq").
      attr("dy", @barHeight/2).
      attr("dx", "+0.5em").
      text((d) -> d.freq)
