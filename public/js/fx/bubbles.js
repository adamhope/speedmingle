function bubble(opts) {
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

  var nodes = [];

  var svg = d3.select("#bubbles").append("svg:svg")
    .attr("width", w)
    .attr("height", h)
    .attr("class", "bubble");

  var addNode = function(node) {
    var nodePresent = _.findWhere(nodes, {id: node.id})
    if (nodePresent !== undefined) {
      updateNode(node);
    } else {
      node.color = generateColor();
      nodes.push(node);
    }
  };

  var updateNode = function(node) {
    return _.chain(nodes).findWhere({id: node.id}).extend(node).value()
  };

  var generateColor = function() {
    return ('00000'+(Math.random()*(1<<24)|0).toString(16)).slice(-6);
  };

  var render = function() {  

    var node = svg.selectAll(".node")
      .data(bubble.nodes({ children: nodes }).filter(function(d) { return !d.children; }));
      
    node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
      .append("circle")
        .attr("r", function(d) { return d.r; })
        .style("fill", function(d) { return d.color; })
        .attr('stroke', function(d) { return 'red'; })
        .attr('stroke-opacity', 0.8)
        .attr('stroke-width', 2);

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

  var init = function(data) {
    data.forEach(function(node) {
      addNode(node);
    });
    render();
  };

  return {
    init: init
  }
}

