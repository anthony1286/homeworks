// from data.js
var tableData = data;

// Select the filter button
var submit = d3.select("#filter-btn");

submit.on("click", function() {

	// Prevent the page from refreshing
	d3.event.preventDefault();
  
	// Select the date input element and get the raw HTML node
	var inputElement = d3.select("#datetime");
  	// Get the value property of the input element
	var inputValue = inputElement.property("value");


	// Select the city input element and get the raw HTML node
	var cityElement = d3.select("#cityName");
  	// Get the value property of the input element
	var cityValue = cityElement.property("value").toLowerCase();
  
	console.log(inputValue);
	console.log(cityValue);

	// If statement to filter results correctly if one or both inputs are filled in
	if (inputValue.length > 0 && cityValue.length > 0) {
		var filteredData = tableData.filter(function(ufo) {
			return ufo.datetime == inputValue &&
				ufo.city == cityValue;
			})
	  } if (inputValue.length > 0 && cityValue.length == 0) {
		var filteredData = tableData.filter(function(ufo) {
			return ufo.datetime == inputValue;
			})
	  } if (inputValue.length == 0 && cityValue.length > 0) {
		var filteredData = tableData.filter(function(ufo) {
			return ufo.city == cityValue;
			})
	  }

	console.log(filteredData);

	// Get a reference to the table body
	var tbody = d3.select("#ufo-table");

	// Loop through the data and append a line for each result
	filteredData.forEach(function(ufoSightings) {
		console.log(ufoSightings);
		var row = tbody.append("tr");
		Object.entries(ufoSightings).forEach(function([key, value]) {
		console.log(key, value);
		// Append a cell to the row for each value
		var cell = row.append("td");
		cell.text(value);
		});
	})});