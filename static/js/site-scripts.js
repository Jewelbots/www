$(document).ready(function(){
	//index_section_hero('playvideo'); /* uncomment iframe in hero section to play it */
	$(window).resize(); //-- and force
});

$(window).scroll(function(){
	header();

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
}
//
//
//-- header(state) -------------------------------------------------------//
function header(state){
	if($(window).scrollTop() > 1){
		$('.index .header_default').addClass('header_sticky');
	} else {
		$('.index .header_default').removeClass('header_sticky');
	}
}
//
//
//-- modal_newsletter(state) ---------------------------------------------//
function modal_newsletter(state){
	if(state=='open_overlay'){
		$('#content_container').addClass('blurred');

		$('#modal_newsletter').addClass('overlay');
		$('#modal_newsletter.overlay').stop().show().animate({'opacity':'1.0'}, 500, function() { /* do nothing */ });
		$('#modal_newsletter.overlay .modal').stop().show().animate({'top':'50%'}, 200, function() { /* do nothing */ });
	}
	if(state=='open_fixed'){
		$('#modal_newsletter').addClass('fixed');
		$('#modal_newsletter').stop().show().animate({'opacity':'1.0'}, 500, function() { /* do nothing */ });
	}
	if(state=='close'){
		$('#content_container').removeClass('blurred');

		$('#modal_newsletter .modal').stop().animate({'opacity':'0.0', 'top':'-50%'}, 500, function() {
			$('#modal_newsletter').stop().animate({'opacity':'0.0'}, 200, function() {
				$('#modal_newsletter').stop().hide();
				$('#modal_newsletter .modal').css('opacity', '1.0' );

				$('#modal_newsletter').removeClass('overlay');
				$('#modal_newsletter').removeClass('fixed');
			});
		});
	}
}
//
//
//-- modal_video(state) --------------------------------------------------//
function modal_video(state){
	if(state=='open_jewelbotspromo'){
		$('#content_container').addClass('blurred');

		$('#modal_video').stop().show().animate({'opacity':'1.0'}, 500, function() { /* do nothing */ });
		
		//-- 1: load video
		(function(d){
			var modal_video_iframe = d.getElementById('modal_video_iframe');
			modal_video_iframe.src ='https://player.vimeo.com/video/155051675?autoplay=1&loop=0&title=0&byline=0&portrait=0';
		})(document);
		//-- 2: size video
		modal_video('size');
	}
	if(state=='open_billnyepromo'){
		$('#content_container').addClass('blurred');

		$('#modal_video').stop().show().animate({'opacity':'1.0'}, 500, function() { /* do nothing */ });
		
		//-- 1: load video
		(function(d){
			var modal_video_iframe = d.getElementById('modal_video_iframe');
			modal_video_iframe.src ='https://www.youtube.com/embed/XL7JzO4QjXw?rel=0&amp;controls=0&amp;showinfo=0;autoplay=1';
		})(document);
		//-- 2: size video
		modal_video('size');
	}
	if(state=='size'){
		$('#modal_video .wrapper').css('height', $('#modal_video .wrapper').width() / 1.78 );

		if( $(window).width() / $(window).height() < 1.78 ){
			$('#modal_video').css('position', 'fixed' );
			$('#modal_video .wrapper').css('margin-top', ( $(window).height()-$('#modal_video .wrapper').height() ) / 2  );
		} else {
			$('#modal_video').css('position', 'absolute' );
			$('#modal_video .wrapper').css('margin-top', '50px' );
		}
	}
	if(state=='close'){
		$('#content_container').removeClass('blurred');

		$('#modal_video').stop().animate({'opacity':'0.0'}, 200, function() {
			$('#modal_video').stop().hide();
		});
		//-- 1: unload video
		(function(d){
			var modal_video_iframe = d.getElementById('modal_video_iframe');
			modal_video_iframe.src ='foo';
		})(document);
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
//-- index_section_specs(action) -----------------------------------//
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
//-- index_section_sales(action) -----------------------------------//
function index_section_sales(action){
	if(action=='swap_3pack' && $(window).width()<768){
		var content = document.getElementById('pack_3_swap');
		var parent = content.parentNode;
		parent.insertBefore(content, parent.lastChild);
	}
}