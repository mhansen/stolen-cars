window.GraphView = Backbone.View.extend
  render: (model) ->
    data = model.data()
    $(@el).empty()
    days = {}
    for car in data
      car.dateReportedStolen = d3.time.day.utc(new Date(car.dateReportedStolen))
      if not days[car.dateReportedStolen]
        days[car.dateReportedStolen] = []
      days[car.dateReportedStolen].push car
    days = _.toArray(days)
    for day in days
      day.sort (a,b) -> if a.color < b.color then 1 else -1

    maxCarsPerDay = d3.max(days, (d) -> d.length)

    window.minDate = d3.min(data, (d) -> d.dateReportedStolen)
    window.maxDate = d3.max(data, (d) -> d.dateReportedStolen)
    numDays = (maxDate - minDate) / (24 * 60 * 60 * 1000)

    width = 880
    height = 7000
    ypadding = 30
    xpadding = 60

    carheight = (height / numDays) - 2
    carwidth = (width / maxCarsPerDay) - 2

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", width + xpadding).
      attr("height", height + 2 * ypadding)

    y = d3.time.scale().
      domain([minDate, new XDate(maxDate).addDays(1)]).
      range([ypadding, height + ypadding])

    x = d3.scale.linear().
      domain([0, maxCarsPerDay + 1]).
      range([xpadding, width + xpadding])

    groups = svg.selectAll("g").
      data(days).
      enter().
      append("svg:g").
      attr("day", (d) -> d[0].dateReportedStolen.toUTCString())

    groups.selectAll("rect").
      data((d) -> d).
      enter().
      append("svg:rect").
      attr("y", (d) -> y(d.dateReportedStolen)).
      attr("x", (d, i) -> x(i)).
      attr("rx", 5).
      attr("width", carwidth).
      attr("height", carheight).
      attr("fill", (d) -> d.color).
      attr("stroke", "black")
    
    svg.selectAll("line.yLabels").
      data(y.ticks(d3.time.days.utc)).
      enter().
      append("svg:text").
      text(d3.time.format("%d/%m/%y")).
      attr("x", xpadding).
      attr("y", y).
      attr("text-anchor", "end").
      attr("dominant-baseline", "central").
      attr("class", "yLabels").
      attr("dy", carheight/2).
      attr("dx", "-0.5em")
