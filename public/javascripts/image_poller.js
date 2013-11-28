/**
   poll an image tag for a non 404
*/
$.imagePollerDefaults = {
  spinner: 'img-spinner',
  maximumPolls: 300,
  pollInterval: 0.5,
  logarithmic: true
};

$.fn.imagePoller = function( method ) {
  var inArgs = arguments;
  var methods = {
    init: function(options) {
      var o = $.extend($.imagePollerDefaults, options);
      var $target = $(this);
      $(this).hide();
      var spinner = new LTSpinner({element: o.spinner, className: 'img-spinner'});
      spinner.spin();
      $(this).each(function(idx, el) {

        var $this = $(this);
        console.log(this)
        if (this.tagName !== 'IMG') {
          throw "This plugin should be applied to an IMG tag"
        }
        var href=$this.attr('src')
        var found = false;
        var interval = null;
        var ctr = 0;
        console.log(href, found, ctr);
        var interval = setInterval(
          function() {
            ctr ++;
            console.log('status:', found, ctr, interval);

            if (found || ctr > o.maximumPolls) {
              if(interval) {
                clearInterval(interval);
              }
            } else {
              $.ajax({
                url: href,
                success: function(status, data, xhr) {
                  $target.attr('src', href);
                  $target.show();
                  $('#img-spinner').remove();
                  found = true;
                  console.log('done');
                },
                error: function(xhr, status, error) {
                  console.log('again');
                }
              });
            }
          }, o.pollInterval * 1000.0);
      });
    },
  };
  return this.each(function() {
    // If options exist, send them to init
    // and merge with default settings

    // Method calling logic
    if ( methods[method] ) {
      return methods[ method ].apply( this, Array.prototype.slice.call( inArgs, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, inArgs );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.imagePoller' );
    }
  });
};
