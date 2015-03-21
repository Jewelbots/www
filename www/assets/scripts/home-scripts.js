$(document).ready(function(){
	F2_remove_preloader();
	F5_size_section_cta_top();
	
	var timer;
	timer = window.setTimeout( function(){ F2_slideshow_play('next'); }, F2_delay);

	$(window).resize(); //-- and force
});

$(window).scroll(function(){
	F4_add_sticky_header();
	F4_CTA_modal_init();
});

$(window).resize(function(){
	F5_size_section_cta_top();	
	F5_hide_navigation_mobile();	
});

$(window).bind('orientationchange', function(event) {

	F5_size_section_cta_top();
	F3_override_home_link();
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
//-- hiode nav
function F5_hide_navigation_mobile(){
	if($(window).width()>767){
		$('.header ul.navigation').css({'display':'none'});
	}
}
//
//
//-- fade in CTA modal
var F4_modal_was_open = 0;
function F4_CTA_modal_init(){
	if($(window).scrollTop() > $(window).height() * 2){
		F4_CTA_modal('open');
	}
}
function F4_CTA_modal(state){
	if(state=='close'){
		$('#modal_cta form').stop().animate({'opacity':'0.0', 'top':'0%'}, 500, function() {
			$('#modal_cta').stop().animate({'opacity':'0.0'}, 200, function() {
				$('#modal_cta').stop().hide();
			});
		});
	}
	if(state=='open' && F4_modal_was_open != 1){
		F4_modal_was_open = 1;
		$('#modal_cta').stop().show().animate({'opacity':'1.0'}, 500, function() { /* do nothing */ });
		$('#modal_cta form').stop().show().animate({'top':'40%'}, 200, function() { /* do nothing */ });
	}
}
$('#modal_cta form a.close').click(function(){ F4_CTA_modal('close'); });
$('#modal_cta .background').click(function(){ F4_CTA_modal('close'); });
$('#modal_cta .background').click(function(){ F4_CTA_modal('close'); });
//
//
//-- size the initial slideshow

function F5_size_section_cta_top(){
	var F5_height = 3;

	$('#section_cta_top').css({'height': $('#site_container').width()/1.333-70+'px' });
	$('#section_cta_top').css({'max-height': $(window).height()-20 });
}
//
//
//-- rotate opening slideshow
var F2_current_image	= 1;
var F2_max				= 3;
var F2_delay			= 2000;
var F2_transition		= 3000;

function F2_slideshow_play(direction){
	if(direction="next" && F2_current_image < F2_max){
		$('#slide_'+F2_current_image).stop().animate({'opacity':'0.0'}, F2_transition, function() {
			F2_current_image = F2_current_image + 1;
			timer = window.setTimeout( function(){ F2_slideshow_play('next'); }, F2_delay);
		});
	} else {
		F2_slideshow_rewind();
	}
}
function F2_slideshow_rewind(direction){
	$('#slide_1').stop().animate({'opacity':'1.0'}, F2_transition, function() {
		$( ".slideshow .slides" ).each(function( index ) {
			$(this).css('opacity', "1.0");
		});
		F2_current_image = 1;
		timer = window.setTimeout( function(){ F2_slideshow_play('next'); }, F2_delay);
	});
}
//
//
//-- switch class of copy for how it works
function F7_change_color(color){
	
	$('#section_how').removeClass('color_1');
	$('#section_how').removeClass('color_2');
	$('#section_how').removeClass('color_3');
	
	if(color=="c1"){
		$('#section_how').addClass('color_1');
	}
	if(color=="c2"){
		$('#section_how').addClass('color_2');
	}
	if(color=="c3"){
		$('#section_how').addClass('color_3');
	}
}