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

  var nodes2 = [];

  
  var svg = d3.select("#bubbles").append("svg:svg")
    .attr("width", w)
    .attr("height", h)
    .attr("class", "bubble");

  var addNode = function(node) {
    var nodePresent = _.findWhere(nodes2, {id: node.id})
    if (nodePresent !== undefined) {
      nodePresent = node;
    } else {
      nodes2.push(node);
    }
  };

  var getNodes = function() {
    var copiedNodes = $.map(nodes2, function (obj) {
        return $.extend(true, {}, obj);
    });
    return { 
      children: copiedNodes
    };
  };

  var render = function() {  
    var nodes = bubble.nodes(getNodes())  

    var node = svg.selectAll(".node")
      .data(nodes.filter(function(d) { return !d.children; }));
      
    node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
      .append("circle")
        .attr("r", function(d) { return d.r; })
        .style("fill", function(d) { return "red"; });


    // transitions
    node.transition()
      .duration(1000)
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })

    node.select("circle")
      .transition()
      .duration(1000)
      .attr("r", function (d) { return d.r; })
  }

  var update = function(data) {
    data.forEach(function(node) {
      addNode(node);
    });
    render();
  };

  var init = function(data) {
    data.forEach(function(node) {
      addNode(node);
    });
    render();
  };

  return {
    render: render,
    update: update,
    init: init
  }
}

