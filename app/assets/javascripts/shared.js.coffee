ready = ->
  $ ->
    $(".tablesorter").tablesorter theme: "metro-dark" 
    return

$(document).ready(ready)
$(document).on('page:load', ready)