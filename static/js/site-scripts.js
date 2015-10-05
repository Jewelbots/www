$(document).ready(function(){
	F2_remove_preloader();
	F5_size_section_cta_top();
	
	F4_CTA_modal('cta_open');
	
	$(".cta_link").click(function(event) {
	  event.preventDefault();
	  F4_CTA_modal('cta_open');
	});
	$(".cta_link_video").click(function(event) {
	  event.preventDefault();
	  F4_CTA_modal('cta_open_video');
	});
	var timer;
	timer = window.setTimeout( function(){ F2_slideshow_play('next'); }, F2_delay);

	$(window).resize(); //-- and force
});

$(window).scroll(function(){
	F4_add_sticky_header();
	//F4_CTA_modal_init();
});

$(window).resize(function(){
	F5_size_section_cta_top();	
//	F5_hide_navigation_mobile();	
});

$(window).bind('orientationchange', function(event) {
	F5_size_section_cta_top();
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
				$('#modal_cta form').css('top', '90%');
				$('#modal_cta').css('visibility', 'hidden');
			});
		});
		$('#modal_cta .video').css('display', 'none');
	}
	if(state=='open' && F4_modal_was_open != 1){
		$('#modal_cta .video').css('display', 'none');
		F4_modal_was_open = 1;
		$('#modal_cta').css('visibility', 'visible');
		$('#modal_cta').stop().show().animate({'opacity':'1.0'}, 500, function() { /* do nothing */ });
		$('#modal_cta form').css('display', 'block');
		$('#modal_cta form').stop().show().animate({
			opacity: 1.0,
			top: "40%"
		}, 200, function() { /* do nothing */ });
	}
	if(state=='cta_open'){
		$('#modal_cta .video').css('display', 'none');
		$('#modal_cta').css('visibility', 'visible');
		$('#modal_cta').stop().show().animate({'opacity':'1.0'}, 500, function() { /* do nothing */ });
		$('#modal_cta form').css('display', 'block');
		$('#modal_cta form').stop().show().animate({
			opacity: 1.0,
			top: "40%"
		}, 200, function() { /* do nothing */ });
	}
	if(state=='cta_open_video'){
		$('#modal_cta .video').css('display', 'block');
		$('#modal_cta').css('visibility', 'visible');
		$('#modal_cta').stop().show().animate({'opacity':'1.0'}, 500, function() { /* do nothing */ });
		$('#modal_cta form').css('display', 'none');
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
	
	$('.index #section_cta_top .slideshow .slides').css({'left': -($('.index #section_cta_top .slideshow .slides').width()-$('#site_container').width())/2 });
	

	/*
	if($('#section_cta_top').height() < 1010 && $(window).width() > 1280){
		$('#section_cta_top .cta').css({'top': $(window).height()-400 });
	} else {
		$('#section_cta_top .cta').css({'top': '' });
	}
	*/

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
	//if(color=="c4"){
	//	$('#section_how').addClass('color_4');
	//	$('.simulator #option_1_4').stop(true, true).delay(0).fadeIn(1000, function() { /* do nothing as of yet */ });
	//	$('.simulator #option_1_gif').attr('src',animation_1.src);
	//	$('#section_what #circle_4').addClass('active');
	//}
	//if(color=="c5"){
	//	$('#section_how').addClass('color_5');
	//	$('.simulator #option_1_5').stop(true, true).delay(0).fadeIn(1000, function() { /* do nothing as of yet */ });
	//	$('.simulator #option_1_gif').attr('src',animation_1.src);
	//	$('#section_what #circle_5').addClass('active');
	//}
}