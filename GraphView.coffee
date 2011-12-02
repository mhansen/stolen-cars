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

    width = 800
    height = 880 * 3
    ypadding = 30
    xpadding = 50
    carheight = 13
    carwidth = 17

    cars = d3.select(@el).
      append("svg:svg").
      attr("width", width + 2 * xpadding).
      attr("height", height + 2 * ypadding)

    minDate = d3.min(data, (d) -> d.dateReportedStolen)
    maxDate = d3.max(data, (d) -> d.dateReportedStolen)
    y = d3.time.scale().
      domain([minDate, maxDate]).
      range([ypadding, height + ypadding])

    maxCarsPerDay = d3.max(days, (d) -> d.length)
    x = d3.scale.linear().
      domain([0, maxCarsPerDay + 1]).
      range([xpadding, width + xpadding])

    groups = cars.selectAll("g").
      data(days).
      enter().
      append("svg:g").
      attr("day", (d) -> d[0].dateReportedStolen)

    groups.selectAll("rect").
      data((d) -> d).
      enter().
      append("svg:rect").
      attr("y", (d) -> y(d.dateReportedStolen)).
      attr("x", (d, i) -> x(i)).
      attr("rx", 5).
      attr("width", carwidth).
      attr("height", carheight).
      attr("fill", (d) -> d.color)
    
    #cars.selectAll("line.yLabels").
      #data(x.ticks(10)).
      #enter().
      #append("svg:text").
      #text(x.tickFormat(10)).
      #attr("x", x).
      #attr("y", height).
      #attr("text-anchor", "middle").
      #attr("class", "xLabels").
      #attr("dy", "1.5em")
