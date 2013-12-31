describe("Reporting", function() {
  describe("responsifyTable", function() {
    it("adds table headers as data attributes to table cells", function() {

      var table = $("<table>" +
        "<thead>" +
          "<tr>" +
            "<th>First Header</th>" +
            "<th>Second Header</th>" +
          " </tr>" +
        "</thead>" +
        "<tbody>" +
          "<tr>" +
            "<td>Some data</td>" +
            "<td>Some more data</td>" +
          "</tr>" +
        "</tbody>" +
      "</table>");

      addResponsiveMetadataToTable(table);

      expect(table.find("td:nth-child(1)").attr("data-heading")).toEqual("First Header");
      expect(table.find("td:nth-child(2)").attr("data-heading")).toEqual("Second Header");
    });
  });
});
