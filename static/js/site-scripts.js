$(document).ready(function(){
	$(window).resize(); //-- and force
});

$(window).scroll(function(){
	F4_add_sticky_header();
	F4_CTA_modal_init();
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
//
//
//-- fade in CTA modal
var F4_modal_was_open = 0;
function F4_CTA_modal_init(){
	if($(window).scrollTop() + $(window).height() > $(document).height()-1){
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
		mixpanel.track("Newsletter - modal closed", {});
	}
	if(state=='open' && F4_modal_was_open != 1){
		//F4_modal_was_open = 1;
		$('#modal_cta').stop().show();
		$('#modal_cta').stop().show().animate({'opacity':'1.0'}, 500, function() { /* do nothing */ });
		$('#modal_cta form').css({'display': 'block'});
		$('#modal_cta form').css({'opacity': '1'});
		$('#modal_cta form').stop().show().animate({'top':'40%'}, 200, function() { /* do nothing */ });
		mixpanel.track("Newsletter - modal opened", {});
	}
}
$('#modal_cta form a.close').click(function(){ F4_CTA_modal('close'); });
$('#modal_cta .background').click(function(){ F4_CTA_modal('close'); });
$('#modal_cta .background').click(function(){ F4_CTA_modal('close'); });
//
//
//-- F9__module_socialfeed_tweets ----------------------------------//
var F9__current_image = 0;
window.socialtimerFired = function() {
	//--loop through the images
	if(F9__current_image < 9){
		$('#tweet_'+F9__current_image).animate({ opacity: 0.0 }, 500, function() {
			$('#tweet_'+F9__current_image).css({'display': 'none'});
			F9__current_image = F9__current_image + 1;
			$('#tweet_'+F9__current_image).animate({ opacity: 1.0 }, 200, function() {});
		});
	} else {
		F9__current_image = 0;
		$('#tweet_0').css({'display': 'block'});
		$('#tweet_1').css({'display': 'block'});
		$('#tweet_2').css({'display': 'block'});
		$('#tweet_3').css({'display': 'block'});
		$('#tweet_4').css({'display': 'block'});
		$('#tweet_5').css({'display': 'block'});
		$('#tweet_6').css({'display': 'block'});
		$('#tweet_7').css({'display': 'block'});
		$('#tweet_8').css({'display': 'block'});
		$('#tweet_9').css({'display': 'block'});
		$('#tweet_0').animate({ opacity: 1.0 }, 200, function() {});
		$('#tweet_1').animate({ opacity: 0.0 }, 200, function() {});
		$('#tweet_2').animate({ opacity: 0.0 }, 200, function() {});
		$('#tweet_3').animate({ opacity: 0.0 }, 200, function() {});
		$('#tweet_4').animate({ opacity: 0.0 }, 200, function() {});
		$('#tweet_5').animate({ opacity: 0.0 }, 200, function() {});
		$('#tweet_6').animate({ opacity: 0.0 }, 200, function() {});
		$('#tweet_7').animate({ opacity: 0.0 }, 200, function() {});
		$('#tweet_8').animate({ opacity: 0.0 }, 200, function() {});
		$('#tweet_9').animate({ opacity: 0.0 }, 200, function() {});
	}
	window.module_socialfeed_socialtimerFired = setTimeout(socialtimerFired, 5000);
};
window.reset_module_hero_slideshow = function() {
	clearTimeout(window.module_socialfeed_socialtimerFired);
	window.module_socialfeed_socialtimerFired = setTimeout(socialtimerFired, 5000);
};
window.module_socialfeed_socialtimerFired = setTimeout(socialtimerFired, 5000);

//
//
//-- add and remove product from cart and then checkout incl. mixpanel
F10__price_1pack = 69;
F10__price_2pack = 99;
F10__price_3pack = 139;

F10__savings_1pack = 0;
F10__savings_2pack = 39;
F10__savings_3pack = 68;

F10__quantity_1pack = 0;
F10__quantity_2pack = 0;
F10__quantity_3pack = 0;

F10__total   = 0;
F10__savings = 0;
F10__max_add = 5;

/*
1pack="4818647172"
2pack="4818676612"
3pack="4818685316"
*/

function F10__add_product_presale(addremove, product){

	//--1 update quantities
	if(addremove == 'plus'){
		if( product == '1pack' && F10__quantity_1pack < F10__max_add ){
			F10__quantity_1pack = F10__quantity_1pack+1; $('#jewelbot_1 .interface p').text(F10__quantity_1pack);
		};
		if( product == '2pack' && F10__quantity_2pack < F10__max_add ){
			F10__quantity_2pack = F10__quantity_2pack+1; $('#jewelbot_2 .interface p').text(F10__quantity_2pack);
		};
		if( product == '3pack' && F10__quantity_3pack < F10__max_add ){
			F10__quantity_3pack = F10__quantity_3pack+1; $('#jewelbot_3 .interface p').text(F10__quantity_3pack);
		};
	} else {
		if( product == '1pack' && F10__quantity_1pack > 0 ){ F10__quantity_1pack = F10__quantity_1pack-1; $('#jewelbot_1 .interface p').text(F10__quantity_1pack); };
		if( product == '2pack' && F10__quantity_2pack > 0 ){ F10__quantity_2pack = F10__quantity_2pack-1; $('#jewelbot_2 .interface p').text(F10__quantity_2pack); };
		if( product == '3pack' && F10__quantity_3pack > 0 ){ F10__quantity_3pack = F10__quantity_3pack-1; $('#jewelbot_3 .interface p').text(F10__quantity_3pack); };
	}

	//--2 update total
	F10__total = (F10__price_1pack*F10__quantity_1pack)+(F10__price_2pack*F10__quantity_2pack)+(F10__price_3pack*F10__quantity_3pack);
	$('.checkout .total span').text(F10__total);
	F10__savings = (F10__quantity_1pack*F10__savings_1pack)+(F10__quantity_2pack*F10__savings_2pack)+(F10__quantity_3pack*F10__savings_3pack);
	$('.checkout .savings span').text(F10__savings);

	//--3 update form
	$('#add_to_cart #product_input').remove();
	for (var i = 0; i < F10__quantity_1pack; i++) { $('<input type="hidden" name="id[]" value="4818647172" id="product_input">').prependTo('#add_to_cart'); }
	for (var i = 0; i < F10__quantity_2pack; i++) { $('<input type="hidden" name="id[]" value="4818676612" id="product_input">').prependTo('#add_to_cart'); }
	for (var i = 0; i < F10__quantity_3pack; i++) { $('<input type="hidden" name="id[]" value="4818685316" id="product_input">').prependTo('#add_to_cart'); }
}
//--validation for cart
jQuery("#add_to_cart").click(function() {
	if(F10__quantity_1pack+F10__quantity_2pack+F10__quantity_3pack==0){
		alert('Please add a Jewelbot to your cart!');
		mixpanel.track("Pre-Sale - error");
		return false;
	} else {
		for (var i = 0; i < F10__quantity_1pack; i++) { mixpanel.track("Pre-Sale - added to cart", {"Product": "1-pack added"}); }
		for (var i = 0; i < F10__quantity_2pack; i++) { mixpanel.track("Pre-Sale - added to cart", {"Product": "2-pack added"}); }
		for (var i = 0; i < F10__quantity_3pack; i++) { mixpanel.track("Pre-Sale - added to cart", {"Product": "3-pack added"}); }
		mixpanel.track("Pre-Sale - submitted");
		return true;
	}
});