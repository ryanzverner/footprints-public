jQuery ->
  $('#term').autocomplete
      source: "/search_suggestions"
  $('#assigned_craftsman').autocomplete
      source: "/craftsman_suggestions"
  $('#mentor').autocomplete
      source: "/craftsman_suggestions"
