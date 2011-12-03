window.TooltipView = Backbone.View.extend
  render: ($cars) ->
    $cars.popover
      html: true
      title: ->
        template = "{{ year }} {{ make }} {{ model }}"
        Mustache.to_html template, @__data__
      content: ->
        template = """{{ color }} {{ type }}. <br>
        Reported stolen {{ dateReportedStolen }} from {{ region }} Police District.<br>
        Rego: {{plate}}."""
        Mustache.to_html template, @__data__
      offset: 0
      placement: "right"
