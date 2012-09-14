var capture_click = function(event) {
	return {
		user_id: current_user && current_user.id
		, date_click: new Date
		, page_x: event.pageX
		, page_y: event.pageY
		, window_width:  $(window).width()
		, window_height:  $(window).height()
		, screen_height: screen.height
		, screen_width: screen.width
		, navigator_userAgent: navigator.userAgent
		, navigator_product : navigator.product
		, navigator_language : navigator.language
		, navigator_platform: navigator.platform
		, navigator_javaEnabled: navigator.javaEnabled()
		, url: location.href
		, path_name: location.pathname
	}
};

$(function(){
	$(document).bind({
		click : function(event) {
			console.log(JSON.stringify(capture_click(event)));
		}
	});
});