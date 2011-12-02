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

    width = 600
    height = 500
    ypadding = 30
    xpadding = 30

    cars = d3.select(@el).
      append("svg:svg").
      attr("width", width + xpadding).
      attr("height", height + ypadding)

    minDate = d3.min(data, (d) -> d.dateReportedStolen)
    maxDate = d3.max(data, (d) -> d.dateReportedStolen)
    x = d3.time.scale().
      domain([minDate, maxDate]).
      range([0, width])

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
      attr("width", 4).
      attr("height", 4).
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


    #data = [{ year: 2006, books: 54},
            #{ year: 2007, books: 43}
            #{ year: 2008, books: 41}
            #{ year: 2009, books: 44}
            #{ year: 2010, books: 35}]
    #barWidth = 40
    #width = (barWidth + 10) * data.length
    #height = 200
    #padding = 30
    #x = d3.scale.linear().domain([0, data.length]).range([0, width])
    #y = d3.scale.linear().domain([0, d3.max(data, (d) -> d.books)]).
      #rangeRound([0, height])

    #barDemo = d3.select(@el).
      #append("svg:svg").
      #attr("width", width).
      #attr("height", height + padding)

    #barDemo.selectAll("rect").
      #data(data).
      #enter().
      #append("svg:rect").
      #attr("x", (d, i) -> x(i)).
      #attr("y", (d, i) -> height - y(d.books)).
      #attr("height", (d, i) -> y(d.books)).
      #attr("width", barWidth).
      #attr("fill", "#2d578b")

    #barDemo.selectAll("text").
      #data(data).
      #enter().
      #append("svg:text").
      #attr("x", (d, i) -> x(i) + barWidth).
      #attr("y", (d) -> height - y(d.books)).
      #attr("dx", -barWidth/2).
      #attr("dy", "1.2em").
      #attr("text-anchor", "middle").
      #text((d) -> d.books).
      #attr("fill", "white")

    #barDemo.selectAll("text.xAxis").
      #data(data).
      #enter().
      #append("svg:text").
      #attr("x", (d, i) -> x(i) + barWidth).
      #attr("y", height).
      #attr("dx", -barWidth/2).
      #attr("dy", "1.2em").
      #attr("text-anchor", "middle").
      #text((d) -> d.year).
      #attr("fill", "black").
      #attr("class", "xAxis")
