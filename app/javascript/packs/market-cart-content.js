import $ from 'jquery';
import moment from 'moment';

$(document).on('turbolinks:load', function() {

  function skip_week_end_add(today, businessAdd) {
    var today_idx = today.day();
    var days = (today_idx === 6) ? 1 : 0;

    var businessDaysInc = businessAdd;
    if (today_idx !== 0 && today_idx !== 6) {
      businessDaysInc += today_idx;
    }

    var weekendsCount =
      Math.max(Math.floor(businessDaysInc / 5) - 1, 0) +
      (businessDaysInc > 5 && businessDaysInc % 5 > 0 ? 1 : 0);

    return today.add(businessAdd + weekendsCount * 2, 'days');
  }

  var min_delivery_date = skip_week_end_add(moment(), 3);
  var max_delivery_date = skip_week_end_add(moment(), 14);
  var delivery_date_picker = $('#delivery_date_picker');
  delivery_date_picker.datetimepicker('daysOfWeekDisabled', [0, 6]);
  delivery_date_picker.datetimepicker('minDate', min_delivery_date);
  delivery_date_picker.datetimepicker('maxDate', max_delivery_date);

  window.cart_price_formatter = function(value) {
    return value + '円';
  };
});
