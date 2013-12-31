var addResponsiveMetadataToTable = function(table) {
  var headerTexts = [],
      headers = table.find("thead th"),
      rows = table.find("tbody tr");

  headers.each(function(index, header) {
    headerTexts.push(header.textContent);
  });

  rows.each(function(index, row) {
    $(row).children().each(function(index, cell) {
      $(cell).attr("data-heading", headerTexts[index]);
    });
  });
};

$(function() {
  var reportingGraphIsAvailable = function() {
    return $("#reporting-graph").length > 0;
  }

  if (reportingGraphIsAvailable()) {
    var reportingTable = $(".reporting table")[0];
    var context = $("#reporting-graph").get(0).getContext("2d");

    addResponsiveMetadataToTable($(reportingTable));

    var options = {
      responsive: true,
      maintainAspectRatio: false,
      barShowStroke: false,
      tooltipXPadding: 10,
      tooltipYPadding: 6,
    };

    var data = {
      labels: window.reportingData["labels"],
      datasets: [{
        label: "Total Craftsmen",
        fillColor: "rgba(29,177,129,1.0)",
        highlightFill: "rgba(29,177,129,0.5)",
        data: window.reportingData["total craftsmen"],
      }, {
        label: "Total Residents",
        fillColor: "rgba(83,242,174,1)",
        highlightFill: "rgba(83,242,174,0.5)",
        data: window.reportingData["total residents"],
      }, {
        label: "Total Finishing Residents",
        fillColor: "rgba(21,94,73,1.0)",
        highlightFill: "rgba(21,94,73,0.5)",
        data: window.reportingData["total finishing residents"],
      }]
    };

    var chart = new Chart(context).Bar(data, options);
    $("#reporting-graph-legend").append(chart.generateLegend());
  }
});
