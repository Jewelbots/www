$(document).ready(function(){
	index_section_hero('playvideo'); /* uncomment iframe in hero section to play it */
	$(window).resize(); //-- and force
	header();
});

$(window).scroll(function(){
	header();
/*
	if($(window).scrollTop() > 1000 && open_fixed_delay == 1){
		$('#modal_newsletter').addClass('fixed');
		$('#modal_newsletter').stop().show().animate({'opacity':'1.0'}, 500, function() {});
	}
*/
	$(window).resize(); //-- and force
});

$(window).resize(function(){

});

$(window).bind('orientationchange', function(event) {
	$(window).resize(); //-- and force
});


//--------------------------------------------------------------------------------------//
//
//
//-- scroll(id, shift) ------------------------------------//
function scroll(id, shift){
	$('html,body').stop().animate({scrollTop: $(id).offset().top -shift}, 700);
	/*
	var stop = $(id).offset().top;
	var delay = 700;
	$('body,html').animate({scrollTop: stop}, delay);
	return false;
	*/
}
//
//
//-- header(state) -------------------------------------------------------//
function header(state){
	if($(window).width() > 768){
		if($(window).scrollTop() > 1){
			$('.go .header_default').addClass('header_sticky');
		} else {
			$('.go .header_default').removeClass('header_sticky');
		}
	} else {
		$('.go .header_default').addClass('header_sticky');
	}
}
//
//
//-- index_section_hero(state) -------------------------------------------//
function index_section_hero(state){
	if(state=='playvideo'){
		//-- 1: load video
		(function(d){
			var hero_video_iframe = d.getElementById('hero_video_iframe');
			hero_video_iframe.src ='https://player.vimeo.com/video/153084824?autoplay=1&loop=1&color=ff0179&title=0&byline=0&portrait=0';
		})(document);
		//-- 2: size video
		if($(window).width() / $(window).height() < 1.78){
			$('.index .section_hero iframe').css('height', $(window).height() +90 );
			$('.index .section_hero iframe').css('width', ($(window).height() +90)*1.78 );
		} else {
			$('.index .section_hero iframe').css('width', $(window).width() + +90 );
			$('.index .section_hero iframe').css('height', ($(window).width() +90)/1.78 );
		}
	}
}
//
//
//-- index_section_specs(action) -----------------------------------------//
var section_specs = 'no';
function index_section_specs(action){
	if(action=='open'){
		$('.index .section_specs').stop(true, true).slideToggle( 'slow', function() { /* do nothing */ });
		$('.index .section_meet a.specs').animate({ opacity: 0.0 }, 500, function() {
			$('.index .section_meet a.specs').css({'display': 'none'});
		});
		scroll('#section_specs', '70');
		section_specs = 'yes';
	}
}
//
//
//-- index_section_faqs(action) ------------------------------------------//
$('.more').click(function() {
	/* for all site's more buttons */
	
	//-- 1 (if open, change copy)
	if( $(this).hasClass("more_active") ){
		$(this).removeClass("more_active");
		$(this).parent().children('.folder').stop(true, true).slideUp(1000, function() {
			/* do nothing*/
		});
	} else {
		//-- 2 (open, change copy)
		$(this).addClass("more_active");
		$(this).parent().children('.folder').stop(true, true).slideDown(1000, function() {
			/* do nothing*/
		});
	}
});
$('.section_faqs .question').click(function() {
	//-- 1 (if open)
	if( $(this).parent().children('.answer').hasClass( "answer_active" ) ){
		$(this).parent().children('.answer').removeClass("answer_active");
		$(this).parent().children('.answer').stop(true, true).slideUp(300, function() {
			/* do nothing*/
		});
	} else {
		//-- 2 (close all)
		$(".answer_active").each(function(){
			$(this).removeClass("answer_active");
			$(this).stop(true, true).slideUp(300, function() {
				/* do nothing*/
			});
		});
		//-- 3 (and open the one in question)		
		$(this).parent().children('.answer').addClass("answer_active");
		$(this).parent().children('.answer').stop(true, true).slideDown(300, function() {
			/* do nothing*/
		});
	}
});