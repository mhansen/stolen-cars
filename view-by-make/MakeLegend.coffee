window.MakeLegend = Backbone.View.extend
  render: (vehicles) ->
    makeColors =
      Nissan: "#1f77b4", Toyota: "#ff7f0e"
      Trailer: "#2ca02c", Subaru: "#d62728"
      Mitsubishi: "#9467bd", Honda: "#8c564b"
      Mazda: "#e377c2", Ford: "#7f7f7f"
      Holden: "#bcbd22", Suzuki: "#17becf"

        #color: if makeColors[make] then makeColors[make] else "grey"

    makes = d3.nest().
      key((d) -> d.make or "No Make").
      rollup((d) -> d.length).
      entries(vehicles)
    console.log makes

    makes.sort (a, b) -> b.values - a.values

    top10 = _.first(makes, 10)
    therest = _.rest(makes, 10)

    countOfOtherMakes = 0
    for d in therest
      countOfOtherMakes += d.values
    data = top10.concat [
      key: "Other",
      values: countOfOtherMakes
    ]

    ul = d3.select(@el).
      append("ul").
      attr("class", "clearfix")

    li = ul.selectAll("li").
      data(data).
      enter().
      append("li").
      attr("class", "span3")

    li.append("div").
      attr("class", "square").
      attr("style", (d) -> "background-color: #{makeColors[d.key] or "grey"}")

    li.append("span").
      text((d) -> "#{d.key or "No Make"} (#{d.values})")
