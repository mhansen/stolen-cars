window.ColorPictogram = Backbone.View.extend
  render: (vehicles) ->
    $(@el).empty()

    days = d3.nest().
      key((d) -> d.dateString).
      sortValues((a, b) -> if a.color > b.color then 1 else -1).
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

    $(@el).append $("<h5>All Stolen Vehicle Colors, Each Day</h5>")

    svg = d3.select(@el).
      append("svg:svg").
      attr("width", width + xpadding).
      attr("height", height + ypadding)

    y = d3.time.scale().
      # The ticks() function isn't inclusive of the end of the
      # range, so we need to add a minute to the day to get an
      # axis label for that day.
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
      attr("fill", (d) -> d.color or "white").
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
        Reported stolen {{ dateString }} from {{ region }} Police District.<br>
        Rego: {{plate}}."""
        Mustache.to_html template, @__data__
      offset: 2
      placement: "right"
