$(function () {
  if ($("form.animator").length) {
    // we're on the index page
    spinner = new GIUSpinner();

    $("input[type=submit]").on("click", function () {
      const value = $(this).val();
      if (/marquee/i.test(value)) {
        $(this)
          .closest("form")
          .append("<input type='hidden' name='marquee' value='marquee'/>");
      }
      spinner.spin();
    });

    var setTextareaFont = function (font) {
      $("form textarea[name=words]").css("font-family", font);
    };

    $("select.select2").select2();
    var $fontSelect = $("select[name=font]");
    $fontSelect.bind("change", function () {
      setTextareaFont($(this).val());
    });

    setTextareaFont($fontSelect.val());

    $("#delay-slider").slider({
      from: 0,
      to: 3,
      step: 0.1,
      round: 1,
      dimension: " s",
      skin: "c5",
      limits: false,
    });

    $("#font-size-slider").slider({
      from: 6,
      to: 200,
      step: 1,
      round: 0,
      dimension: " px",
      skin: "c5",
      limits: false,
    });

    var setColor = function (elId, c) {
      if (c) {
        $("#" + elId).val(c);
      }
    };

    var setBackground = function (bg) {
      setColor("background", bg);
    };

    var setFill = function (fill) {
      setColor("fill", fill);
    };

    var syncColorBoxes = function () {
      var bg = $("#background").val();
      if (bg) {
        $(".background .color-box").css("background-color", bg);
      }
      var fg = $("#fill").val();
      if (fg) {
        $(".fill .color-box").css("background-color", fg);
      }
    };

    $(".background .color-box").colpick({
      colorScheme: "dark",
      submit: 0,
      layout: "hex",
      color: "ff00ff",
      onChange: function (hsb, hex, rgb, fromColorSet) {
        var c = "#" + hex;
        var el = $(".background .color-box");
        $(el).css("backgroundColor", c);
        setBackground(c);
      },
    });

    $(".fill .color-box").colpick({
      colorScheme: "dark",
      submit: 0,
      layout: "hex",
      color: "cccccc",
      onChange: function (hsb, hex, rgb, fromColorSet) {
        var c = "#" + hex;
        var el = $(".fill .color-box");
        $(el).css("backgroundColor", c);
        setFill(c);
      },
    });

    syncColorBoxes();

    /* returned polling message looks like this
     {
       file: "/generated/publictransportationisforjerksandlesbians20131127-18958-1imm3mx.gif"
       maxNumTries: 300
       numTries: 4
     }
    */
    var flash = function (msg) {
      var $f = $(".flash");
      if (msg) {
        if (!$f.length) {
          $f = $("<div>", { class: "flash" });
          $(".container").prepend($f);
        }
        $f.html(msg);
      } else {
        $f.remove();
      }
    };
    var successCb = function () {
      $(".flash").remove();
    };

    var pollingCb = function (pollingInfo) {
      var mx = pollingInfo.maxNumTries;
      var cur = pollingInfo.numTries;
      // console.log("cur vs mx ", cur, mx);
      if (cur > mx / 30) {
        if (cur < mx / 15) {
          flash("Boring...");
        } else if (cur < mx / 7) {
          flash("Geez.  That server is soooo slow!");
        } else if (cur < mx / 4) {
          flash(
            "Maybe you should go have a cup of coffee while we work on this."
          );
        } else if (cur < mx / 2) {
          flash(
            "ARRG! These stupid computers.   Just give me my picture back!"
          );
        } else if (cur >= mx - 1) {
          flash(
            "Shit, man!  Things might be broke.  You could (in a separate browser) look try <a target='blank' href='" +
              pollingInfo.file +
              "'>this file</a> until it works.  Or just give up and file a bug."
          );
        } else {
          flash("Still Trying");
        }
      }
    };

    $(".frame img").imagePoller({ onPoll: pollingCb, onSuccess: successCb });
  }
});
