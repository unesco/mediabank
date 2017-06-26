/**************************
 Script to change eprint  
 login menu to bootstap 
 nav-stacked
***************************/
var j = jQuery.noConflict();

j(document).ready(function () {
    var pathname = window.location.pathname;
    //Clones the EP menu to the top menu.
    //j('.ep_tm_key_tools').appendTo('#login_status');
    //Then remove the old class, and add the navbar classes to make it fit in.
    j('header .ep_tm_key_tools').removeClass('ep_tm_key_tools').addClass('nav navbar-nav navbar-right').attr('id','ep_menu_top');
    // remove the first part of the menu if you are already signed in (as the span buggers up the nice navbar menu)
    j('header #ep_menu_top li:first-child').has("span").remove();

    // If the user isn't logged in, style it a little
    //j('ul#ep_menu li:first-child a[href$="cgi/users/home"]').addClass('list-group-item-heading');
    var log_in_btn = j('ul#ep_menu li:first-child a[href$="cgi/users/home"]');
    var admin_btn = j('ul#ep_menu li a[href$="cgi/users/home?screen=Admin"]');
    //log_in_btn.addClass('btn btn-primary');
    //admin_btn.addClass('btn btn-default');
    log_in_btn.closest('li').addClass('active');
    //admin_btn.closest('li').removeClass('list-group-item');
    //log_in_btn.closest('ul').removeClass('list-group').addClass('list-unstyled');
    if (pathname.match("/view/.+/")){
        var myview = pathname.split('/');
        j('.ep_view_menu').addClass(myview[3]);
    }
    j('.ep_view_menu').addClass('container');
    j('.ep_action_list').addClass('list-inline list-unstyle');
    j('table').addClass('table table-bordered table-hover');
});
