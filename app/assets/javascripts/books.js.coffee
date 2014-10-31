$(".select-book").change ->
  alert "something in double quotes"
 $.get "book/update?id=" + $(this).val(), (data, status) ->
   alert data  if status is "success"
   return
return