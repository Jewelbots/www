$('#site_container').stop().delay(1000).show().animate({'opacity': '1.0'}, 1000, function() {
});

window.onload=body_load; function body_load(){
	F2_size_opening();
	$('#ex1').zoom({ on:'grab' });
	$('#ex2').zoom({ on:'grab' });
	$('#ex3').zoom({ on:'grab' });	 
	$('#ex4').zoom({ on:'grab' });
	var timer;
	timer = window.setTimeout( function(){ F2_slideshow_play('next'); }, F2_delay);
	F4_overlay_size_zoom();
	F6_size_slides();
}

$(window).resize(function(){
	F2_size_opening();
	F6_size_slides();
	F4_overlay_size_zoom();
}); //--setup
$(window).scroll(function(){
	home_F3_activatenavigation();
});
$(window).bind('orientationchange', function(event) {
	F2_size_opening();f
	F6_size_slides();
});


//------------------ site overall ----------------------------------------------------//
//
//
// F1 //-- handle the sticky navigation and fade it in/out -//
$(function() {
	if($(window).width()>1024){
		F1_offset = 0;
		//--01: scroll up/down fade
		$(window).scroll(function(){
			var scrollTop = $(window).scrollTop();
			if(scrollTop > F1_offset)
				$('#header_container').stop().show().animate({'opacity':'1.0'}, 400);
			else
				$('#header_container').stop().animate({'opacity':'0.0'}, 200, function() {
					$('#header_container').stop().hide()
				});
		});
	} else {
		$('#header_container').css({'display': 'block'});
		//do nothing for mobile
	}
});
var active_slate = "#home";
function home_F3_activatenavigation(){
	//-- fades
	var width = $(window).width();
	var height = $(window).height()-10;
	var scrollTop = $(window).scrollTop();
	if(scrollTop > height  && width > 767){
		$('.header').stop().show().animate({'opacity':'0.95'}, 400);
		$('.footer').stop().show().animate({'opacity':'0.95'}, 400);
	} else {
		$('.header').stop().animate({'opacity':'0.0'}, 200, function() {
			$('.header').stop().hide()
		});
		$('.footer').stop().animate({'opacity':'0.0'}, 200, function() {
			$('.footer').stop().hide()
		});
		 active_slate = "#home";
	}
	//-- buttons
	$(".navigation #nav_1").removeClass("active");
	$(".navigation #nav_2").removeClass("active");
	$(".navigation #nav_3").removeClass("active");
	$(".navigation #nav_4").removeClass("active");
	$(".navigation #nav_5").removeClass("active");
	$(".navigation #nav_6").removeClass("active");
	
	if(scrollTop > $('#collections').offset().top - 60				&& scrollTop < $('#about').offset().top - 60 )					{ $(".navigation #nav_1").addClass("active"); active_slate = "#collections"; }
	if(scrollTop > $('#about').offset().top - 60					&& scrollTop < $('#teaching').offset().top - 60 )				{ $(".navigation #nav_2").addClass("active"); active_slate = "#about"; }
	if(scrollTop > $('#teaching').offset().top - 60					&& scrollTop < $('#questions_and_answers').offset().top - 60 )	{ $(".navigation #nav_3").addClass("active"); active_slate = "#teaching"; }
	if(scrollTop > $('#questions_and_answers').offset().top - 60 	&& scrollTop < $('#media').offset().top - 60 )					{ $(".navigation #nav_4").addClass("active"); active_slate = "#questions_and_answers"; }
	if(scrollTop > $('#media').offset().top - 60 					&& scrollTop < $('#get_in_touch').offset().top - 60 )			{ $(".navigation #nav_5").addClass("active"); active_slate = "#media"; }
	if(scrollTop > $('#get_in_touch').offset().top - 60 )																			{ $(".navigation #nav_6").addClass("active"); active_slate = "#get_in_touch"; }

}
function F1_add_active_class(navbutton){
	$(".navigation #nav_"+navbutton).delay(1000).addClass("active");
}
$(".mobile_nav").click(function() {
	$(".navigation").stop(true, true).slideToggle( "slow", function() {/* do nothing */});
});
//
//
// F2 //-- F2_size_opening ---------------------------------//
function F2_size_opening(){

	//-- 1 (fullscreen opening)
	//$('#opening').css("height", $(window).height());
	$('#opening').css("min-height", $(window).height());
	$('#opening .slideshow').css("height", $(window).height());
	$('#opening .slideshow .interface').css("height", $(window).height());

	//-- 2 (calculate orientation for image resize)
	var F2_orientation = $(window).width() / $(window).height();

	//-- 3 (size all images, margin-offset)
	if(F2_orientation > 1.333){
		$('#opening .slideshow img.slide').css("width", '100%');
		$('#opening .slideshow img.slide').css("height", 'auto');
		
		$('#opening .slideshow img.slide').css("margin", "0 0 0 0");
		$('#opening .slideshow img.slide').css("margin-top", ( ($(window).height() - $(window).width()/1.333))/2 );
	} else {
		$('#opening .slideshow img.slide').css("width", 'auto');
		$('#opening .slideshow img.slide').css("height", '100%');
		
		$('#opening .slideshow img.slide').css("margin", "0 0 0 0");
		$('#opening .slideshow img.slide').css("margin-left", ( ($(window).width() - $(window).height()*1.333))/2 );
	}

	//-- 4 (place logo)
	$('#opening .slideshow .interface .logo').css("margin", $(window).height()/2-400+"px auto 0 auto");
}
//
//
// F2 //-- F2_slideshow_opening ----------------------------//
var F2_current_image	= 1;
var F2_max				= 5;
var F2_delay			= 10;
var F2_transition		= 3000;
function F2_slideshow_play(direction){
	if(direction="next" && F2_current_image < F2_max){
		$('#opening_img_'+F2_current_image).stop().animate({'opacity':'0.0'}, F2_transition, function() {
			F2_current_image = F2_current_image + 1;
			timer = window.setTimeout( function(){ F2_slideshow_play('next'); }, F2_delay);
		});
		
		
	} else {
		F2_slideshow_rewind();
	}
}
function F2_slideshow_rewind(direction){
	
	$('#opening_img_1').stop().animate({'opacity':'1.0'}, F2_transition, function() {
		$( "#opening .slideshow img" ).each(function( index ) {
			$(this).css('opacity', "1.0");
		});
		F2_current_image = 1;
		timer = window.setTimeout( function(){ F2_slideshow_play('next'); }, F2_delay);
	});
}
//
//
// F3 //-- F3_scroll_to_ID ---------------------------------//
function F3_scroll_to_ID(id, shift){
	$('html,body').stop().animate({scrollTop: $(id).offset().top -shift}, 700);
	if($(window).width() < 768){
		$(".navigation").stop(true, true).slideUp( "slow", function() {/* do nothing */});
	}
}
//
//
// F4 //-- F4_load_content_overlay ---------------------------------//
var F4_body_vertical_pos = 0;
function F4_load_content_overlay(type, number){ // "collection/media/video", "collection_/x"

	$( "#overlay_background" ).click(function() {
		F4_close_overlay();
	});
	//-- 1 (store body position)
	F4_body_vertical_pos = $(window).scrollTop();

	//-- 2 (fade in #overlay_background)
	$('#overlay_background').css({'opacity': '0.0'});
	$('#overlay_background').stop().show().animate({'opacity': '1.0'}, 500, function() {
		
		//-- 3 (scroll to all to top, prevent body scroll)
		$('html,body').scrollTop(1); //--> 1 so sticky nav stays
		$('body').css({'overflow': 'hidden'});
		$('#overlay').css({'opacity': '0.01'});

		//-- 4 (load content)
		F4_overlay_size_zoom();
		$("#overlay .collection").each(function(){
			$(this).css({'display': 'none'});
		});
		$('#overlay .press').css({'display': 'none'});
		$('#overlay .video').css({'display': 'none'});
		if(type=="collection"){
			$('#collection_'+number).css({'display': 'block'});
			$(".zoom").each(function(){ $(this).zoom(); });
			$('#overlay').stop().show().animate({'opacity': '0.01'}, 100, function() {
				F4_overlay_size_zoom();
				$('#overlay').stop().show().animate({'opacity': '1.0'}, 1500, function() {
					F1_add_active_class(1);
					
				});
			});
		};
		if(type=="press"){
			$('#overlay .press').css({'display': 'block'});
			$('#overlay').stop().show().animate({'opacity': '1.0'}, 1500, function() {
				F1_add_active_class(5);
			});
		};
		if(type=="video"){
			$('#overlay .video').css({'display': 'block'});
			$('#overlay').stop().show().animate({'opacity': '1.0'}, 1500, function() {
				F1_add_active_class(5);
			});
		};

	});
}
function F4_close_overlay(){

	//-- 1 (fade out #overlay)
	$('#overlay').stop().show().animate({'opacity': '0.01'}, 1000, function() {
		//-- before removing overlay, restore body position, scroll
		$('body').css({'overflow': 'auto'});
		$('html,body').scrollTop(F4_body_vertical_pos);
		$('#overlay').scrollTop(0);
		$('#overlay').css({'display': 'none'});

		//-- 2 (fade out #overlay_background)
		$('#overlay_background').stop().show().animate({'opacity': '0.0'}, 500, function() {
			$('#overlay_background').css({'display': 'none'});
		});
	});

}
function F4_close_overlay_noscroll(){

	//-- 1 (fade out #overlay)
	$('#overlay_background').stop().show().animate({'opacity': '0.0'}, 500, function() {
		$('#overlay_background').css({'display': 'none'});
	});
}

