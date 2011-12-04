window.ColorLegend = Backbone.View.extend
  render: (vehicles) ->
    entries = d3.nest().
      key((d) -> d.color or "No Color").
      rollup((d) -> d.length).
      entries(vehicles)

    entries.sort (a, b) -> b.values - a.values

    template = """<h5>Legend</h5>
    <ul class="clearfix">
    {{#data}}
    <li class="span2">
      <div class="square" style="background-color:{{key}}">
      </div>
      {{key}}
      ({{values}})
    </li>
    {{/data}}
    </ul>"""
    $(@el).html Mustache.to_html template, data: entries
