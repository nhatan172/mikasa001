// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

window.fbAsyncInit = function() {
  FB.init({
    appId: '760099080830192',
    xfbml: true,
    version: 'v2.6'
  });
};

(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)){
    return;
  }
  js = d.createElement(s); 
  js.id = id;
  js.src = '//connect.facebook.net/en_US/sdk.js';
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

$(function(){
  $('.chat_fb').click(function() {
    $('.fchat').toggle('slow');
  });
});

var amountScrolled = 30;

$(window).scroll(function() {
  if ( $(window).scrollTop() > amountScrolled ) {
    $('back-to-top').find('a').fadeIn('slow');
  } 
  else {
    $('back-to-top').find('a').fadeOut('slow');
  }
});

$('back_to_top').find('a').click(function() {
  $('html, body').animate({
    scrollTop: 0
  }, 800);
  return false;
});
