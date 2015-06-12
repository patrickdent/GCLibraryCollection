$(document).on('click', '.remove-author',  ->
  $(this).parent().remove()
)

$(document).on('click', '.primary-radio-true', ->
  id = $(this).attr('id')
  $('.primary-radio-false').each ->
    $(@).prop("checked", true) unless $(@).attr('id') is id
)