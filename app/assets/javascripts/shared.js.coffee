ready = ->
  $ ->
    $('.tablesorter').tablesorter()
    $('.chosen-select').chosen()
    $('[id^="book-select_"]').change ->
      $.ajax
        type: "POST",
        url: '/list.json'
        data:
          book:
            id: $(this).val()
            selected: $(this).is(':checked')
      return
    return

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
