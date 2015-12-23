ready = ->
  $ ->
    $('#report-selector').change ->
      $('#submit').remove()
      $('#genre-selector').remove()
      if $('#report-selector').val() == "book-popularity" || $('#report-selector').val() == "unpopular-books"
        appendDateRanges()
      fetchAndAppendGenres()

      $(document).on 'change', '#genre-selector', ->
        $('#submit').remove()
        submit = "<button id='submit' class='go-btn right'>Submit</button>"
        $('#reports-form').append(submit).trigger('create')
        return

fetchAndAppendGenres=()->
  $.ajax
    type: "get",
    url: '/genres.json'
    success: (data, status, response) ->
      selector = "<fieldset  id='genre-selector'>
                    <label>Select a Category</label>
                    <select name='genre' required='required'>
                      <option></option>
                      <option value='all'>All Categories</option>"
      for genre in data
        selector += "<option value='" + genre.id + "''>" + genre.name + "</option>"
      selector +=  "</select></fieldset>"
      $('#genre-selector').remove()
      $('#reports-form').append(selector).trigger('create')
    error: ->
     # TODO: how do show user error?
    dataType: "json"

appendDateRanges=()->
  startDate = "<fieldset  id='date-range-selector'>
                <label>Select a Date Range</label>
                <select name='dates'>
                  <option value=''>Forever</option>
                  <option value='last-week'>Last Week</option>
                  <option value='last-month'>Last Month</option>
                  <option value='last-year'>Last Year</option>
                </select>
              </fieldset>"
  $('#reports-form').append(startDate).trigger('create')

$(document).ready(ready)
$(document).on('page:load', ready)
