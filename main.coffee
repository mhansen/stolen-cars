window.appModel = new AppModel

legendView = new LegendView
  el: "#legend"

graphView = new GraphView
  el: "#graph"

appModel.bind "change:data", (model) ->
  legendView.render model
  graphView.render model

$.getJSON "stolenvehicles.json", (data) ->
  appModel.set
    data: data
