ready = ->
  $ ->
    $('.add-author').click( ->
      $(this).remove()
    )
    $('.remove-author').click( ->
      $(this).parent().remove()
    )


$(document).ready(ready)
$(document).on('page:load', ready)

