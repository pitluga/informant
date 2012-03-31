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

  markNever: function(_, element) {
    if ($(element).attr('title') === "") {
      $(element).html('never');
    }
  },

  updateDates: function() {
    $('.easydate').each(Informant.markNever);
    $('.easydate').easydate({live: false, locale: Informant.easydateLocale});
  }
}
$(function() {
  Informant.updateDates();
  setInterval(Informant.updateDates, 1000);
});
