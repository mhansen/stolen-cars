window.HorizontalBarGraph = Backbone.View.extend
  width: 840
  leftPadding: 70
  rightPadding: 30
  height: 300
  barPadding: 3

  render: (data) ->
    $(@el).append $("<h5>Most Popular Stolen Vehicle Colors</h5>")

    barheight = (@height / data.length) - @barPadding

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", @leftPadding + @width + @rightPadding).
      attr("height", @height)

    y = d3.scale.linear().
      domain([0, data.length]).
      range([0, @height])

    barwidth = d3.scale.linear().
      domain([0, d3.max(data, (d) -> d.freq)]).
      range([0, @width])

    svg.selectAll("rect").
      data(data).
      enter().
      append("svg:rect").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("width", (d) -> barwidth(d.freq)).
      attr("height", barheight).
      attr("fill", (d) -> d.color or "white").
      attr("stroke", "black")

    svg.selectAll("text.colorName").
      data(data).
      enter().
      append("svg:text").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "end").
      attr("dominant-baseline", "central").
      attr("class", "labels").
      attr("dy", barheight/2).
      attr("dx", "-0.5em").
      text((d) -> d.text or "No color").
      attr("class", "colorName")

    svg.selectAll("text.colorFreq").
      data(data).
      enter().
      append("svg:text").
      attr("x", (d) -> @leftPadding + barwidth(d.freq)).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "start").
      attr("dominant-baseline", "central").
      attr("class", "colorFreq").
      attr("dy", barheight/2).
      attr("dx", "+0.5em").
      text((d) -> d.freq)
