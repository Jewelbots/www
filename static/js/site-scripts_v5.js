var F4__modal_was_open = 0;

$(document).ready(function(){
	F1__section_video('size');
	F2__section_software('size');
	F3__section_features('size');
	F5__section_sale('size');
	F6__section_hero('size');
	F7__jewelbot('position');
	F7__jewelbot_place();
	F8__section_meet('size');

	$(window).resize(); //-- and force
});

$(window).scroll(function(){
	F6__add_sticky_header();
	F7__jewelbot_place();
	F9__mxp_interaction_step_scrolled();
	F4_CTA_modal_init();

	$(window).resize(); //-- and force
});

$(window).resize(function(){
	F1__section_video('size');
	F2__section_software('size');
	F3__section_features('size');
	F5__section_sale('size');
	F6__section_hero('size');
	F7__jewelbot('position');
	F7__jewelbot_place();
	F8__section_meet('size');
});

$(window).bind('orientationchange', function(event) {

	$(window).resize(); //-- and force
});


//--------------------------------------------------------------------------------------//
//
//
//-- F1__section_video(action) --------------------------------------//
function F1__section_video(action){
	if(action=='play'){
		$('.section_video #video_bill_nye')[0].src += '&autoplay=1';
		$('.section_video .overlay').animate({ opacity: 0.0 }, 1700, function() {
			$('.section_video .overlay').css({'display': 'none'});
		});
	}
	if(action=='play_vimeo'){
		$('.section_video .overlay').animate({ opacity: 0.0 }, 1700, function() {
			$('.section_video .overlay').css({'display': 'none'});
		});
		var iframe = document.getElementById('video');
		var player = $f(iframe);
		player.api("play");
	}
	if(action=='size'){
		$('.section_video').css('height', $('.section_video').width()/1.90 );
		$('.section_video iframe').css('height', $('.section_video').width()/1.90 );
		if($(window).width()>1023){
			$('.section_video h3').css('margin-top', $('.section_video').height()/2 );
		} else if ($(window).width()>500){
			$('.section_video h3').css('margin-top', $('.section_video').height()/2-100 );
		} else {
			$('.section_video h3').css('margin-top', '50px' );
		}
	}
}
//
//
//-- F2__section_software(action) -----------------------------------//
function F2__section_software(action){
	if(action=='open_desktop'){
		$('.index .section_software .app').animate({ opacity: 0.0 }, 500, function() {
			$('.index .section_software .app').css({'display': 'none'});
			$('.index .section_software .desktop').css({'display': 'block'});
			F2__section_software('size');
			$('.index .section_software .desktop').animate({ opacity: 1.0 }, 1500, function() { /* do nothing */});
		});
	}
	if(action=='open_app'){
		$('.index .section_software .desktop').animate({ opacity: 0.0 }, 500, function() {
			$('.index .section_software .desktop').css({'display': 'none'});
			$('.index .section_software .app').css({'display': 'block'});
			F2__section_software('size');
			$('.index .section_software .app').animate({ opacity: 1.0 }, 1500, function() { /* do nothing */});
		});
	}
	if(action=='size'){
		$('.index .section_software .app').css('height', $(window).height() );
		$('.index .section_software .desktop').css('height', $(window).height() );
		if($(window).width() < 767 ){
			$('.index .section_software .app').css('height', 'auto' );
			$('.index .section_software .desktop').css('height', 'auto' );
		}
	
		if( $(window).height() > 800 ){
			$('.index .section_software .app .column_left').css('padding-top', ($(window).height()-$('.index .section_software .app .column_left').height()-50)/2 );
			$('.index .section_software .app .column_right').css('padding-top', ($(window).height()-$('.index .section_software .app .column_right').height()-50)/2 );
			$('.index .section_software .desktop .column_left').css('padding-top', ($(window).height()-$('.index .section_software .desktop .column_left').height()-50)/2 );
			$('.index .section_software .desktop .column_right').css('padding-top', ($(window).height()-$('.index .section_software .desktop .column_right').height()-50)/2 );
		} else {
			$('.index .section_software .app .column_left').css('padding-top', '0px' );
			$('.index .section_software .app .column_right').css('padding-top', '0px' );
			$('.index .section_software .desktop .column_left').css('padding-top', '0px' );
			$('.index .section_software .desktop .column_right').css('padding-top', '0px' );
		}
	}
}
//
//
//-- F3__section_features(action) -----------------------------------//
var F3__section_features_open = 'no';
function F3__section_features(action){
	if(action=='size'){
		$('.index .section_features').css('height', $(window).height() );
		if($(window).width() < 767 ){
			$('.index .section_features').css('height', 'auto' );
		}

		if( $(window).height() > 700 ){
			$('.index .section_features .column_left').css('margin-top', ($(window).height()-$('.index .section_features .column_left').height()-250)/2 );
			$('.index .section_features .column_right').css('margin-top', ($(window).height()-$('.index .section_features .column_left').height()-250)/2 );
			$('.index .section_features h3').css('padding-top', ($(window).height()-$('.index .section_features .column_right').height()-300)/2 );
			
			//-- this is important as the columns are fixed to the bottom
			//$('.index .section_features_details').css('height', $(window).height() );
		} else {
			$('.index .section_features .column_left').css('margin-top', '0px' );
			$('.index .section_features .column_right').css('margin-top', '0px' );
			$('.index .section_features h3').css('padding-top', '35px' );
		}
	}
	if(action=='open_details'){
		$('.index .section_features_details').stop(true, true).slideToggle( 'slow', function() { /* do nothing */ 
			$('.index .section_features_details').css('height', $(window).height() );
			if($(window).width() < 767 ){
				$('.index .section_features_details').css('height', 'auto' );
			}
		});
		$('.index .section_features .cta').animate({ opacity: 0.0 }, 500, function() {
			$('.index .section_features .cta').css({'display': 'none'});
		});
		F4__scroll_to_ID('#section_features_details', '0');
		F3__section_features_open = 'yes';
	}
}
//
//
//-- F4__scroll_to_ID(id, shift) ------------------------------------//
function F4__scroll_to_ID(id, shift){
	$('html,body').stop().animate({scrollTop: $(id).offset().top -shift}, 700);
}
//
//
//-- F5__section_sale(action) ---------------------------------------//
var F5__section_xmasspecials_open = 'no';
function F5__section_sale(action){
	if(action=='size'){
	//	$('.index .section_sale').css('height', $(window).height() );
		if($(window).width() < 1024 ){
			$('.index .section_sale').css('height', 'auto' );
		}

		if( $(window).height() > 1024 ){
		//	$('.index .section_sale ul.products').css('margin-top', ($(window).height()-$('.index .section_sale ul.products').height()-300)/2 );
		} else {
			$('.index .section_sale ul.products').css('margin-top', '0px' );
		}
	}
	if(action=='open_xmasspecial' && F5__section_xmasspecials_open=='no'){
		$('.index .section_sale_xmasspecial').stop(true, true).slideToggle( 'slow', function() { /* do nothing */ 
		//	$('.index .section_sale_xmasspecial').css('height', $(window).height() );
		//	if($(window).width() < 767 ){
				$('.index .section_sale_xmasspecial').css('height', 'auto' );
		//	}
		});
		$('.index .section_sale .cta_xmasspecial').animate({ opacity: 0.0 }, 500, function() {
			$('.index .section_sale .cta_xmasspecial').css({'display': 'none'});
		});
		F4__scroll_to_ID('#section_sale_xmasspecial', '0');
		F5__section_xmasspecials_open = 'yes';
	}
}
//
//
//-- F6__section_hero(action) ---------------------------------------//
function F6__section_hero(action){
	if(action=='size'){
		$('.index .section_hero').css('height', $(window).height() );

		if( $(window).height() > 800 ){
			$('.index .section_hero h1').css('padding-top', ($(window).height()/2 -250) );
		} else {
			$('.index .section_hero h1').css('padding-top', '110px' );
		}
		if( $(window).width() < 800 ){
			$('.index .section_hero h1').css('padding-top', '95px' );
		}

		if($(window).width() / $(window).height() < 1.78){
			$('.index .section_hero iframe').css('height', $(window).height() +100 );
			$('.index .section_hero iframe').css('width', ($(window).height() +100)*1.78 );
		} else {
			$('.index .section_hero iframe').css('width', $(window).width() + +100 );
			$('.index .section_hero iframe').css('height', ($(window).width() +100)/1.78 );
		}
		/*
		$('.section_video').css('height', $('.section_video').width()/1.90 );
		$('.section_video iframe').css('height', $('.section_video').width()/1.90 );
		if($(window).width()>1023){
			$('.section_video h3').css('margin-top', $('.section_video').height()/2 );
		} else if ($(window).width()>500){
			$('.section_video h3').css('margin-top', $('.section_video').height()/2-100 );
		} else {
			$('.section_video h3').css('margin-top', '50px' );
		}
		*/


		$('.ambassador .section_hero').css('height', $(window).height() );

		if( $(window).height() > 800 ){
			$('.ambassador .section_hero h1').css('padding-top', ($(window).height()/2 -150) );
		} else {
			$('.ambassador .section_hero h1').css('padding-top', '250px' );
		}
		if( $(window).width() < 800 ){
			$('.ambassador .section_hero h1').css('padding-top', '95px' );
		}
	}
}
//
//
//-- F6__add_sticky_header ------------------------------------------//
function F6__add_sticky_header(){
	if($(window).scrollTop() > 10 && $(window).width()>767){
		$('.section_header').addClass('header_sticky');
	} else {
		$('.section_header').removeClass('header_sticky');
	}
}
//
//-- toggle mobile
function F3_toggle_mobile_nav(){
	$('.section_header ul.navigation').stop(true, true).slideToggle( 'slow', function() { /* do nothing */ });
}
//
//-- hide nav
function F5_hide_navigation_mobile(){
	if($(window).width()>767){
		$('.header ul.navigation').css({'display':'none'});
	}
}
//
//
//-- F7__jewelbot(action)--------------------------------------------//
var F7__position_1 = 'active';
var F7__position_2 = 'inactive';
var F7__position_3 = 'inactive';
var F7__position_4 = 'inactive';
var F7__position_5 = 'inactive';
var F7__position_6 = 'inactive';
var F7__position_7 = 'inactive';
var F7__section_height = '700';
function F7__jewelbot_place(){

	//-- how tall are the sections?
	if($(window).height() < 700 ){
		F7__section_height = 700;
	} else {
		F7__section_height = $(window).height();
	}

	//-- get position
	if( $(window).scrollTop() < F7__section_height-100 ){
		F7__position_1 = 'inactive';
		F7__position_2 = 'active';
		F7__position_3 = 'inactive';
		F7__position_4 = 'inactive';
		F7__position_5 = 'inactive';
		F7__position_6 = 'inactive';
		F7__position_7 = 'inactive';
	}
	else if( $(window).scrollTop() > F7__section_height-100 && $(window).scrollTop() < F7__section_height*2-100 ){
		F7__position_1 = 'inactive';
		F7__position_2 = 'active';
		F7__position_3 = 'inactive';
		F7__position_4 = 'inactive';
		F7__position_5 = 'inactive';
		F7__position_6 = 'inactive';
		F7__position_7 = 'inactive';
	}
	else if( $(window).scrollTop() > F7__section_height*2-100 && $(window).scrollTop() < F7__section_height*3-100 ){
		F7__position_1 = 'inactive';
		F7__position_2 = 'inactive';
		F7__position_3 = 'active';
		F7__position_4 = 'inactive';
		F7__position_5 = 'inactive';
		F7__position_6 = 'inactive';
		F7__position_7 = 'inactive';
	}
	else if( $(window).scrollTop() > F7__section_height*3-100 && $(window).scrollTop() < F7__section_height*4-100 ){
		F7__position_1 = 'inactive';
		F7__position_2 = 'inactive';
		F7__position_3 = 'inactive';
		F7__position_4 = 'active';
		F7__position_5 = 'inactive';
		F7__position_6 = 'inactive';
		F7__position_7 = 'inactive';
	}
	else if( $(window).scrollTop() > F7__section_height*4-100 && $(window).scrollTop() < F7__section_height*5-100 && F3__section_features_open == 'yes'){
		F7__position_1 = 'inactive';
		F7__position_2 = 'inactive';
		F7__position_3 = 'inactive';
		F7__position_4 = 'inactive';
		F7__position_5 = 'active';
		F7__position_6 = 'inactive';
		F7__position_7 = 'inactive';
	}
	else if( $(window).scrollTop() > F7__section_height*5-100 && $(window).scrollTop() < F7__section_height*6-100 && F3__section_features_open == 'yes'){
		F7__position_1 = 'inactive';
		F7__position_2 = 'inactive';
		F7__position_3 = 'inactive';
		F7__position_4 = 'inactive';
		F7__position_5 = 'inactive';
		F7__position_6 = 'active';
		F7__position_7 = 'inactive';
	}
	else if( $(window).scrollTop() > F7__section_height*6-100 && $(window).scrollTop() < F7__section_height*7-100 && F3__section_features_open == 'yes'){
		F7__position_1 = 'inactive';
		F7__position_2 = 'inactive';
		F7__position_3 = 'inactive';
		F7__position_4 = 'inactive';
		F7__position_5 = 'inactive';
		F7__position_6 = 'inactive';
		F7__position_7 = 'active';
	}
	F7__jewelbot('position');
}
function F7__jewelbot(action){

	//-- place vertically
	if(action=='position'){
		//
		//-- only place on desktop and tablets
		if($(window).width()>767){
			if(F7__position_1 == 'active'){
				if( F7__section_height > 700 ){
					$('#jewelbot').css('top', (F7__section_height/2)+150 );
				} else {
					$('#jewelbot').css('top', '520px' );
				}
				$('#jewelbot').removeClass('rotated');
				$('#jewelbot').removeClass('hidden');
				F7__jewelbot_style('charm_3','led','board','shadow','band_4','blink_0');
			}
			if(F7__position_2 == 'active'){
				$('#jewelbot').css('top', (F7__section_height*2) - (F7__section_height/2) + 210 );
				$('#jewelbot').addClass('rotated');
				$('#jewelbot').removeClass('hidden');
				F7__jewelbot_style('charm_1','led','board','shadow','band_2','blink_0');
			}
			if(F7__position_3 == 'active'){
				$('#jewelbot').css('top', (F7__section_height*3) - (F7__section_height/2) + 190 );
				$('#jewelbot').addClass('rotated');
				$('#jewelbot').removeClass('hidden');
				//$('#jewelbot').addClass('hidden');
				F7__jewelbot_style('charm_4','led','board','shadow','band_4','blink_0');
			}
			if(F7__position_4 == 'active'){
				$('#jewelbot').css('top', (F7__section_height*4) - (F7__section_height/2) + 210 );
				$('#jewelbot').addClass('rotated');
				$('#jewelbot').removeClass('hidden');
				F7__jewelbot_style('charm_6','led','board','shadow','band_4','blink_0');
			}
			if(F7__position_5 == 'active'){
				$('#jewelbot').css('top', (F7__section_height*5) - (F7__section_height/2) + 210 );
				$('#jewelbot').addClass('rotated');
				$('#jewelbot').removeClass('hidden');
				F7__jewelbot_style('charm_1','led','board','shadow','band_1','blink_0');
			
			}
			if(F7__position_6 == 'active'){
			/*	$('#jewelbot').css('top', (F7__section_height*6) - (F7__section_height/2) + 210 );
				$('#jewelbot').addClass('rotated');
				$('#jewelbot').removeClass('hidden');
				F7__jewelbot_style('charm_5','led','board','shadow','band_3','blink_0');
			*/
			}
			if(F7__position_7 == 'active'){
			/*	$('#jewelbot').css('top', (F7__section_height*7) - (F7__section_height/2) + 210 );
				$('#jewelbot').addClass('rotated');
				F7__jewelbot_style('charm_2','led','board','shadow','band_5','blink_0');
			*/
			}
		}
	}
}
function F7__jewelbot_style(charm, led, board, shadow, band, blink){

	//-- remove all
	$( '#jewelbot img.active' ).each(function( index ) {
		$(this).removeClass('active');
	});
	//-- add what's needed
	if( charm != '0'){
		$( '#jewelbot #'+charm ).addClass('active');
	}
	if( led != '0'){
		$( '#jewelbot #'+led ).addClass('active');
	}
	if( board != '0'){
		$( '#jewelbot #'+board ).addClass('active');
	}
	if( shadow != '0'){
		$( '#jewelbot #'+shadow ).addClass('active');
	}
	if( band != '0'){
		$( '#jewelbot #'+band ).addClass('active');
	}
	if( blink != '0'){
		$( '#jewelbot #'+blink ).addClass('active');
	}
}
function F7__Jewelbot_feature(feature){
	
	$( '.feature' ).each(function( index ) {
		$(this).removeClass('active');
	});
	$( 'p' ).each(function( index ) {
		$(this).removeClass('active');
	});
	$( '.pointer' ).each(function( index ) {
		$(this).removeClass('active');
	});
	
	if( feature == 'feature_1' ){
		$('#jewelbot #band_4').removeClass('active');
		$('#jewelbot #led').removeClass('active');
		$('#jewelbot #charm_1').removeClass('active');
		$('#jewelbot #charm_3').removeClass('active');

		$('.feature_1 .pointer').addClass('active');
		$('.feature_1 p').addClass('active');
		$('.feature_1').addClass('active');
	}
	if( feature == 'feature_2' ){
		$('#jewelbot #band_4').removeClass('active');
		$('#jewelbot #charm_1').removeClass('active');
		$('#jewelbot #charm_3').removeClass('active');

		$('#jewelbot #led').addClass('active');

		$('.feature_2 .pointer').addClass('active');
		$('.feature_2 p').addClass('active');
		$('.feature_2').addClass('active');
	}
	if( feature == 'feature_3' ){
		$('#jewelbot #band_4').removeClass('active');
		$('#jewelbot #charm_3').addClass('active');
		
		$('.feature_3 .pointer').addClass('active');
		$('.feature_3 p').addClass('active');
		$('.feature_3').addClass('active');
	}
	if( feature == 'feature_4' ){
		$('#jewelbot #band_4').addClass('active');

		$('.feature_4 .pointer').addClass('active');
		$('.feature_4 p').addClass('active');
		$('.feature_4').addClass('active');
	}
}
//
//
//-- F8__section_meet(action) ---------------------------------------//
function F8__section_meet(action){
	if(action=='size'){
		$('.index .section_meet').css('height', $(window).height() );
		if($(window).width() < 767 ){
			$('.index .section_meet').css('height', 'auto' );
		}

		if( $(window).height() > 700 ){
			$('.index .section_meet').css('padding-top', (F7__section_height/2 -300) );
		} else {
			$('.index .section_meet').css('padding-top', '60px' );
		}
	}
	if(action=='size'){
		$('.ambassador .section_ambassador').css('height', $(window).height() );
		if($(window).width() < 767 ){
			$('.ambassador .section_ambassador').css('height', 'auto' );
		}

		if( $(window).height() > 700 ){
			$('.ambassador .section_ambassador').css('padding-top', (F7__section_height/2 -300) );
		} else {
			$('.ambassador .section_ambassador').css('padding-top', '60px' );
		}
	}
}
//
//
//-- F9__mxp_interaction_step_scrolled() ---------------------------------------//
var F9__section_1  = 'untracked';
var F9__section_2  = 'untracked';
var F9__section_3  = 'untracked';
var F9__section_4  = 'untracked';
var F9__section_5  = 'untracked';
var F9__section_6  = 'untracked';
var F9__section_7  = 'untracked';
var F9__section_8  = 'untracked';
var F9__section_9  = 'untracked';
var F9__section_10 = 'untracked';
function F9__mxp_interaction_step_scrolled(){
	//-- get position
	if( $(window).scrollTop() < $(window).height() * 1 && F9__section_1 == 'untracked'){
		F9__section_1 = 'tracked';
		mixpanel.track("INTERACTION", {"STEP": "scrolled_sec_1"});
	}
	if( $(window).scrollTop() > $(window).height() * 1 && $(window).scrollTop() < $(window).height() * 2 && F9__section_2 == 'untracked'){
		F9__section_2 = 'tracked';
		mixpanel.track("INTERACTION", {"STEP": "scrolled_sec_2"});
	}
	if( $(window).scrollTop() > $(window).height() * 2 && $(window).scrollTop() < $(window).height() * 3 && F9__section_3 == 'untracked'){
		F9__section_3 = 'tracked';
		mixpanel.track("INTERACTION", {"STEP": "scrolled_sec_3"});
	}
	if( $(window).scrollTop() > $(window).height() * 3 && $(window).scrollTop() < $(window).height() * 4 && F9__section_4 == 'untracked'){
		F9__section_4 = 'tracked';
		mixpanel.track("INTERACTION", {"STEP": "scrolled_sec_4"});
	}
	if( $(window).scrollTop() > $(window).height() * 4 && $(window).scrollTop() < $(window).height() * 5 && F9__section_5 == 'untracked'){
		F9__section_5 = 'tracked';
		mixpanel.track("INTERACTION", {"STEP": "scrolled_sec_5"});
	}
	if( $(window).scrollTop() > $(window).height() * 5 && $(window).scrollTop() < $(window).height() * 6 && F9__section_6 == 'untracked'){
		F9__section_6 = 'tracked';
		mixpanel.track("INTERACTION", {"STEP": "scrolled_sec_6"});
	}
	if( $(window).scrollTop() > $(window).height() * 6 && $(window).scrollTop() < $(window).height() * 7 && F9__section_7 == 'untracked'){
		F9__section_7 = 'tracked';
		mixpanel.track("INTERACTION", {"STEP": "scrolled_sec_6"});
	}
	if( $(window).scrollTop() > $(window).height() * 7 && $(window).scrollTop() < $(window).height() * 8 && F9__section_8 == 'untracked'){
		F9__section_8 = 'tracked';
		mixpanel.track("INTERACTION", {"STEP": "scrolled_sec_6"});
	}
	if( $(window).scrollTop() > $(window).height() * 8 && $(window).scrollTop() < $(window).height() * 9 && F9__section_9 == 'untracked'){
		F9__section_9 = 'tracked';
		mixpanel.track("INTERACTION", {"STEP": "scrolled_sec_6"});
	}
	if( $(window).scrollTop() > $(window).height() * 9 && $(window).scrollTop() < $(window).height() * 10 && F9__section_10 == 'untracked'){
		F9__section_10 = 'tracked';
		mixpanel.track("INTERACTION", {"STEP": "scrolled_sec_6"});
	}
}
//
//
//-- F10__F4_CTA_modal() -------------------------------------------------------//

function F4_CTA_modal_init(){
	if($(window).scrollTop()+$(window).height()>$(document).height()-1){
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
	if(state=='open' && F4__modal_was_open != 1){
		F4__modal_was_open = 1;
		$('#modal_cta').stop().show().animate({'opacity':'1.0'}, 500, function() { /* do nothing */ });
		$('#modal_cta form').stop().show().animate({'top':'40%'}, 200, function() { /* do nothing */ });
	}
}
$('#modal_cta form a.close').click(function(){ F4_CTA_modal('close'); });
$('#modal_cta .background').click(function(){ F4_CTA_modal('close'); });
$('#modal_cta .background').click(function(){ F4_CTA_modal('close'); });
//
//
//
//
//
//
//
//
//
//