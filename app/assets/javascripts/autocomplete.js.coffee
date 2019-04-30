jQuery ->
  $('#term').autocomplete
      source: "/search_suggestions"
  $('#assigned_crafter').autocomplete
      source: "/crafter_suggestions"
  $('#mentor').autocomplete
      source: "/crafter_suggestions"
