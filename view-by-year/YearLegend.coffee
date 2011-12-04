window.YearLegend = Backbone.View.extend
  render: (vehicles) ->
    #h = {}
    #for car in vehicles
      #if h[car.make]
        #h[car.make]++
      #else
        #h[car.make] = 1
    #freqs = for make, freq of h
      #{
        #text: make or "No Make"
        #color: if makeColors[make] then makeColors[make] else "grey"
        #freq: freq
      #}
    #freqs.sort (a, b) -> b.freq - a.freq

    #top10 = _.first(freqs, 10)
    #therest = _.rest(freqs, 10)

    #countOfOtherMakes = 0
    #for d in therest
      #countOfOtherMakes += d.freq

    #template = """<h5>Legend</h5>
    #<ul class="clearfix">
    #{{#data}}
    #<li class="span3">
      #<div class="square" style="background-color:{{color}}">
      #</div>
      #{{text}}
      #{{^text}}No color{{/text}}
      #({{freq}})
    #</li>
    #{{/data}}
    #</ul>"""
    #$(@el).html Mustache.to_html template,
      #data: top10.concat [ { text: "Other", color: "grey", freq: countOfOtherMakes } ]
