ready = ->
  $ ->
    $(':submit').hide()
    $('#report-selector').change ->
      $('#genre-selector').remove()
      if $('#report-selector').val() == "book-popularity"
        $.ajax
          type: "get",
          url: '/genres.json'
          success: (data, status, response) ->
            selector = "<fieldset  id='genre-selector'>
                          <label>Select a Category</label>
                          <select name='genre' required='required'>
                            <option></option>
                            <option value=''>All Categories</option>"
            for genre in data
              selector += "<option value='" + genre.id + "''>" + genre.name + "</option>"
            selector +=  "</select></fieldset>"
            $('#reports-form').append(selector).trigger('create')

          error: ->
           # TODO: how do show user error?
          dataType: "json"

      $(document).on 'change', '#genre-selector', ->
        if $(':submit').is(':hidden')
          $(':submit').show()
        return

$(document).ready(ready)
$(document).on('page:load', ready)
