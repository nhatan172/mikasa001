// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

var amountScrolled = 30;

$(document).on('ready page:load', function(){
	$("a.internal_link").on('click', function(event) {
		if (this.hash !== "") {
			event.preventDefault();

			var hash = this.hash;
			console.log(hash);

			$('html, body').animate({
				scrollTop: $(hash).offset().top
			}, 1100, function(){
		
			window.location.hash = hash;
			});
		}
	});

	$( "div #mark_modifed" ).on( "click", function() {
		var curr = $(this);
	  curr.prev(".modified_info").css("display", "block");
	});

	$(".close_modified_info").click(function(){
		var curr = $(this).parentsUntil(".modified_info").parent(".modified_info")
		curr.css("display", "none");
	});


	$(".modified_info").on('click',function(event) {
	        $(".modified_info").css("display", "none");
	}).on('click','.modified_info_content',function(e){
		e.stopPropagation();
	});

	$('a.back-to-top-btn').click(function() {
		$('html, body').animate({
			scrollTop: 0
		}, 1050);
		return false;
	});
});

	
$(window).scroll(function() {
	if ( $(window).scrollTop() > amountScrolled ) {
		$('div.back-to-top').fadeIn('slow');
	} 
	else {
		$('div.back-to-top').fadeOut('slow');
	}
});
