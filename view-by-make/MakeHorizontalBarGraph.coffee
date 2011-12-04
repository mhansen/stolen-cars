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
    h = {}
    for car in vehicles
      if h[car.make]
        h[car.make]++
      else
        h[car.make] = 1
    freqs = for make, freq of h
      {
        text: make or "No Make"
        color: if makeColors[make] then makeColors[make] else "grey"
        freq: freq
      }
    freqs.sort (a, b) -> b.freq - a.freq

    $(@el).append $("<h5>Most Popular Stolen Vehicle Makes</h5>")

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
      attr("fill", (d) -> d.color).
      attr("stroke", "black")

    svg.selectAll("text.yLabel").
      data(freqs).
      enter().
      append("svg:text").
      attr("x", @leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "end").
      attr("dominant-baseline", "central").
      attr("class", "yLabel").
      attr("dy", @barHeight/2).
      attr("dx", "-0.5em").
      text((d) -> d.text)

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
