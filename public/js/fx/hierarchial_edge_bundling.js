var ctx = $('#hiearchial-edge-bundling');

var w = 1280,
    h = 800,
    rx = w / 2,
    ry = h / 2,
    m0,
    rotate = 0;

var splines = [];

var cluster = d3.layout.cluster().size([360, ry - 120]);

var bundle = d3.layout.bundle();

var line = d3.svg.line.radial()
    .interpolate("bundle")
    .tension(.85)
    .radius(function (d) {
        return d.y;
    })
    .angle(function (d) {
        return d.x / 180 * Math.PI;
    });

var div = d3.select('.visualization-body', ctx);

var svg = div.append('svg')
    .attr("width", w)
    .attr("height", w)
    .append("svg:g")
    .attr("transform", "translate(" + rx + "," + ry + ")");

d3.json("/participants/connections", function (connections) {
    var nodes = cluster.nodes(packages.root(connections)),
        links = packages.votedForBy(nodes),
        splines = bundle(links);

    var path = svg.selectAll("path.link")
        .data(links)
        .enter().append("svg:path")
        .attr("class", function (d) {
            return "link source-" + d.source.key + " target-" + d.target.key;
        })
        .attr("d", function (d, i) {
            return line(splines[i]);
        });

    svg.selectAll("g.node")
        .data(nodes.filter(function (n) {
            return !n.children;
        }))
        .enter().append("svg:g")
        .attr("class", "node")
        .attr("id", function (d) {
            return "node-" + d.key;
        })
        .attr("transform", function (d) {
            return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")";
        })
        .append("svg:text")
        .attr("dx", function (d) {
            return d.x < 180 ? 8 : -8;
        })
        .attr("dy", ".31em")
        .attr("text-anchor", function (d) {
            return d.x < 180 ? "start" : "end";
        })
        .attr("transform", function (d) {
            return d.x < 180 ? null : "rotate(180)";
        })
        .text(function (d) {
            return d.name;
        })
        .on("mouseover", mouseover)
        .on("mouseout", mouseout);
});

function mouseover(d) {
    svg.selectAll("path.link.target-" + d.key)
        .classed("target", true)
        .each(updateNodes("source", true));

    svg.selectAll("path.link.source-" + d.key)
        .classed("source", true)
        .each(updateNodes("target", true));
}

function mouseout(d) {
    svg.selectAll("path.link.source-" + d.key)
        .classed("source", false)
        .each(updateNodes("target", false));

    svg.selectAll("path.link.target-" + d.key)
        .classed("target", false)
        .each(updateNodes("source", false));
}

function updateNodes(name, value) {
    return function (d) {
        if (value) this.parentNode.appendChild(this);
        svg.select("#node-" + d[name].key).classed(name, value);
    };
}

var packages = {
    root: function (connections) {
        var map = {};

        function find(name, data) {
            var node = map[name], i;
            if (!node) {
                node = map[name] = data || {name: name, children: []};
                if (name.length) {
                    node.parent = find(name.substring(0, i = name.lastIndexOf(".")));
                    node.parent.children.push(node);
                    node.key = name.substring(i + 1).replace(/\s+/g,"-").replace(/'/,"_");
                }
            }
            return node;
        }

        connections.forEach(function (d) {
            find(d.name, d);
        });

        return map[''];
    },

    votedForBy: function (nodes) {
        var map = {},
            numbers = [];

        // Compute a map from name to node.
        nodes.forEach(function (d) {
            map[d.name] = d;
        });

        nodes.forEach(function (d) {
            if (d.connect_from) d.connect_from.forEach(function (i) {
                numbers.push({source: map[d.name], target: map[i]});
            });
        });

        return numbers;
    }
};