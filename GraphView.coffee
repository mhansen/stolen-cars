window.GraphView = Backbone.View.extend
  render: (model) ->
    data = model.data()
    $(@el).empty()
    days = {}
    for car in data
      car.dateReportedStolen = new Date(car.dateReportedStolen)
      if not days[car.dateReportedStolen]
        days[car.dateReportedStolen] = []
      days[car.dateReportedStolen].push car
    days = _.toArray(days)
    for day in days
      day.sort (a,b) -> if a.color < b.color then 1 else -1

    width = 880 * 3
    height = 800
    ypadding = 30
    xpadding = 30
    carheight = 17
    carwidth = 13

    cars = d3.select(@el).
      append("svg:svg").
      attr("width", width + 2 * xpadding).
      attr("height", height + ypadding)

    minDate = d3.min(data, (d) -> d.dateReportedStolen)
    maxDate = d3.max(data, (d) -> d.dateReportedStolen)
    x = d3.time.scale().
      domain([minDate, maxDate]).
      range([xpadding, width + xpadding])

    maxCarsPerDay = d3.max(days, (d) -> d.length)
    y = d3.scale.linear().
      domain([0, maxCarsPerDay + 1]).
      range([0, height])

    groups = cars.selectAll("g").
      data(days).
      enter().
      append("svg:g").
      attr("day", (d) -> d[0].dateReportedStolen)

    groups.selectAll("rect").
      data((d) -> d).
      enter().
      append("svg:rect").
      attr("x", (d) -> x(d.dateReportedStolen)).
      attr("y", (d, i) -> height - y(i)).
      attr("rx", 5).
      attr("width", carwidth).
      attr("height", carheight).
      attr("fill", (d) -> d.color)
    
    cars.selectAll("line.xLabels").
      data(x.ticks(10)).
      enter().
      append("svg:text").
      text(x.tickFormat(10)).
      attr("x", x).
      attr("y", height).
      attr("text-anchor", "middle").
      attr("class", "xLabels").
      attr("dy", "1.5em")
