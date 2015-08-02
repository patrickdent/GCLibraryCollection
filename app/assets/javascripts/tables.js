$(function() {
  $(document).on("click","#sortable-table th a, #sortable-table .pagination a", function() {
    $.getScript(this.href);
    return false;
  });
});

$(function() {
  $(document).on("click",".tablesorter th", function() {
    $(".tablesorter th a").toggleClass("asc")
    $(".tablesorter th a").toggleClass("desc")
    return false;
  });
});