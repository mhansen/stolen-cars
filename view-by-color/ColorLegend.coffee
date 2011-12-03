window.ColorLegend = Backbone.View.extend
  render: (vehicles) ->
    h = {}
    for car in vehicles
      if h[car.color]
        h[car.color]++
      else
        h[car.color] = 1
    freqs = for key, freq of h
      { text: key or "No Color", color: key, freq: freq }
    freqs.sort (a, b) -> b.freq - a.freq

    template = """<h5>Legend</h5>
    <ul class="clearfix">
    {{#data}}
    <li class="span2">
      <div class="square" style="background-color:{{color}}">
      </div>
      {{text}}
      {{^text}}No color{{/text}}
      ({{freq}})
    </li>
    {{/data}}
    </ul>"""
    $(@el).html Mustache.to_html template, data: freqs
