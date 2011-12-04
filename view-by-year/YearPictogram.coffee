window.YearPictogram = Backbone.View.extend
  render: (vehicles) ->
    $(@el).empty()
    for car in vehicles
      # parse dates from text as UTC
      car.date = d3.time.day.utc(new Date(car.dateReportedStolen))

    days = d3.nest().
      key((d) -> d.dateReportedStolen).
      sortValues((a, b) -> a.year - b.year).
      entries(vehicles)

    days.sort (a, b) -> if b.key > a.key then 1 else -1

    maxVehiclesPerDay = d3.max(days, (d) -> d.values.length)

    window.minDate = d3.min(vehicles, (d) -> d.date)
    window.maxDate = d3.max(vehicles, (d) -> d.date)
    numDays = (maxDate - minDate) / (24 * 60 * 60 * 1000)

    width = 880
    height = 2500
    ypadding = 30
    xpadding = 60
    carpadding = 3

    carheight = (height / numDays) - carpadding
    carwidth = (width / maxVehiclesPerDay) - carpadding

    colorScale = d3.scale.linear().
      # Each decade gets its own color, fading into white.
      domain([1980,     1989,   1990,  1999,
              2000,     2009,   2010,  2012  ]).
      range([ "#704214","white","red", "white",
              "green",  "white","blue","white"]).
      clamp(true)

    $(@el).append $("<h5>All Stolen Vehicle Years, Each Day</h5>")

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", width + xpadding).
      attr("height", height + ypadding)

    y = d3.time.scale().
      domain([new XDate(maxDate).addMinutes(1), minDate]).
      range([0, height - carheight])

    x = d3.scale.linear().
      domain([0, maxVehiclesPerDay + 1]).
      range([xpadding, width + xpadding])

    groups = svg.selectAll("g").
      data(days).
      enter().
      append("svg:g").
      attr("day", (d) -> d.values[0].date.toUTCString())

    makeColors =
      Nissan: "#1f77b4", Toyota: "#ff7f0e"
      Trailer: "#2ca02c", Subaru: "#d62728"
      Mitsubishi: "#9467bd", Honda: "#8c564b"
      Mazda: "#e377c2", Ford: "#7f7f7f"
      Holden: "#bcbd22", Suzuki: "#17becf"

    rects = groups.selectAll("rect.car").
      data((d) -> d.values).
      enter().
      append("svg:rect").
      attr("y", (d) -> y(d.date)).
      attr("x", (d, i) -> x(i)).
      attr("rx", 1).
      attr("ry", 1).
      attr("width", carwidth).
      attr("height", carheight).
      attr("fill", (d) -> colorScale(d.year)).
      attr("stroke", "black").
      attr("class", "car")
    
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

    @$("rect.car").popover
      html: true
      title: ->
        template = "{{ year }} {{ make }} {{ model }}"
        Mustache.to_html template, @__data__
      content: ->
        template = """{{ color }} {{ type }}. <br>
        Reported stolen {{ dateReportedStolen }} from {{ region }} Police District.<br>
        Rego: {{plate}}."""
        Mustache.to_html template, @__data__
      offset: 2
      placement: "right"
