var sendData = function(id) {
	book_id = '.book_' + id.toString();
	dataObjects = $(book_id).serializeArray();
	params = {}
	for(var i=0;i<dataObjects.length;i++){
		params[dataObjects[i].name] = dataObjects[i].value;
	}

	$.ajax({
		type: "POST",
		url: '/update_checklist_item',
		data: {
			id: id,
			book: params
		},
		dataType: 'json',

		success: function(data) {
			// TODO: update form values with returned value from controller
			if(data.status === 'ok'){
				displayMessage("Saved!");
			}
			else if(data.status === 'unprocessable entity'){
				displayMessage("Error, could not save");
			}
		},
		error: function () {
			displayMessage("Error, could not save");
		}
	});
}

var displayMessage = function(message){
	$('#ajax-messages').html(message);
	setTimeout(function() { $('#ajax-messages').html(""); }, 2000);
}
