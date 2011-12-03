window.PictogramGraphView = Backbone.View.extend
  carElements: -> @$("rect")
  render: (model, legendModel) ->
    cars = model.data()
    colorKey = model.get "tab"
    $(@el).empty()
    days = {}
    for car in cars
      # parse dates from text as UTC
      car.date = d3.time.day.utc(new Date(car.dateReportedStolen))

      if not days[car.date]
        days[car.date] = []
      days[car.date].push car

    days = _.toArray(days)

    for day in days
      day.sort legendModel.get "compareFunction"

    maxCarsPerDay = d3.max(days, (d) -> d.length)

    window.minDate = d3.min(cars, (d) -> d.date)
    window.maxDate = d3.max(cars, (d) -> d.date)
    numDays = (maxDate - minDate) / (24 * 60 * 60 * 1000)

    width = 880
    height = 2500
    ypadding = 30
    xpadding = 60
    carpadding = 3

    carheight = (height / numDays) - carpadding
    carwidth = (width / maxCarsPerDay) - carpadding

    $(@el).append $("<h5>All Stolen Vehicle Colors, Each Day</h5>")

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", width + xpadding).
      attr("height", height + ypadding)

    y = d3.time.scale().
      domain([new XDate(maxDate).addMinutes(1), minDate]).
      range([0, height - carheight])

    x = d3.scale.linear().
      domain([0, maxCarsPerDay + 1]).
      range([xpadding, width + xpadding])

    groups = svg.selectAll("g").
      data(days).
      enter().
      append("svg:g").
      attr("day", (d) -> d[0].date.toUTCString())

    rects = groups.selectAll("rect").
      data((d) -> d).
      enter().
      append("svg:rect").
      attr("y", (d) -> y(d.date)).
      attr("x", (d, i) -> x(i)).
      attr("rx", 1).
      attr("ry", 1).
      attr("width", carwidth).
      attr("height", carheight).
      attr("fill", legendModel.get "colorFunction").
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