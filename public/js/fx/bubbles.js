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

  var render = function(data) {
    var packedBubbleLayout = bubble.nodes({ children: data })
      .filter(function(d) { return !d.children; });

    var nodes = svg.selectAll(".node")
      .data(packedBubbleLayout);
      
    nodes.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { 
        var spawnPosition = randomOffScreenPosition();
        return "translate(" + spawnPosition.x * 2 + "," + spawnPosition.y * 2 + ")"; 
      })
      .append("circle")
        .style("fill", function(d) { return generateColor(); })
        .attr("r", 0)
        .transition()
          .attr("r", function(d) { return d.r; });
    
    // text
    nodes.append("text")
      .attr("dy", ".3em")
      .style("text-anchor", "middle")
      .style("fill","black")
      .text(function(d) { return d.name; });

    var circles = nodes.select('circle')

    // circles.attr('stroke', function(d) { return 'red'; })
    //   .attr('stroke-opacity', 0.8)
    //   .attr('stroke-width', 2)    

    // transitions
    nodes.transition()
      .duration(1000)
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })

    circles.transition()
      .duration(1000)
      .attr("r", function (d) { return d.r; })
  }

  var generateColor = function() {
    return ('00000'+(Math.random()*(1<<24)|0).toString(16)).slice(-6);
  };

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

