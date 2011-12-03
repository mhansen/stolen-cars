window.LegendModel = Backbone.Model.extend
  createLegend: (colorKey) ->
    @set compareFunction: switch colorKey
      when "color"
        (a, b) -> if a.color > b.color then 1 else -1
      when "make"
        (a, b) -> if a.make + a.model > b.make + b.model then 1 else -1
      when "year"
        (a, b) -> a.year - b.year

    @set colorFunction: switch colorKey
      when "color"
        # Color simply based on the color of the car.
        (d) -> d.color or "white"
      when "make"
        (d) ->
          # The top 10 popular brands get colors
          brand_colors =
            Nissan: "#1f77b4", Toyota: "#ff7f0e"
            Trailer: "#2ca02c", Subaru: "#d62728"
            Mitsubishi: "#9467bd", Honda: "#8c564b"
            Mazda: "#e377c2", Ford: "#7f7f7f"
            Holden: "#bcbd22", Suzuki: "#17becf"
          if brand_colors[d.make] then brand_colors[d.make]
          else "grey" # All the unpopular brands get grey
      when "year"
        colorScale = d3.scale.linear().
          # Each decade gets its own color, fading into white.
          domain([1980,     1989,   1990, 1999,   2000,   2009,   2010,  2012]).
          range(["#704214","white","red","white","green","white","blue","white"]).
          clamp(true)
        (d) -> colorScale(d.year)