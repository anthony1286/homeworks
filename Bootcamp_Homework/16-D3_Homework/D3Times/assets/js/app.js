// @TODO: YOUR CODE HERE!


function makeResponsive() {

  // if the SVG area isn't empty when the browser loads,
  // remove it and replace it with a resized version of the chart
var svgArea = d3.select("body").select("svg");

if (!svgArea.empty()) {
  svgArea.remove();
}

  // svg params
var svgHeight = 500;
var svgWidth = window.innerWidth - 100;

// var svgWidth = 800;
// var svgHeight = 500;

var margin = {
top: 50,
right: 50,
bottom: 75,
left: 50
};

var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;

// Create an SVG wrapper, append an SVG group that will hold our chart, and shift the latter by left and top margins.
var svg = d3.select("#scatter")
.append("svg")
.attr("width", svgWidth)
.attr("height", svgHeight);


// Import Data
var chartGroup = svg.append("g")
.attr("transform", `translate(${margin.left}, ${margin.top})`);

d3.csv("assets/data/data.csv")
.then(function(healthData) {

  // Step 1: Parse Data/Cast as numbers
  // ==============================
  healthData.forEach(function(data) {
    data.poverty = +data.poverty;
    data.healthcare = +data.healthcare;
  });

  // Step 2: Create scale functions
  // ==============================
  var xLinearScale = d3.scaleLinear()
    .domain([d3.min(healthData, d => d.poverty) - 1, d3.max(healthData, d => d.poverty) + 1])
    .range([0, width]);

  var yLinearScale = d3.scaleLinear()
    .domain([d3.min(healthData, d => d.healthcare) - 1, d3.max(healthData, d => d.healthcare) + 1])
    .range([height, 0]);

  // Step 3: Create axis functions
  // ==============================
  var bottomAxis = d3.axisBottom(xLinearScale);
  var leftAxis = d3.axisLeft(yLinearScale);

  // Step 4: Append Axes to the chart
  // ==============================
  chartGroup.append("g")
    .attr("transform", `translate(0, ${height})`)
    .call(bottomAxis);

  chartGroup.append("g")
    .call(leftAxis);

  // Step 5: Create Circles
  // ==============================
  var circlesGroup = chartGroup.selectAll("circle")
  .data(healthData)
  .enter()
  .append("circle")
  .attr("cx", d => xLinearScale(d.poverty))
  .attr("cy", d => yLinearScale(d.healthcare))
  .attr("r", "11")
  .attr("fill", "lightblue")
  .attr("opacity", "1");

  chartGroup.append("text")
    .style("text-anchor", "middle")
    .style("font-size", "9px")
    .style("font-weight", "bold")
    .style("font-family", "arial")
    .style("fill", "white")
    .selectAll("tspan")
    .data(healthData)
    .enter()
    .append("tspan")
        .attr("x", function(data) {
            return xLinearScale(data.poverty);
        })
        .attr("y", function(data) {
            return yLinearScale(data.healthcare - .2);
        })
        .text(function(data) {
            return data.abbr
        });
  // Step 6: Initialize tool tip
  // ==============================
  var toolTip = d3.tip()
    .attr("class", "tooltip")
    .offset([0, 0])
    .html(function(d) {
      return (`${d.state}<br>Poverty Level: ${d.poverty}<br>Healthcare Rating: ${d.healthcare}`);
    });

  // Step 7: Create tooltip in the chart
  // ==============================
  chartGroup.call(toolTip);

  // Step 8: Create event listeners to display and hide the tooltip
  // ==============================
  circlesGroup.on("mouseover", function(data) {
    toolTip.show(data, this);
  })
    // onmouseout event
    .on("mouseout", function(data, index) {
      toolTip.hide(data);
    });



  // Create axes labels
  chartGroup.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 0 - margin.left)
    .attr("x", 0 - ((height/2) + margin.top + margin.bottom))
    .attr("dy", "1em")
    .attr("class", "axisText")
    .text("% of People Lacking Healthcare");

  chartGroup.append("text")
    .attr("transform", `translate(${width/3}, ${height + margin.top})`)
    .attr("class", "axisText")
    .text("% of People in Poverty");
});
}

makeResponsive();

// Event listener for window resize.
// When the browser window is resized, makeResponsive() is called.
d3.select(window).on("resize", makeResponsive);
