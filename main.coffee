window.appModel = new AppModel

legendView = new LegendView
  el: "#legend"

graphView = new GraphView
  el: "#graph"

tooltipView = new TooltipView
  el: "#tooltip"

appModel.bind "change", (model) ->
  legendView.render model
  graphView.render model
  tooltipView.render graphView.carElements()
  console.log model.get "tab"

$.getJSON "stolenvehicles.json", (data) ->
  appModel.set
    data: data

  $(".tabs").on "change", (e) ->
    appModel.set
      tab: e.target.id
