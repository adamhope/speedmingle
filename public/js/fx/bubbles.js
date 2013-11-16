function bubble(opts) {
  var w = opts.width,
      h = opts.height;

  var diameter = 600 - 30,
      limit=5000,
      format = d3.format(",d"),
      color = d3.scale.category20c();

  var bubble = d3.layout.pack()
      .value(function(d) { return d.value; })
      .sort(null)
      .size([w, h])
      .padding(1.5);


  var svg = d3.select("#bubbles").append("svg:svg")
    .attr("width", w)
    .attr("height", h)
    .attr("class", "bubble");

  var generateColor = function() {
    return ('00000'+(Math.random()*(1<<24)|0).toString(16)).slice(-6);
  };

  var render = function(data) {  
    var packedBubbleLayout = bubble.nodes({ children: data })
      .filter(function(d) { return !d.children; });

    var node = svg.selectAll(".node")
      .data(packedBubbleLayout);
      
    node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
      .append("circle")
        .style("fill", function(d) { return generateColor(); })
        .attr('stroke', function(d) { return 'red'; })
        .attr('stroke-opacity', 0.8)
        .attr('stroke-width', 2)
        .attr("r", 0)
        .transition()
          .attr("r", function(d) { return d.r; });
        
    // text
    node.append("text")
      .attr("dy", ".3em")
      .style("text-anchor", "middle")
      .style("fill","black")
      .text(function(d) { return d.name; });

    // transitions
    node.transition()
      .duration(1000)
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })

    node.select("circle")
      .transition()
      .duration(1000)
      .attr("r", function (d) { return d.r; })
  }

  return {
    render: render
  }
}

