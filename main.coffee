window.appModel = new AppModel
legendModel = new LegendModel
legendView = new LegendView el: "#legend"
pictogramGraphView = new PictogramGraphView el: "#graph"
tooltipView = new TooltipView el: "#tooltip"

appModel.bind "change", (model) ->
  legendModel.createLegend model.get "tab"
  legendView.render model, legendModel
  pictogramGraphView.render model, legendModel
  tooltipView.render pictogramGraphView.carElements()

$.getJSON "stolenvehicles.json", (data) ->
  appModel.set
    data: data
    tab: "color"

  $(".tabs").on "change", (e) ->
    appModel.set tab: e.target.id

# tracking
appModel.bind "change:tab", (model, tab) -> mpq.track "New Tab: #{tab}"

trackHover = -> mpq.track "Hovered over car"
$(document).on "mouseover", "#graph rect", _.throttle trackHover, 1000

trackScroll = -> mpq.track "Scrolled"
$(document).on "scroll", (_.throttle trackScroll, 1000)
