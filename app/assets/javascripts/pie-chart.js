/**
 * ustwo™ Jenkins Dashboard pie chart scripts.
 * @author: nuno@ustwo.co.uk (Nuno Coelho Santos)
 */

// Variables.
var w = 600; // Pie chart width.
var h = 600; // Pie chart height.
var r = 300; // Pie chart radius.
var textOffset = 15; // Distance of the text from the pie chart.
var tweenDuration = 800; // Duration of the animation.
var interval = 7000; // Duration of the pause between data sets.

// Variables to be filled with data.
var lines, valueLabels, nameLabels;
var pieData = [];
var oldPieData = [];
var filteredPieData = [];

// D3 helper function to populate pie slice parameters from array data.
var donut = d3.layout.pie().value(function(d){
  return d.octetTotalCount;
});

// D3 helper function to draw arcs, populates parameter "d" in path object.
var arc = d3.svg.arc()
  .startAngle(function(d){ return d.startAngle; })
  .endAngle(function(d){ return d.endAngle; })
  .outerRadius(r);

// Generate fake data.
var arrayRange = 100; //range of potential values for each item
var slices;
var streakerDataAdded;

function fillArray() {
  return {
    labels: [
      "Passed",
      "Skipped",
      "Failed",
    ],
    octetTotalCount: Math.ceil(Math.random()*(arrayRange))
  };
}

// Variable for the visualisation.
var vis = d3.select(".pie-chart").append("svg:svg")
  .attr("width", w)
  .attr("height", h);

// Group for paths.
var arc_group = vis.append("svg:g")
  .attr("class", "arc")
  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");

// Group for labels.
var label_group = vis.append("svg:g")
  .attr("class", "label_group")
  .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");


/**
 * Streaker connection.
 */

var updateInterval = window.setInterval(update, interval);

// To run each time data is generated
function update() {

  slices = 3; // Number of slices
  streakerDataAdded = d3.range(slices).map(fillArray);

  oldPieData = filteredPieData;
  pieData = donut(streakerDataAdded);

  var totalOctets = 0;
  filteredPieData = pieData.filter(filterData);
  function filterData(element, index, array) {
    element.name = streakerDataAdded[index].labels[index];
    element.value = streakerDataAdded[index].octetTotalCount;
    totalOctets += element.value;
    return (element.value > 0);
  }

  if (filteredPieData.length > 0 && oldPieData.length > 0) {

    /**
     * Draw arc paths.
     */
    paths = arc_group.selectAll("path").data(filteredPieData);

    // Enter.
    paths.enter().append("svg:path")
      .attr("fill", function(d, i) {return "hsl(273.24, 52.11%, " + (i * -5 + 27.84) + "%)";})
      .attr("stroke", function(d, i) {return "hsl(273.24, 52.11%, " + (i * -5 + 27.84) + "%)";})
      .transition()
        .duration(tweenDuration)
        .attrTween("d", pieTween);

    // Update.
    paths
      .transition()
        .duration(tweenDuration)
        .attrTween("d", pieTween);

    // Exit.
    paths.exit()
      .transition()
        .duration(tweenDuration)
        .attrTween("d", removePieTween)
      .remove();

    /**
     * Draw project name labels.
     */
    nameLabels = label_group.selectAll("text.units").data(filteredPieData)
      .attr("dy", function(d){
        // If the label is on the upper half of the chart.
        if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
          // return 5;
          return 15;
        }
        // If the label is on the lower half of the chart.
        else {
          // return -15;
          return 0;
        }
      })
      // Define if the text should be left-aligned or right-aligned depending
      // if the label is on the right side or left side of the pie chart.
      .attr("text-anchor", function(d){
        if ((d.startAngle+d.endAngle)/2 < Math.PI ) {
          return "beginning";
        } else {
          return "end";
        }
      }).text(function(d){
        return d.name;
      });

    // Enter.
    nameLabels.enter().append("svg:text")
      .attr("class", "units")
      .attr("transform", function(d) {
        return "translate(" + Math.cos(((d.startAngle+d.endAngle - Math.PI)/2)) * (r+textOffset) + "," + Math.sin((d.startAngle+d.endAngle - Math.PI)/2) * (r+textOffset) + ")";
      })
      .attr("dy", function(d){
        // If the label is on the upper half of the chart.
        if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
          // return 5;
          return 15;
        }
        // If the label is on the lower half of the chart.
        else {
          // return -15;
          return 0;
        }
      })
      .attr("text-anchor", function(d){
        if ((d.startAngle+d.endAngle)/2 < Math.PI ) {
          return "beginning";
        } else {
          return "end";
        }
      }).text(function(d){
        return d.name;
      });

    // Update.
    nameLabels
      .transition()
        .duration(tweenDuration)
        .attrTween("transform", textTween);

    // Exit;
    nameLabels
      .exit()
      .remove();

    /**
     * Draw percentage labels.
     */
    valueLabels = label_group.selectAll("text.value").data(filteredPieData)
      .attr("dy", function(d){
        if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
          return 25;
        } else {
          return 5;
        }
      })
      // Define if the text should be left-aligned or right-aligned depending
      // if the label is on the right side or left side of the pie chart.
      .attr("text-anchor", function(d){
        if ( (d.startAngle+d.endAngle)/2 < Math.PI ){
          return "beginning";
        } else {
          return "end";
        }
      })
      .text(function(d){
        var percentage = (d.value/totalOctets)*100;
        return percentage.toFixed(1) + "%";
      });

    // Enter.
    valueLabels.enter().append("svg:text")
      .attr("class", "value")
      .attr("transform", function(d) {
        return "translate(" + Math.cos(((d.startAngle+d.endAngle - Math.PI)/2)) * (r+textOffset) + "," + Math.sin((d.startAngle+d.endAngle - Math.PI)/2) * (r+textOffset) + ")";
      })
      .attr("dy", function(d){
        if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
          return 25;
        } else {
          return 5;
        }
      })
      // Define if the text should be left-aligned or right-aligned depending
      // on which side of the pie it is.
      .attr("text-anchor", function(d){
        if ( (d.startAngle+d.endAngle)/2 < Math.PI ){
          return "beginning";
        } else {
          return "end";
        }
      }).text(function(d){
        var percentage = (d.value/totalOctets)*100;
        return percentage.toFixed(1) + "%";
      });

    // Update.
    valueLabels
      .transition()
        .duration(tweenDuration)
        .attrTween("transform", textTween);

    // Exit.
    valueLabels
      .exit()
      .remove();
  }
}

