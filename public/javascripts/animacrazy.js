$(function() {
  spinner = new LTSpinner()

  $('input[type=submit]').on('click', function() {
    spinner.spin();
  });
});
