wiundow.LegendModel = Backbone.Model.extend
  createLegend: (colorKey) ->
    @set compareFunction: switch colorKey
      when "year"
        (a, b) -> a.year - b.year

    @set colorFunction: switch colorKey
      when "year"
        colorScale = d3.scale.linear().
          # Each decade gets its own color, fading into white.
          domain([1980,     1989,   1990, 1999,   2000,   2009,   2010,  2012]).
          range(["#704214","white","red","white","green","white","blue","white"]).
          clamp(true)
        (d) -> colorScale(d.year)
