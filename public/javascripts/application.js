$(function () {
  $("#sortable-table th a, #sortable-table .pagination a").live('click', function () {
    $.getScript(this.href);
    return false;
  });
});