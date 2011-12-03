window.appModel = new AppModel

colorLegend = new ColorLegend el: "#legend"
mostPopularColors = new ColorHorizontalBarGraph el: "#mostPopular"
colorPictogram = new ColorPictogram el: "#pictogram"

appModel.bind "change", (model) ->
  switch model.tab()
    when "color"
      colorLegend.render model.vehicles()
      mostPopularColors.render model.vehicles()
      colorPictogram.render model.vehicles()

$(document).ready ->
  $.getJSON "stolenvehicles.json", (vehicles) ->
    appModel.set vehicles: vehicles, tab: "color"
    $(".tabs").on "change", (e) -> appModel.set tab: e.target.id

  # tracking
  appModel.bind "change:tab", (model, tab) -> mpq.track "New Tab: #{tab}"

  trackHover = -> mpq.track "Hovered over car"
  $(document).on "mouseover", "#pictogram rect", (_.throttle trackHover, 1000)

  trackScroll = -> mpq.track "Scrolled"
  $(document).on "scroll", (_.throttle trackScroll, 1000)