function F4_overlay_size_zoom(){
	F4_zoom_height = $('#overlay .collection').width()*0.22*1.55;
	$('#overlay .collection .zoom').css({'height': F4_zoom_height });
}
//
//
// F5 //-- switch content containers && slideshows / open clode folders ---------------------------------//
$('.more').click(function() { /* for all site's more buttons */
	
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
$('#questions_and_answers .question').click(function() {
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
$('#about li.topic').click(function() {

	//-- 1 (if open)
	if( $(this).hasClass( 'topic_active' ) ){
		/* do nothing*/
	} else {

		//-- 2 (get number of DOM element, updated class names)
		var li_item_number = $('#about li.topic').index(this);
		li_item_number = li_item_number+1;
		$('#about li.topic').each(function(){
			$(this).removeClass('topic_active');
		});
		$(this).addClass('topic_active');

		//-- 3 (close all open topic_containers)
		$('#about div.topic').each(function(){			
			$(this).stop(true, true).slideUp(300, function() {
				/* do nothing */
			});
		});
		$('#about .slideshow').each(function(){			
			$(this).stop(true, true).delay(200).slideUp(500, function() {
				/* do nothing */
			});
		});

		//-- 4 (open the one topic_containers)
		$('#about #topic_'+li_item_number).stop(true, true).slideDown(300, function() {
			/* do nothing*/
		});
		$('#about #slideshow_'+li_item_number).stop(true, true).delay(200).slideDown(500, function() {
			/* do nothing */
		});
	}
});
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
//
//
// F6 //-- content slideshows prev/next image ---------------------------------//
function F6_size_slides(){
	
	$('#content_container #slideshow_container').css("height", ( $('#content_container').width() /1.5 ));
	/*
	//-- 1 (get slideshow dimensions)
	var F6_slideshow_width = $('#content_container .slideshow').width();
	var F6_slideshow_height = $('#content_container .slideshow').height();
	
	//-- 2 (calculate orientation for image resize)
	var F6_orientation = $('#content_container .slideshow').width() / $('#content_container .slideshow').height();
	
	//-- 3 (size all images, margin-offset)
	if(F6_orientation > 1.5){
		$('#content_container .slideshow img.slide').css("width", '100%');
		$('#content_container .slideshow img.slide').css("height", 'auto');
		
		$('#content_container .slideshow img.slide').css("margin", "0 0 0 0");
		$('#content_container .slideshow img.slide').css("margin-top", ( (F6_slideshow_height - F6_slideshow_width/1.5))/2 );
	} else {
		$('#content_container .slideshow img.slide').css("width", 'auto');
		$('#content_container .slideshow img.slide').css("height", '100%');
		
		$('#content_container .slideshow img.slide').css("margin", "0 0 0 0");
		$('#content_container .slideshow img.slide').css("margin-left", ( (F6_slideshow_width - F6_slideshow_height*1.5))/2 );
	}*/
}

var F6_transition		= 500;

var F6_about_slideshow_1_current = 1;
var F6_about_slideshow_2_current = 1;
var F6_about_slideshow_3_current = 1;
var F6_about_slideshow_4_current = 1;

function F6_about_slideshow(slideshow, direction){
	if(slideshow=='slideshow_1'){
		/* next */
		//-- 1 (next / advance)
		if(direction=='next' && F6_about_slideshow_1_current < F6_about_slideshow_1_max){
			// fade current out
			$('#about #slideshow_1 #slide_'+F6_about_slideshow_1_current).stop().animate({'opacity':'0.0'}, F6_transition, function() {
				F6_about_slideshow_1_current = F6_about_slideshow_1_current +1;
				$('#about #slideshow_1 .prev').css({'opacity': '1.0'});
			});
			return;
		}
		//-- 2 (next / rewind)
		if(direction=='next' && F6_about_slideshow_1_current == F6_about_slideshow_1_max){
			// fade #1 in and then set all other too 100% opacity
			$('#about #slideshow_1 #slide_1').stop().animate({'opacity':'1.0'}, F6_transition, function() {
				$('#about #slideshow_1 .slide').each(function(){
					$(this).css({'opacity': '1.0'});
				});
				F6_about_slideshow_1_current = 1;
				$('#about #slideshow_1 .prev').css({'opacity': '0.3'});
			});
			return;
		}

		/* prev */
		//-- 1 (prev / advance)
		if(direction=='prev' && F6_about_slideshow_1_current > 1){
			// fade current prev in 
			F6_about_slideshow_1_current = F6_about_slideshow_1_current -1;
			$('#about #slideshow_1 #slide_'+F6_about_slideshow_1_current).stop().animate({'opacity':'1.0'}, F6_transition, function() {
				/* do nothing */
			});
			if(direction=='prev' && F6_about_slideshow_1_current == 1){
				$('#about #slideshow_1 .prev').css({'opacity': '0.3'});
				return;
			}
			return;
		}
	}
	if(slideshow=='slideshow_2'){
		/* next */
		//-- 1 (next / advance)
		if(direction=='next' && F6_about_slideshow_2_current < F6_about_slideshow_2_max){
			// fade current out
			$('#about #slideshow_2 #slide_'+F6_about_slideshow_2_current).stop().animate({'opacity':'0.0'}, F6_transition, function() {
				F6_about_slideshow_2_current = F6_about_slideshow_2_current +1;
				$('#about #slideshow_2 .prev').css({'opacity': '1.0'});
			});
			return;
		}
		//-- 2 (next / rewind)
		if(direction=='next' && F6_about_slideshow_2_current == F6_about_slideshow_2_max){
			// fade #1 in and then set all other too 100% opacity
			$('#about #slideshow_2 #slide_1').stop().animate({'opacity':'1.0'}, F6_transition, function() {
				$('#about #slideshow_2 .slide').each(function(){
					$(this).css({'opacity': '1.0'});
				});
				F6_about_slideshow_2_current = 1;
				$('#about #slideshow_2 .prev').css({'opacity': '0.3'});
			});
			return;
		}

		/* prev */
		//-- 1 (prev / advance)
		if(direction=='prev' && F6_about_slideshow_2_current > 1){
			// fade current prev in 
			F6_about_slideshow_2_current = F6_about_slideshow_2_current -1;
			$('#about #slideshow_2 #slide_'+F6_about_slideshow_2_current).stop().animate({'opacity':'1.0'}, F6_transition, function() {
				/* do nothing */
			});
			if(direction=='prev' && F6_about_slideshow_2_current == 1){
				$('#about #slideshow_2 .prev').css({'opacity': '0.3'});
				return;
			}
			return;
		}
	}
	if(slideshow=='slideshow_3'){
		/* next */
		//-- 1 (next / advance)
		if(direction=='next' && F6_about_slideshow_3_current < F6_about_slideshow_3_max){
			// fade current out
			$('#about #slideshow_3 #slide_'+F6_about_slideshow_3_current).stop().animate({'opacity':'0.0'}, F6_transition, function() {
				F6_about_slideshow_3_current = F6_about_slideshow_3_current +1;
				$('#about #slideshow_3 .prev').css({'opacity': '1.0'});
			});
			return;
		}
		//-- 2 (next / rewind)
		if(direction=='next' && F6_about_slideshow_3_current == F6_about_slideshow_3_max){
			// fade #1 in and then set all other too 100% opacity
			$('#about #slideshow_3 #slide_1').stop().animate({'opacity':'1.0'}, F6_transition, function() {
				$('#about #slideshow_3 .slide').each(function(){
					$(this).css({'opacity': '1.0'});
				});
				F6_about_slideshow_3_current = 1;
				$('#about #slideshow_3 .prev').css({'opacity': '0.3'});
			});
			return;
		}

		/* prev */
		//-- 1 (prev / advance)
		if(direction=='prev' && F6_about_slideshow_3_current > 1){
			// fade current prev in 
			F6_about_slideshow_3_current = F6_about_slideshow_3_current -1;
			$('#about #slideshow_3 #slide_'+F6_about_slideshow_3_current).stop().animate({'opacity':'1.0'}, F6_transition, function() {
				/* do nothing */
			});
			if(direction=='prev' && F6_about_slideshow_3_current == 1){
				$('#about #slideshow_3 .prev').css({'opacity': '0.3'});
				return;
			}
			return;
		}
	}
	if(slideshow=='slideshow_4'){
		/* next */
		//-- 1 (next / advance)
		if(direction=='next' && F6_about_slideshow_4_current < F6_about_slideshow_4_max){
			// fade current out
			$('#about #slideshow_4 #slide_'+F6_about_slideshow_4_current).stop().animate({'opacity':'0.0'}, F6_transition, function() {
				F6_about_slideshow_4_current = F6_about_slideshow_4_current +1;
				$('#about #slideshow_4 .prev').css({'display': '1.0'});
			});
			return;
		}
		//-- 2 (next / rewind)
		if(direction=='next' && F6_about_slideshow_4_current == F6_about_slideshow_4_max){
			// fade #1 in and then set all other too 100% opacity
			$('#about #slideshow_4 #slide_1').stop().animate({'opacity':'1.0'}, F6_transition, function() {
				$('#about #slideshow_4 .slide').each(function(){
					$(this).css({'opacity': '1.0'});
				});
				F6_about_slideshow_4_current = 1;
				$('#about #slideshow_4 .prev').css({'opacity': '0.3'});
			});
			return;
		}

		/* prev */
		//-- 1 (prev / advance)
		if(direction=='prev' && F6_about_slideshow_4_current > 1){
			// fade current prev in 
			F6_about_slideshow_4_current = F6_about_slideshow_4_current -1;
			$('#about #slideshow_4 #slide_'+F6_about_slideshow_4_current).stop().animate({'opacity':'1.0'}, F6_transition, function() {
				/* do nothing */
			});
			if(direction=='prev' && F6_about_slideshow_4_current == 1){
				$('#about #slideshow_4 .prev').css({'opacity': '0.3'});
				return;
			}
			return;
		}
	}
}
/* about #slideshow_1 - mouseover - */
$('#about #slideshow_1').mouseover(function() { /* for all site's more buttons */
	$('#about #slideshow_1 .interface').stop().animate({'opacity':'0.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #content_container').stop().animate({'margin-top':'0px'}, 300, function() {
		/* do nothing */
	});
	$('#about #slideshow_1 .prev').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #slideshow_1 .next').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
});
$('#about #slideshow_1').mouseout(function() { /* for all site's more buttons */
	$('#about #slideshow_1 .interface').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #content_container').stop().animate({'margin-top':'-80px'}, 300, function() {
		/* do nothing */
	});
	$('#about #slideshow_1 .prev').stop().animate({'opacity':'0.3'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #slideshow_1 .next').stop().animate({'opacity':'0.3'}, F6_transition, function() {
		/* do nothing */
	});
});
/* about #slideshow_2 - mouseover - */
$('#about #slideshow_2').mouseover(function() { /* for all site's more buttons */
	$('#about #slideshow_2 .interface').stop().animate({'opacity':'0.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #content_container').stop().animate({'margin-top':'0px'}, 300, function() {
		/* do nothing */
	});
	$('#about #slideshow_2 .prev').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #slideshow_2 .next').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
});
$('#about #slideshow_2').mouseout(function() { /* for all site's more buttons */
	$('#about #slideshow_2 .interface').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #content_container').stop().animate({'margin-top':'-80px'}, 300, function() {
		/* do nothing */
	});
	$('#about #slideshow_2 .prev').stop().animate({'opacity':'0.3'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #slideshow_2 .next').stop().animate({'opacity':'0.3'}, F6_transition, function() {
		/* do nothing */
	});
});
/* about #slideshow_3 - mouseover - */
$('#about #slideshow_3').mouseover(function() { /* for all site's more buttons */
	$('#about #slideshow_3 .interface').stop().animate({'opacity':'0.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #content_container').stop().animate({'margin-top':'0px'}, 300, function() {
		/* do nothing */
	});
	$('#about #slideshow_3 .prev').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #slideshow_3 .next').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
});
$('#about #slideshow_3').mouseout(function() { /* for all site's more buttons */
	$('#about #slideshow_3 .interface').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #content_container').stop().animate({'margin-top':'-80px'}, 300, function() {
		/* do nothing */
	});
	$('#about #slideshow_3 .prev').stop().animate({'opacity':'0.3'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #slideshow_3 .next').stop().animate({'opacity':'0.3'}, F6_transition, function() {
		/* do nothing */
	});
});
/* about #slideshow_4 - mouseover - */
$('#about #slideshow_4').mouseover(function() { /* for all site's more buttons */
	$('#about #slideshow_4 .interface').stop().animate({'opacity':'0.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #content_container').stop().animate({'margin-top':'0px'}, 300, function() {
		/* do nothing */
	});
	$('#about #slideshow_4 .prev').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #slideshow_4 .next').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
});
$('#about #slideshow_4').mouseout(function() { /* for all site's more buttons */
	$('#about #slideshow_4 .interface').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #content_container').stop().animate({'margin-top':'-80px'}, 300, function() {
		/* do nothing */
	});
	$('#about #slideshow_4 .prev').stop().animate({'opacity':'0.3'}, F6_transition, function() {
		/* do nothing */
	});
	$('#about #slideshow_4 .next').stop().animate({'opacity':'0.3'}, F6_transition, function() {
		/* do nothing */
	});
});

