window.appModel = new AppModel

legendView = new LegendView
  el: "#legend"

graphView = new GraphView
  el: "#graph"

tooltipView = new TooltipView
  el: "#tooltip"

appModel.bind "change:data", (model) ->
  legendView.render model
  graphView.render model
  tooltipView.render graphView.carElements()

$.getJSON "stolenvehicles.json", (data) ->
  appModel.set
    data: data
