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
  }


});
