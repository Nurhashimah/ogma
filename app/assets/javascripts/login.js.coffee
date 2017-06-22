jQuery ->
  $('#search_icno').autocomplete
    minLength: 2
    source: $('#search_icno').data('autocomplete-source')