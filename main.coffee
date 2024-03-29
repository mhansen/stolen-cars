appModel = new AppModel

colorLegend = new ColorLegend el: "#color .legend"
mostPopularColors = new ColorHorizontalBarGraph el: "#color .mostPopular"
colorPictogram = new ColorPictogram el: "#color .pictogram"

makeLegend = new MakeLegend el: "#make .legend"
mostPopularMakes = new MakeHorizontalBarGraph el: "#make .mostPopular"
makePictogram = new MakePictogram el: "#make .pictogram"

yearHistogram = new YearHistogram el: "#year .histogram"
yearPictogram = new YearPictogram el: "#year .pictogram"

appModel.bind "change", (model) ->
  switch model.tab()
    when "#color"
      colorLegend.render model.vehicles()
      mostPopularColors.render model.vehicles()
      colorPictogram.render model.vehicles()
    when "#make"
      makeLegend.render model.vehicles()
      mostPopularMakes.render model.vehicles()
      makePictogram.render model.vehicles()
    when "#year"
      yearHistogram.render model.vehicles()
      yearPictogram.render model.vehicles()

$(document).ready ->
  d3.text "stolenvehicles.csv", (text) ->
    vehicles = d3.csv.parseRows text, (d) ->
      plate: d[0]
      color: d[1]
      make: d[2]
      model: d[3]
      year: parseInt d[4]
      type: d[5]
      dateString: d[6]
      date: d3.time.day.utc(new Date(d[6]))
      region: d[7]

    appModel.set
      tab: "#year"
      vehicles: vehicles

    $(".tabs").on "change", (e) -> appModel.set tab: e.target.hash

  # tracking
  appModel.bind "change:tab", (model, tab) -> mpq.track "New Tab: #{tab}"

  trackHover = -> mpq.track "Hovered over car"
  $(document).on "mouseover", ".pictogram rect", (_.throttle trackHover, 1000)

  trackScroll = -> mpq.track "Scrolled"
  $(document).on "scroll", (_.throttle trackScroll, 1000)
