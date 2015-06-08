ready = ->
  $ ->
    $('#report-results').hide()
    $('#report-selector').change ->
      if $('#report-selector').val() == "book-popularity"
        $.ajax
          type: "get",
          url: '/genres.json'
          success: (data, status, response) ->
            selector = "<select id='genre-selector'>
                      <option value=''>All Categories</option>"
            for genre in data
              selector += "<option value='" + genre.id + "''>" + genre.name + "</option>"
            selector +=  "</select>"
            $('#reports-form').append(selector)

          error: ->
           # Hard error
          dataType: "json"

      $(document).on 'change', '#genre-selector', ->
        $('#reports-form').append("<button type='submit'>Submit</button>")
        return

      $('#reports-form').submit ->
        $.ajax
          url: 'build_report.json'
          type: 'POST'
          data :
            report: $('#report-selector').val()
            genre: $('#genre-selector').val()
          success: (data, status, response) ->
           # when ok response recieved
            $('#report-results').show()
            # data is the object that contains all info returned
          error: ->
            # Hard error
          dataType: "json"

        return false


$(document).ready(ready)
$(document).on('page:load', ready)
