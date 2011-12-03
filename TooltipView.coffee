window.TooltipView = Backbone.View.extend
  render: ($cars) ->
    $cars.popover
      title: ->
        car = @__data__
        car.make + " " + car.model
      content: ->
        car = @__data__
        car.plate
      offset: 50
      placement: "below"
