ready = ->
  $ ->
    $('#report-results').hide()
    $('#report-selector').change ->
      $('#report-results').show()
      return

$(document).ready(ready)
$(document).on('page:load', ready)
