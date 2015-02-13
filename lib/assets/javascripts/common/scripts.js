/*
 *Kedavra HTML5 Multipurpose Template v1.0
 *Copyright 2014 8Guild.com
 *All scripts for Kedavra HTML5 Multipurpose Template
 */

/*Document Ready*////////////////////////////////////////////////////////////////////////////////////////////////////////////////
jQuery(document).ready(function($) {
	'use strict';

	/*Global Variables
	*******************************************/
	/// Header / Navigation Variables------------------------------------
	var $header = $('.header');
	var $headerToolbar = $('.header-toolbar');
	var $stickyHeader = $('.header.sticky');
	var $scrollHeader = $('.header.scroller');
	var $transpHeader = $('.header.transparent');
	var $menuItem = $('.menu ul li');
	var $naviToggle = $('#nav-toggle');
	var $exitOffCanv = $('.exit-off-canvas');
	var $mobSubmenuToggle = $('.mobile-navi ul li span');
	var $mobButtonsToggle = $('.mobile-navi .buttons li > a');
	var $searchBtn = $('.header .search');

	///Interactive Widgets Variables------------------------------------
	var $tooltip = $('.tooltipped');
	var $logoCarousel = $('.logo-carousel');
	var $sidebarBtn = $('.sidebar-button');
	/// ----------------------------------------------------------------

  /// Forms Variables-------------------------------------------------
  var $scrollTopBtn = $('#scrollTop-btn');
  var $qsForm = $('.header .quick-search');
  /// ----------------------------------------------------------------

	///////////////////////////////////////////////////////////////////////
	///////////////////  Header / Navigation  /////////////////////////////
	//////////////////////////////////////////////////////////////////////

	/*Sticky Header
	*******************************************/
	$(window).on('load', function(){
		$stickyHeader.waypoint('sticky');
		$scrollHeader.waypoint('sticky');
	});

	/*Transparent Header
	*******************************************/
	$(window).on('load', function(){
		if($transpHeader.length > 0) {
			var $logoAlt = $transpHeader.find('.logo > img').data('logo-alt');
			$transpHeader.find('.logo > img').attr('src', $logoAlt);
		}
	});
	$(window).on('scroll', function(){
		var $logoAlt = $transpHeader.find('.logo > img').data('logo-alt');
		var $logoDefault = $transpHeader.find('.logo > img').data('logo-default');
		if($(window).scrollTop() > $(window).height()) {
			$transpHeader.addClass('opaque');
			$transpHeader.find('.logo > img').attr('src', $logoDefault);
		} else {
			$transpHeader.removeClass('opaque');
			$transpHeader.find('.logo > img').attr('src', $logoAlt);
		}
	});

	/*Navi Toggle Animation
	*******************************************/
	$naviToggle.click(function(){
		$(this).toggleClass('active');
		$header.find('.inner').toggleClass('no-shadow');
	});
	$exitOffCanv.click(function(){
		$naviToggle.removeClass('active');
		$header.find('.inner').removeClass('no-shadow');
	});

	/*Foundation Off-Canvas / Intercharge (for responsive images)
	***************************************************************************************/
	$(document).foundation({
		offcanvas : {
			open_method: 'move', // Sets method in which offcanvas opens, can also be 'overlap'
			close_on_click : true
		}
	});

	/*Mobile Navigation
	*******************************************/
	//Breakpoints
	$.breakpoint({
			condition: function () {
					return window.matchMedia('only screen and (max-width:1024px)').matches;
			},
			exit: function () {
				$(window).scrollTop(50); //Topper Issue fix on resize
				$exitOffCanv.trigger('click', function(){
					$naviToggle.removeClass('active');
				});
			}
	});

	//Submenu Toggles
	$mobSubmenuToggle.click(function(){
		if($(this).parent().hasClass('active')) {
			$(this).siblings('ul').removeClass('open');
			$(this).parent().removeClass('active');
		} else {
			$(this).parent().siblings('li').removeClass('active');
			$(this).parent().siblings('li').find('ul').removeClass('open');
			$(this).siblings('ul').toggleClass('open');
			$(this).parent().toggleClass('active');
		}
	});

	//Mobile Langs and Currency Toggles
	$mobButtonsToggle.click(function(e){
		if($(this).parent().hasClass('active')) {
			$(this).siblings('ul').removeClass('open');
			$(this).parent().removeClass('active');
			$mobButtonsToggle.removeClass('non-active');
		} else {
			$(this).parent().siblings('li').removeClass('active');
			$(this).parent().siblings('li').find('ul').removeClass('open');
			$(this).siblings('ul').toggleClass('open');
			$mobButtonsToggle.addClass('non-active');
			$(this).parent().toggleClass('active');
		}
		return false;
	});

	/*Quick Search Form Animation
	*******************************************/
	$searchBtn.click(function() {
		$qsForm.toggleClass('open');
	});
	$('.topper, .page, .footer').click(function(){
		$qsForm.removeClass('open');
	});
	$(window).on('resize', function(){
		$qsForm.removeClass('open');
	});

	///////////////////////////////////////////////////////////////////////
	///////////  Parallax Backgrounds / OnScroll Animations  //////////////
	//////////////////////////////////////////////////////////////////////

	$(window).on('load', function(){
		/*Checking if it's touch device we disable parallax / Onscroll animations feature due to inconsistency*/
		if (Modernizr.touch) {

			$('body').removeClass('parallax');
			$('body').removeClass('animated fadeIn');
			$('*').removeClass('animation');
		}

		/*Parallax Backgrounds
		*********************************************/
		if($('.parallax').length > 0){
			$('.parallax').stellar({
				horizontalScrolling: false,
				responsive:true
			});
		}

		/*Content Animations On Scroll
		*********************************************/
		if($('.animation').length > 0){
			$('.animation').waypoint(function() {
					 var $animation = $(this).data("animation");
					 $(this).addClass($animation);
					 $(this).addClass('animated');
			}, { offset: '82%' });
		}

	});


	/*Date Picker Widget
	************************************************************/
	if($('#datePicker').length > 0) {
		$('#datePicker').datepicker().on('changeDate', function(e){
      $('#chosen_date').val(e.format('dd/mm/yyyy'))
    });;
		$('.datepicker .prev').html('<i class="fa fa-angle-left"></i>');
		$('.datepicker .next').html('<i class="fa fa-angle-right"></i>');
	}

	/*Slide Up/Down Home Events
	************************************************************/
	$('#slide-up-toggle').click(function(){
		$('.slide-up').toggleClass('open');
	});

	/*Tooltips
	*******************************************/
	$tooltip.tooltip();

	///////////////////////////////////////////////////////////////////////
	///////////////////  Gallery Grids + Filtering  //////////////////////
	//////////////////////////////////////////////////////////////////////

	/*Massonry Gallery Grid
	*******************************************/
	// Stitching class
	var $filter = $('.filters li a');
	$filter.click(function(){
		$filter.parent().removeClass('current');
		$(this).parent().addClass('current');
	});

	// Initialize isotope
	var $gallGridMassonry = $('.gallery-grid.masonry');
	$gallGridMassonry.isotope({
    itemSelector: '.item',
    masonry: {
      columnWidth: '.grid-sizer'
    }
	});

	// filter items when filter link is clicked
	$('.filters a').click(function(){
		var selector = $(this).attr('data-filter');
		$gallGridMassonry.isotope({
			filter: selector
		});
		return false;
	});


	///////////////////////////////////////////////////////////////////////
	/////////////////////////  Google Maps  //////////////////////////////
	//////////////////////////////////////////////////////////////////////
	var geocoder;
	var map;
	var query = $('.google-map').data('location');
	var zoom = $('.google-map').data('zoom');

	function initialize() {

		geocoder = new google.maps.Geocoder();
		var latlng = new google.maps.LatLng(-34.397, 150.644);

			var mapOptions = {
				center: latlng,
				zoom: zoom,
				scrollwheel: false,
				disableDefaultUI: true,
				styles: [{"featureType":"landscape","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"stylers":[{"hue":"#00aaff"},{"saturation":-100},{"gamma":2.15},{"lightness":12}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"lightness":24}]},{"featureType":"road","elementType":"geometry","stylers":[{"lightness":57}]}]
			};

			map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

			codeAddress();
	}

	function codeAddress() {
		var image = 'img/map-marker.png';
		var address = query;
		geocoder.geocode( { 'address': address}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				map.setCenter(results[0].geometry.location);
				var marker = new google.maps.Marker({
						map: map,
						position: results[0].geometry.location,
						icon: image,
						title: 'My Kedavra Office'
				});
			} else {
				alert('Geocode was not successful for the following reason: ' + status);
			}
		});
	}

	if($('#map-canvas').length > 0) {
		google.maps.event.addDomListener(window, 'load', initialize);
	}


	/*Adding Placeholder Support in Older Browsers
	************************************************/
	$('input, textarea').placeholder();

	/*Custom Style Checkboxes and Radios
	************************************************/
	$('input').iCheck({
    checkboxClass: 'icheckbox',
    radioClass: 'iradio'
  });

	///////////////////////////////////////////////////////////////////////
	/////////  INTERNAL ANCHOR LINKS SCROLLING (NAVIGATION)  //////////////
	//////////////////////////////////////////////////////////////////////

	$(".scroll").click(function(event){
		var $elemOffsetTop = $(this).data('offset-top');
		$('html, body').animate({scrollTop:$(this.hash).offset().top-$elemOffsetTop}, 1000, 'easeOutExpo');
		$naviToggle.removeClass('active');
		event.preventDefault();
	});
	$('.scrollup').click(function(e){
		e.preventDefault();
		$('html, body').animate({scrollTop : 0}, {duration: 700, easing:'easeOutExpo'});
		$naviToggle.removeClass('active');
	});


	$(window).scroll(function(){
		if ($(this).scrollTop() > 500) {
			$('#scroll-top').addClass('visible');
		} else {
			$('#scroll-top').removeClass('visible');
		}
	});

	//SCROLL-SPY
	// Cache selectors
	var lastId,
		topMenu = $(".scroll-menu"),
		topMenuHeight = topMenu.outerHeight(),
		// All list items
		menuItems = topMenu.find("a"),
		// Anchors corresponding to menu items
		scrollItems = menuItems.map(function(){
		  var item = $($(this).attr("href"));
		  if (item.length) { return item; }
		});

	// Bind to scroll
	$(window).scroll(function(){
	   // Get container scroll position
	   var fromTop = $(this).scrollTop()+topMenuHeight+200;

	   // Get id of current scroll item
	   var cur = scrollItems.map(function(){
		 if ($(this).offset().top < fromTop)
		   return this;
	   });
	   // Get the id of the current element
	   cur = cur[cur.length-1];
	   var id = cur && cur.length ? cur[0].id : "";

	   if (lastId !== id) {
		   lastId = id;
		   // Set/remove active class
		   menuItems
			 .parent().removeClass("active")
			 .end().filter("[href=#"+id+"]").parent().addClass("active");
	   }
	});
});/*Document Ready End*//////////////////////////////////////////////////////////////////////////

/*Back Function: Manipulating the browser history
*************************************************/
function goBack() {
	window.history.back()
}
