ready = ->
  $ ->
    $(".tablesorter").tablesorter theme: "blue" 
    return

$(document).ready(ready)
$(document).on('page:load', ready)