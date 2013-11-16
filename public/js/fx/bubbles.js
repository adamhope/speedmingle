function bubble(opts) {
  var w = opts.width,
      h = opts.height;

  var diameter = 600 - 30,
      limit=5000,
      format = d3.format(",d"),
      color = d3.scale.category20(),
      transitionDuration = 2000;

  var bubble = d3.layout.pack()
      .value(function(d) { return d.value; })
      .sort(null)
      .size([w, h])
      .padding(2.5);

  var svg = d3.select("#bubbles").append("svg:svg")
    .attr("width", w)
    .attr("height", h)
    .attr("class", "bubble");

  var render = function(data) {
    var packedBubbleLayout = bubble.nodes({ children: data })
      .filter(function(d) { return !d.children; });

    var node = svg.selectAll(".node")
      .data(packedBubbleLayout);
      
    var nodeEnter = node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { 
        var spawnPosition = randomOffScreenPosition();
        return "translate(" + spawnPosition.x * 2 + "," + spawnPosition.y * 2 + ")"; 
      });

    nodeEnter.append("circle")
      .style("fill", function(d) { return d.color = color(d.name); })
      .attr("r", 0)
      .attr('stroke', function(d) { return d3.rgb(d.color).brighter(1); })
      .attr('stroke-width', 2);

      
    nodeEnter.append("text")
      .attr("dy", ".3em")
      .style("text-anchor", "middle")
      .text(function(d) { return d.name; });

    // transitions
    node.select('circle').transition()
      .duration(transitionDuration)
      .attr("r", function(d) { console.log("Updating radius"); return d.r; });

    node.transition()
      .duration(transitionDuration)
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
  }

  var randomOffScreenPosition = function() {
    return {
      1: { x: _.random(0, w), y: 0 },
      2: { x: _.random(0, w), y: h },
      3: { x: 0, y: _.random(0, h) },
      4: { x: w, y: _.random(0, h) }
    }[_.sample([1, 2, 3, 4])]
  }
  
  return {
    render: render
  }
}

