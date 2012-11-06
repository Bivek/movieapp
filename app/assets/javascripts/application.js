//= require zepto
//= require rails
//= require_tree .
//= require facebox

$.facebox.settings.loadingImage = '/assets/facebox-loading.gif'
$.facebox.settings.closeImage ='/assets/facebox-close.png'

$.fn.outerWidth = function() {
  return this[0] && this[0].offsetWidth;
}

var origTrigger = $.fn.trigger
$.fn.trigger = function(event, data) {
  if (typeof event == 'string') event = event.replace(/\..+$/, '')
  return origTrigger.call(this, event, data)
}

$(function(){
  $('a[rel*=facebox]').facebox()
})

$.fn.fadeIn = function(speed, fn) {
  if (typeof speed == 'function') fn = speed
  this.show()
  if (fn) fn.call()
}

$.fn.fadeOut = function(speed, fn) {
  if (typeof speed == 'function') fn = speed
  this.hide()
  if (fn) fn.call()
}
