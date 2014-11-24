ready = ->
  $ ->
    $(".tablesorter").tablesorter theme: "metro-dark" 
    return

$(document).ready(ready)
$(document).on('page:load', ready)

$(document).ready ->
  $('[id^="book-select_"').change ->
    $.ajax
      type: "POST",
      url: '/list.json'
      data:
        book:
          id: $(this).val()
    return
  return

