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

    var setColor = function(elId,c) {
      if (c) {
        $('#'+elId).val(c);
      }
    };

    var setBackground = function(bg) {
      setColor('background', bg);
    };

    var setFill = function(fill) {
      setColor('fill', fill);
    };


    var syncColorBoxes = function() {
      var bg = $('#background').val();
      if (bg) {
        $('.background .color-box').css('background-color', bg);
      }
      var fg = $('#fill').val();
      console.log(fg);
      if (fg) {
        $('.fill .color-box').css('background-color', fg);
      }
    };

    $('.background .color-box').colpick({
	    colorScheme:'dark',
      submit:0,
	    layout:'hex',
	    color:'ff00ff',
	    onChange:function(hsb,hex,rgb, fromColorSet) {
        var c = '#' + hex;
        var el = $('.background .color-box');
		    $(el).css('backgroundColor', c);
        setBackground(c);
	    }
    });

    $('.fill .color-box').colpick({
	    colorScheme:'dark',
      submit:0,
	    layout:'hex',
	    color:'cccccc',
	    onChange:function(hsb,hex,rgb, fromColorSet) {
        var c = '#' + hex;
        var el = $('.fill .color-box');
		    $(el).css('backgroundColor', c);
        setFill(c);
	    }
    });

    syncColorBoxes();

    $('.frames img').imagePoller();
  }


});
