LTSpinner = (function() {

  function LTSpinner(opts) {
    this.opts = _.extend({
      lines: 13,
      length: 30,
      width: 14,
      radius: 40,
      corners: 1,
      rotate: 0,
      direction: 1,
      speed: 1,
      trail: 60,
      shadow: false,
      hwaccel: false,
      className: 'spinner',
      zIndex: 2e9,
      top: '50px',
      left: '420px',
      color: '#f80',
      element: 'spinner'
    }, opts);
    this.spinner = new Spinner(this.opts);
  }

  LTSpinner.prototype.spin = function() {
    return this.spinner.spin(document.getElementById(this.opts.element || 'spinner'));
  };

  return LTSpinner;

})();
