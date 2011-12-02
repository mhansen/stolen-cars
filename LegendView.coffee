window.LegendView = Backbone.View.extend
  render: (data, groupBy) ->
    $(@el).text "rendered, grouping by " + groupBy
