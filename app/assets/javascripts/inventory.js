var sendData = function(id) {
	book_id = '.book_' + id.toString();
	dataObjects = $(book_id).serializeArray();

	$.ajax({
		type: "POST",
		url: '/update_checklist_item',
		data: {
			id: id,
			book: {
				title: dataObjects[0].value,
				publisher: dataObjects[1].value,
				publish_date: dataObjects[2].value,
				publication_place: dataObjects[3].value,
				language: dataObjects[4].value,
				pages: dataObjects[5].value,
				location: dataObjects[6].value,
				count: dataObjects[7].value
			}
		},
		dataType: 'json',
		success: function(data) {
			alert(data.status);
		},
		error: function () {
			alert("error");
		}
	});
}
