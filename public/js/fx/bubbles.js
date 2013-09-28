var bubble = function(data, opts) {
  var w = opts.width,
      h = opts.height;

  var diameter = 600 - 30,
      limit=5000,
      format = d3.format(",d"),
      color = d3.scale.category20c();

  var bubble = d3.layout.pack()
      .sort(null)
      .size([w, h])
      .padding(1.5);

  var svg = d3.select("#bubbles").append("svg")
      .attr("width", w)
      .attr("height", h)
      .attr("class", "bubble");

  var display_pack = function(root) {
    var node = svg.selectAll(".node")
        .data(bubble.nodes(root)
        .filter(function(d) { return !d.children; }))
      .enter().append("g")
        .attr("class", "node")
        .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
      .style("fill", function(d) { return generate_color(); })

    node.append("circle").attr("r", function(d) { return d.r; });

    node.append("text")
        .attr("dy", ".3em")
        .style("text-anchor", "middle")
      .style("fill","black")
        .text(function(d) { return d.name; });
  }

  var generate_color = function() {
    return ('00000'+(Math.random()*(1<<24)|0).toString(16)).slice(-6);
  };

  display_pack({children: data});
};
