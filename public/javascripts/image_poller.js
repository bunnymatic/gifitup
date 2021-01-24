/**
   poll an image tag for a non 404
*/

function ajaxGet(opts) {
  return fetch(opts.url).then(function (resp) {
    if (resp.status >= 400 && resp.status < 600) {
      return Promise.reject(resp);
    } else {
      return Promise.resolve(true);
    }
  });
}

$.imagePollerDefaults = {
  spinner: "img-spinner",
  maximumPolls: 300,
  pollIntervalMs: 500,
  onPoll: function (status) {
    console.log("Poll Count: ", status);
    console.log(this);
  },
  logarithmic: true,
};

$.fn.imagePoller = function (method) {
  var inArgs = arguments;
  var methods = {
    init: function (options) {
      var o = $.extend($.imagePollerDefaults, options);
      var $target = $(this);
      $(this).hide();
      var spinner = new GIUSpinner({
        element: o.spinner,
        className: "img-spinner",
      });
      spinner.spin();
      $(this).each(function (idx, el) {
        var $this = $(this);
        if (this.tagName !== "IMG") {
          throw "This plugin should be applied to an IMG tag";
        }
        var href = $this.attr("src");
        var found = false;
        var interval = null;
        var ctr = 0;
        var interval = setInterval(function () {
          ctr++;
          if (found || ctr > o.maximumPolls) {
            if (interval) {
              clearInterval(interval);
            }
            if (found && o.onSuccess && typeof o.onSuccess === "function") {
              o.onSuccess.apply($target, []);
            }
          } else {
            if (o.onPoll && typeof o.onPoll === "function") {
              o.onPoll.apply($target, [
                { numTries: ctr, maxNumTries: o.maximumPolls, file: href },
              ]);
            }
            ajaxGet({ url: href })
              .then(function (imageFound) {
                $target.attr("src", href);
                $target.show();
                $("#img-spinner").remove();
                found = imageFound;
              })
              .catch(function (error) {
                console.error("ERROR", error.status);
              });
          }
        }, o.pollIntervalMs);
      });
    },
  };
  return this.each(function () {
    // If options exist, send them to init
    // and merge with default settings

    // Method calling logic
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(inArgs, 1));
    } else if (typeof method === "object" || !method) {
      return methods.init.apply(this, inArgs);
    } else {
      $.error("Method " + method + " does not exist on jQuery.imagePoller");
    }
  });
};
