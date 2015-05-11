$(function() {
  $(document).on("click","#sortable-table th a, #sortable-table .pagination a", function() {
    $.getScript(this.href);
    return false;
  });
});