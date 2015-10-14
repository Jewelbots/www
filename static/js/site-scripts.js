$(document).ready(function(){
	F2_remove_preloader();
	$(window).resize(); //-- and force
});

$(window).scroll(function(){
	F4_add_sticky_header();
});

$(window).resize(function(){
});

$(window).bind('orientationchange', function(event) {
});


//--------------------------------------------------------------------------------------//
//
//
//-- scroll to a specific ID
function F3_scroll_to_ID(id, shift){
	$('html,body').stop().animate({scrollTop: $(id).offset().top -shift}, 700);
}
//
//
//-- remove preloader once site is loaded // add a bit of delay
function F2_remove_preloader() {
	
	var delay = 500; //-- for testing

	$('#preloader .panel_l').delay(500+delay).animate({ 'width' : '0%' }, 700 );
	$('#preloader .panel_r').delay(500+delay).animate({ 'width' : '0%' }, 700 );
	$('#preloader img').delay(200+delay).animate({ 'opacity' : '0.0' }, 300 );
	$('#preloader').delay(500+delay).animate({'opacity':'0.0'}, 700);
	
	$('#preloader').delay(0+delay).animate({'opacity':'0.0'}, 700, function() {
		$('#preloader').hide();
	});

}
//
//
//-- add sticky header class
function F4_add_sticky_header(){
	if($(window).scrollTop() > 100 && $(window).width()>767){
		$('#header_container .header').addClass('header_sticky');
	} else {
		$('#header_container .header').removeClass('header_sticky');
	}
}
//
//
//-- toggle mobile
function F3_toggle_mobile_nav(){
	$('#header_container ul.navigation').stop(true, true).slideToggle( 'slow', function() { /* do nothing */ });
}
//
//
//-- hide nav
function F5_hide_navigation_mobile(){
	if($(window).width()>767){
		$('.header ul.navigation').css({'display':'none'});
	}
}
//
//
//-- switch class of copy for how it works
function F7_change_color(color){
	
	$('#section_how').removeClass('color_1');
	$('#section_how').removeClass('color_2');
	$('#section_how').removeClass('color_3');/*
	$('#section_how').removeClass('color_4');
	$('#section_how').removeClass('color_5');*/
	
	$('#section_what .circle').removeClass('active');
	
	$('.simulator #option_1_1').stop(true, true).fadeOut(500, function() { /* do nothing as of yet */ });
	$('.simulator #option_1_2').stop(true, true).fadeOut(500, function() { /* do nothing as of yet */ });
	$('.simulator #option_1_3').stop(true, true).fadeOut(500, function() { /* do nothing as of yet */ });
	//$('.simulator #option_1_4').stop(true, true).fadeOut(500, function() { /* do nothing as of yet */ });
	//$('.simulator #option_1_5').stop(true, true).fadeOut(500, function() { /* do nothing as of yet */ });
	
	if(color=="c1"){
		$('#section_how').addClass('color_1');
		$('.simulator #option_1_1').stop(true, true).delay(0).fadeIn(1000, function() { /* do nothing as of yet */ });
		$('.simulator #option_1_gif').attr('src',animation_1.src);
		$('#section_what #circle_1').addClass('active');
	}
	if(color=="c2"){
		$('#section_how').addClass('color_2');
		$('.simulator #option_1_2').stop(true, true).delay(0).fadeIn(1000, function() { /* do nothing as of yet */ });
		$('.simulator #option_1_gif').attr('src',animation_1.src);
		$('#section_what #circle_2').addClass('active');
	}
	if(color=="c3"){
		$('#section_how').addClass('color_3');
		$('.simulator #option_1_3').stop(true, true).delay(0).fadeIn(1000, function() { /* do nothing as of yet */ });
		$('.simulator #option_1_gif').attr('src',animation_1.src);
		$('#section_what #circle_3').addClass('active');
	}
}