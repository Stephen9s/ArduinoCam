// Custom script loaded by mobile application
// On mobileinit, change the error message and "disable" ajax; I believe this refers to ajax navigation
$(document).on("mobileinit", function() {
	$.extend($.mobile, {
		pageLoadErrorMessage: "Error!",
	  			ajaxEnabled: false
	  		});
});
