window.TooltipView = Backbone.View.extend
  className: "popover left"
  render: () ->
    console.log "rendered tooltip"
  remove: () ->
    console.log "removed tooltip"
