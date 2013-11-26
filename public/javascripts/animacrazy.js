$(function() {
  if ($('form.animator').length) {
    // we're on the index page
    spinner = new LTSpinner()

    $('input[type=submit]').on('click', function() {
      spinner.spin();
    });

    var setTextareaFont = function(font) {
      $('form textarea[name=words]').css('font-family',font);
    };

    $('select.select2').select2();
    var $fontSelect = $('select[name=font]');
    $fontSelect.bind('change', function() {
      setTextareaFont($(this).val());
    });

    setTextareaFont($fontSelect.val());

    $('#delay-slider').slider({
      from:0,
      to: 3,
      step: 0.1,
      round: 1,
      dimension: ' s',
      skin: 'c5'
    });

    $('#font-size-slider').slider({
      from:6,
      to: 200,
      step: 1,
      round: 0,
      dimension: ' px',
      skin: 'c5'
    });

    var setBackground = function(bg) {
      if (bg) {
        $('#background').val(bg);
      }
    };

    var syncColorBoxes = function() {
      var bg = $('#background').val();
      if (bg) {
        $('.background .color-box').css('background-color', bg);
      }
      var fg = $('#fill').val();
      if (fg) {
        $('.fill .color-box').css('background-color', bg);
      }
    };

    $('.background .color-box').colpick({
	    colorScheme:'dark',
      submit:0,
	    layout:'hex',
	    color:'ff8800',
	    onChange:function(hsb,hex,rgb, fromColorSet) {
        var c = '#' + hex;
        var el = $('.background .color-box');
		    $(el).css('backgroundColor', c);
        setBackground(c);
	    }
    });

    syncColorBoxes();
  }


});
