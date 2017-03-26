
// Hide Header on on scroll down
var didScroll;
var lastScrollTop = 0;
var delta = 5;
var navbarHeight = $('header').outerHeight();

$(window).scroll(function(event){
    didScroll = true;
});

setInterval(function() {
    if (didScroll) {
        hasScrolled();
        didScroll = false;
    }
}, 150);

function hasScrolled() {
    var st = $(this).scrollTop();
    
    // Make sure they scroll more than delta
    if(Math.abs(lastScrollTop - st) <= delta)
        return;
    
    // If they scrolled down and are past the navbar, add class .nav-up.
    // This is necessary so you never see what is "behind" the navbar.
    if (st > lastScrollTop && st > navbarHeight){
        // Scroll Down
        $('header').removeClass('header').addClass('nav-up');
    } else {
        // Scroll Up
        if(st + $(window).height() < $(document).height()) {
            $('header').removeClass('nav-up').addClass('header');
        }
    }
    
    lastScrollTop = st;
}

  /* Navigation scroll color change */
  $(window).bind('scroll', function () {
    var navHeight = $(window).height() ;
    if ($(window).scrollTop() > navHeight) {
      $('.nav-down').addClass('on');
    }
    else {
      $('.nav-down').removeClass('on');
    }
  }); 
  
var dgPull = dgPull || {};
(function ($) {
    $(document).ready(function () {
        $(window).scroll(dgPull.scrollFn);
        $(window).scroll(function () {
            if ($(this).scrollTop() > 100) {
                $('.scrollup').fadeIn();
            }
            else {
                $('.scrollup').fadeOut();
            }
        });
        $('.scrollup').click(function () {
            $("html, body").animate({
                scrollTop: 0
            }, 600);
            return false;
        });
    });
})(jQuery);
(function ($) {
    $.fn.flowUp = function (e, options) {
        var settings = $.extend({
            translateY: 160
            , duration: .10
            , externalCSS: false
        }, options);
        $(e).addClass('pullup-element');
        $(e).each(function (i, el) {
            var el = $(el);
            if (el.visible(true)) {
                el.addClass("already-visible");
            }
            else {
                el.addClass('opaque');
            }
        });
        if (!settings.externalCSS) {
            $("head").append('<style>.come-in{opacity: 1; -ie-transform:translateY(' + settings.translateY + 'px);-webkit-transform:translateY(' + settings.translateY + 'px);transform:translateY(' + settings.translateY + 'px);-webkit-animation:come-in ' + settings.duration + 's ease forwards;animation:come-in ' + settings.duration + 's ease forwards}.come-in:nth-child(odd){-webkit-animation-duration:' + settings.duration + 's;animation-duration:' + settings.duration + 's}.already-visible{opacity: 1;-ie-transform:translateY(0);-webkit-transform:translateY(0);transform:translateY(0);-webkit-animation:none;animation:none}@-webkit-keyframes come-in{to{-ie-transform:translateY(0);-webkit-transform:translateY(0);transform:translateY(0)}}@keyframes come-in{to{-ie-transform:translateY(0);-webkit-transform:translateY(0);transform:translateY(0)}} .opaque { opacity: 0; }</style>');
        }
        return this;
    };
    $.fn.visible = function (partial) {
        var $t = $(this)
            , $w = $(window)
            , viewTop = $w.scrollTop()
            , viewBottom = viewTop + $w.height()
            , _top = $t.offset().top
            , _bottom = _top + $t.height()
            , compareTop = partial === true ? _bottom : _top
            , compareBottom = partial === true ? _top : _bottom;
        return ((compareBottom <= viewBottom) && (compareTop >= viewTop));
    };
}(jQuery));
dgPull.scrollFn = function () {
    jQuery(".pullup-element").each(function (i, el) {
        var el = jQuery(el);
        if (el.visible(true)) {
            el.addClass("come-in");
            el.removeClass("opaque");
        }
    });
}