var F6_slideshow_teaching_current = 1;
function F6_teaching_slideshow(slideshow, direction){
	if(slideshow=='slideshow_teaching'){
		/* next */
		//-- 1 (next / advance)
		if(direction=='next' && F6_slideshow_teaching_current < F6_slideshow_teaching_max){
			// fade current out
			$('#teaching #slideshow_teaching #slide_'+F6_slideshow_teaching_current).stop().animate({'opacity':'0.0'}, F6_transition, function() {
				F6_slideshow_teaching_current = F6_slideshow_teaching_current +1;
				$('#teaching #slideshow_teaching .prev').css({'opacity': '1.0'});
			});
			return;
		}
		//-- 2 (next / rewind)
		if(direction=='next' && F6_slideshow_teaching_current == F6_slideshow_teaching_max){
			// fade #1 in and then set all other too 100% opacity
			$('#teaching #slideshow_teaching #slide_1').stop().animate({'opacity':'1.0'}, F6_transition, function() {
				$('#teaching #slideshow_teaching .slide').each(function(){
					$(this).css({'opacity': '1.0'});
				});
				F6_slideshow_teaching_current = 1;
				$('#teaching #slideshow_teaching .prev').css({'opacity': '0.3'});
			});
			return;
		}

		/* prev */
		//-- 1 (prev / advance)
		if(direction=='prev' && F6_slideshow_teaching_current > 1){
			// fade current prev in 
			F6_slideshow_teaching_current = F6_slideshow_teaching_current -1;
			$('#teaching #slideshow_teaching #slide_'+F6_slideshow_teaching_current).stop().animate({'opacity':'1.0'}, F6_transition, function() {
				/* do nothing */
			});
			if(direction=='prev' && F6_slideshow_teaching_current == 1){
				$('#teaching #slideshow_teaching .prev').css({'opacity': '0.3'});
				return;
			}
			return;
		}
	}
}
/* teaching #slideshow_teaching - mouseover - */
$('#teaching #slideshow_teaching').mouseover(function() { /* for all site's more buttons */
	$('#teaching #slideshow_teaching .interface').stop().animate({'opacity':'0.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#teaching #content_container').stop().animate({'margin-top':'0px'}, 300, function() {
		/* do nothing */
	});
	$('#teaching #slideshow_teaching .prev').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#teaching #slideshow_teaching .next').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
});
$('#teaching #slideshow_teaching').mouseout(function() { /* for all site's more buttons */
	$('#teaching #slideshow_teaching .interface').stop().animate({'opacity':'1.0'}, F6_transition, function() {
		/* do nothing */
	});
	$('#teaching #content_container').stop().animate({'margin-top':'-80px'}, 300, function() {
		/* do nothing */
	});
	$('#teaching #slideshow_teaching .prev').stop().animate({'opacity':'0.3'}, F6_transition, function() {
		/* do nothing */
	});
	$('#teaching #slideshow_teaching .next').stop().animate({'opacity':'0.3'}, F6_transition, function() {
		/* do nothing */
	});
});