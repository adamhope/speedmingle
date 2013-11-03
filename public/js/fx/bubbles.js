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

  var nodes = bubble.nodes({children: data})

  this.addNode = function(node) {
    nodes.push(node);
  };

  this.getNodes = function() {
    return {children: nodes};
  };

  this.render = function() {    
    var svg = d3.select("#bubbles").append("svg")
        .attr("width", w)
        .attr("height", h)
        .attr("class", "bubble");
    
    var node = svg.selectAll(".node")
      .data(nodes.filter(function(d) { return !d.children; }));
      
    var nodeEnter = node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
      .append("circle").attr("r", function(d) { return d.r; });
  }

  this.run = function(data) {
    data.forEach(function(node) { 
      this.addNode(node);
    });

    this.render();
  };
  this.run(data);
};
