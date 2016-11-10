// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-1.11.0.min
//= require jqueryui
//= require jquery.form
//= require jquery.validate
//= require jquery.flexisel
//= require main
//= require modernizr
//= require expand
//= require easyResponsiveTabs
//= require jquery.selectric
//= require jquery.bxslider
//= require jquery.bxslider.min
//= require jquery.fs.tabber
//= require jquery.magnific-popup
//= require jquery.datetimepicker
//= require apprise-1.5.full
//= require apprise-v2
//= require video.dev
//= require video
//= require video.novtt
//= require video.novtt.dev

function search_celeberty() {
    $(".background_shadow").show();
    $("#menuZ").hide();
    $.ajax({
        url: '/celeberties/search_celeberty',
        success: function (data) {
            $(".background_shadow").hide();
            $("#container").html(data)
            $("#head_div").addClass('bg-image');
            $("#menuZ").hide();
        }
    });
}

function user_account(_current_user_id) {
    $(".background_shadow").show();
    $("#menuZ").hide();
    $.ajax({
        url: '/celeberties/user_account?user_id=' + _current_user_id,
        success: function (data) {
            $("#container").html(data)
            $("#head_div").addClass('bg-image');
            $(".background_shadow").hide();
            $("#menuZ").hide();
        }
    });
}


function get_static(param) {
    $(".background_shadow").show();
    $("#menuZ").hide();
    $.ajax({
        url: '/celeberties/static_pages?page=' + param,
        success: function (data) {
            $("#container").html(data)
            $("#head_div").addClass('bg-image');
            $(".background_shadow").hide();
            $("#menuZ").hide();
//            window.scroll(0 ,0)
        }
    });
}
function go_home() {
    $(".background_shadow").show();
    $.ajax({
        url: '/home/go_home',
        success: function (data) {
            $("#container").html(data)
            $("#head_div").removeClass('bg-image');
            $(".background_shadow").hide();
//            window.scroll(0 ,0)
        }
    });
}


function show(id) {
    $(".background_shadow").show();
    $.ajax({
        url: '/celeberties/show?id=' + id,
        success: function (data) {
            $("#container").html(data)
            window.scroll(0, 0)
            $(".background_shadow").hide();
        }
    });
}

function directory() {
    $("#menuZ").hide();
    $.ajax({
        url: '/celeberties/index',
        success: function (data) {
            $("#container").html(data)
//            window.scroll(0, 0)
        }
    });
}
function how_it(how) {
    $.ajax({
        url: '/celeberties/static_pages',
        success: function (data) {
            $("#container").html(data)
//            window.scroll(0, 0)
        }
    });
}


function asign() {
    $('#menuZ').css('display', 'none');

}

