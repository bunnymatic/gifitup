$(function() {
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

});
