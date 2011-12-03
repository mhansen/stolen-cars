window.LegendView = Backbone.View.extend
  render: (data) ->
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
    $(@el).html Mustache.to_html template, data: data
