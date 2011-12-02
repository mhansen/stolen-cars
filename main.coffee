window.appModel = new AppModel

legendView = new LegendView
  el: "#legend"

graphView = new GraphView
  el: "#graph"

appModel.bind "change:groupBy", (model, groupBy) ->
  legendView.render model, groupBy
  graphView.render model, groupBy

$.getJSON "stolenvehicles.json", (data) ->
  appModel.set
    data: data
    groupBy: "make" # or "region" or "color"
