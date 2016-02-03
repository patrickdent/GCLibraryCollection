$(document).on('click', '.book-import-form #add-isbn',  ->
  newISBN = "<fieldset>
    <label for='isbn[]' class='ignore-caps'>enter ISBN</label>
    <input name='isbn[]''>
  </fieldset>"
  $('.book-import-form .isbn-container').append(newISBN).trigger('create')
)