/**
 * Functions.
 */

// Interpolate the arcs in data space.
function pieTween(d, i) {
  var s0;
  var e0;
  if(oldPieData[i]){
    s0 = oldPieData[i].startAngle;
    e0 = oldPieData[i].endAngle;
  } else if (!(oldPieData[i]) && oldPieData[i-1]) {
    s0 = oldPieData[i-1].endAngle;
    e0 = oldPieData[i-1].endAngle;
  } else if(!(oldPieData[i-1]) && oldPieData.length > 0){
    s0 = oldPieData[oldPieData.length-1].endAngle;
    e0 = oldPieData[oldPieData.length-1].endAngle;
  } else {
    s0 = 0;
    e0 = 0;
  }
  var i = d3.interpolate({startAngle: s0, endAngle: e0}, {startAngle: d.startAngle, endAngle: d.endAngle});
  // Update the color based on the index.

  return function(t) {
    var b = i(t);
    return arc(b);
  };
}

// Remove the arcs from the data space.
function removePieTween(d, i) {
  s0 = 2 * Math.PI;
  e0 = 2 * Math.PI;
  var i = d3.interpolate({startAngle: d.startAngle, endAngle: d.endAngle}, {startAngle: s0, endAngle: e0});
  return function(t) {
    var b = i(t);
    return arc(b);
  };
}

// Interpolate the text labels in data space.
function textTween(d, i) {
  var a;
  if(oldPieData[i]){
    a = (oldPieData[i].startAngle + oldPieData[i].endAngle - Math.PI)/2;
  } else if (!(oldPieData[i]) && oldPieData[i-1]) {
    a = (oldPieData[i-1].startAngle + oldPieData[i-1].endAngle - Math.PI)/2;
  } else if(!(oldPieData[i-1]) && oldPieData.length > 0) {
    a = (oldPieData[oldPieData.length-1].startAngle + oldPieData[oldPieData.length-1].endAngle - Math.PI)/2;
  } else {
    a = 0;
  }
  var b = (d.startAngle + d.endAngle - Math.PI)/2;

  var fn = d3.interpolateNumber(a, b);
  return function(t) {
    var val = fn(t);
    return "translate(" + Math.cos(val) * (r+textOffset) + "," + Math.sin(val) * (r+textOffset) + ")";
  };
}
