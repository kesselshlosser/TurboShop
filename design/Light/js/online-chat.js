(function ($) {
	"use strict";
	$(document).on('click', '.i-trigger-open', function() {
		var newPosition = -$('.chaty-widget-social').length * 100 + '%';
		$('.chaty-widget-is').css('top', newPosition);
		$('#chaty-widget').addClass('chaty-widget-show');
		$('#chaty-widget').removeClass('none-widget-show');
	});
	$(document).on('click', '.i-trigger-close', function() {
		
		$('#chaty-widget').removeClass('chaty-widget-show');
		$('#chaty-widget').addClass('none-widget-show');
	});
})(jQuery); 	