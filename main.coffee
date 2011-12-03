window.appModel = new AppModel

legendView = new LegendView
  el: "#legend"

tooltipView = new TooltipView
  el: "#tooltip"

graphView = new GraphView
  el: "#graph"
  onmouseover: (data, event) ->
    tooltipView.render()

appModel.bind "change:data", (model) ->
  legendView.render model
  graphView.render model

$.getJSON "stolenvehicles.json", (data) ->
  appModel.set
    data: data
