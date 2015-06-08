ready = ->
  $ ->
    $('#report-selector').change ->
      if $('#report-selector').val() == "book-popularity"
        $.ajax
          type: "get",
          url: '/genres.json'
          success: (data, status, response) ->
            selector = "<select id='genre-selector' name='genre'>
                      <option value=''>All Categories</option>"
            for genre in data
              selector += "<option value='" + genre.id + "''>" + genre.name + "</option>"
            selector +=  "</select>"
            $('#reports-form').append(selector)

          error: ->
           # TODO: how do show user error?
          dataType: "json"

      $(document).on 'change', '#genre-selector', ->
        $('#reports-form').append("<button type='submit'>Submit</button>")
        return

$(document).ready(ready)
$(document).on('page:load', ready)
