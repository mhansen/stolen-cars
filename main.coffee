window.appModel = new AppModel
legendView = new LegendView el: "#legend"
graphView = new GraphView el: "#graph"
tooltipView = new TooltipView el: "#tooltip"

appModel.bind "change", (model) ->
  legendView.render model
  graphView.render model
  tooltipView.render graphView.carElements()
  console.log model.get "tab"

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
