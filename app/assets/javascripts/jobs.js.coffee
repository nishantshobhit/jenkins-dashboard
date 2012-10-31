# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready(->
	numbers = [4, 8, 15, 16, 23, 12,4, 8, 15, 16, 23, 12,4, 8, 15, 13, 4, 5]
	chartHeight = 298
	 
	chart = d3.select("#container")
	.append("svg")
		.attr("width", "100%")
	    .attr("height", "100%");

	chart.selectAll("rect").data(numbers).enter()
	.append("rect")
		.attr("y", (d, i) -> chartHeight - (d * 10))
		.attr("x", (d, i) -> (i * 20))
		.attr("width", 20 - 1)
		.attr("fill", "teal")
		.attr("height", (d) -> d * 10);
);