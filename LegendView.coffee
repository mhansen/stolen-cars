window.LegendView = Backbone.View.extend
  render: (appModel, legendModel) ->
    cars = appModel.data()

    switch appModel.tab()
      when "color"
        colors = {}
        for car in cars
          if colors[car.color]
            colors[car.color]++
          else
            colors[car.color] = 1
        colorArray = for color, freq of colors
          { color: color, freq: freq }
        colorArray.sort (a, b) -> b.freq - a.freq

    template = """<h5>Legend</h5>
    <ul class="clearfix">
    {{#colors}}
    <li class="span2">
      <div class="square" style="background-color:{{color}}">
      </div>
      {{color}}
      {{^color}}No color{{/color}}
      ({{freq}})
    </li>
    {{/colors}}
    </ul>"""

    $(@el).html Mustache.to_html template, colors: colorArray

    $(@el).append $("<h5>Most Popular Stolen Vehicle Colors</h5>")

    width = 840
    leftPadding = 70
    rightPadding = 30
    
    height = 300
    barheight = (height / colorArray.length) - 3

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", leftPadding + width + rightPadding).
      attr("height", height)

    y = d3.scale.linear().
      domain([0, colorArray.length]).
      range([0, height])

    barwidth = d3.scale.linear().
      domain([0, d3.max(colorArray, (d) -> d.freq)]).
      range([0, width])

    svg.selectAll("rect").
      data(colorArray).
      enter().
      append("svg:rect").
      attr("x", leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("width", (d) -> barwidth(d.freq)).
      attr("height", barheight).
      attr("fill", (d) -> d.color or "white").
      attr("stroke", "black")

    svg.selectAll("text.colorName").
      data(colorArray).
      enter().
      append("svg:text").
      attr("x", leftPadding).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "end").
      attr("dominant-baseline", "central").
      attr("class", "labels").
      attr("dy", barheight/2).
      attr("dx", "-0.5em").
      text((d) -> d.color or "No color").
      attr("class", "colorName")

    svg.selectAll("text.colorFreq").
      data(colorArray).
      enter().
      append("svg:text").
      attr("x", (d) -> leftPadding + barwidth(d.freq)).
      attr("y", (d, i) -> y(i)).
      attr("text-anchor", "start").
      attr("dominant-baseline", "central").
      attr("class", "colorFreq").
      attr("dy", barheight/2).
      attr("dx", "+0.5em").
      text((d) -> d.freq)

