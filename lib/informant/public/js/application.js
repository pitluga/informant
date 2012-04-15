var Informant = {
  easydateLocale: {
    "future_format": "%s %t",
    "past_format": "%t %s",
    "second": "s",
    "seconds": "s",
    "minute": "m",
    "minutes": "m",
    "hour": "h",
    "hours": "h",
    "day": "d",
    "days": "d",
    "week": "w",
    "weeks": "w",
    "month": "mo",
    "months": "mo",
    "year": "y",
    "years": "y",
    "yesterday": "yesterday",
    "tomorrow": "tomorrow",
    "now": "just now",
    "ago": "ago",
    "in": "in"
  },

  reschedule: function(event) {
    var target = $(event.currentTarget);
    $.ajax({
      url: '/' + target.data('node') + '/' + target.data('command') + '/reschedule',
      type: 'POST',
      success: function(data, textStatus, jqXHR) {
        console.log("success");
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.log("error");
      }
    });
  },

  silence: function(element) {
    console.log(element);
  },

  wireButtons: function() {
    $("a.reschedule-btn").click(Informant.reschedule);
    $("a.silence-btn").click(Informant.silence);
  },

  markNever: function(_, element) {
    if ($(element).attr('title') === "") {
      $(element).html('never');
    }
  },

  subscribe: function() {
    socket = new WebSocket("ws://" + location.hostname + ":4000");
    socket.onmessage = Informant.updateCheck;
  },

  updateDates: function() {
    $('.easydate').each(Informant.markNever);
    $('.easydate').easydate({live: false, locale: Informant.easydateLocale});
  },

  updateCounts: function(check, label, badge) {
    var count = $('#' + check.nodeName + '-table span.label-' + label).length;
    var badge = $('#' + check.nodeName + '-list span.badge-' + badge);
    if (count > 0) {
      badge.html(count);
      badge.removeClass('hide');
    } else {
      badge.addClass('hide');
    }
  },

  updateCheck: function(event) {
    var check = JSON.parse(event.data);
    var row = $('#' + check.id);
    $('#' + check.id + ' .label-col').html(Informant.rowLabelTemplate(check, {}));
    $('#' + check.id + ' .timestamp-col').html(Informant.rowTimestampTemplate(check, {}));
    $('#' + check.id + ' .output-col').html(check.output);
    Informant.updateCounts(check, 'warning', 'warning');
    Informant.updateCounts(check, 'important', 'error');
  }
}

$(function() {
  Informant.rowLabelTemplate = Handlebars.compile($("#row-label-template").html());
  Informant.rowTimestampTemplate = Handlebars.compile($("#row-timestamp-template").html());
  Informant.wireButtons();
  Informant.subscribe();
  Informant.updateDates();
  setInterval(Informant.updateDates, 1000);
});
