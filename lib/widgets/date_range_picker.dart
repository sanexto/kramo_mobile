import 'package:flutter/material.dart';

import '../config.dart';

import '../utils/date_time_formatter.dart';

class DateRangePicker {

  static final DateTime _firstDate = parseDateTime(config['types']['date']['min'], 'yyyy-M-d H:m:s')!;
  static final DateTime _lastDate = parseDateTime(config['types']['date']['min'], 'yyyy-M-d H:m:s')!;

  static Future<DateTimeRange?> show({required BuildContext context, DateTimeRange? initialDateRange, String? fieldHintText}) async {

    DateTimeRange? _initialDateRange;

    if (initialDateRange != null &&
        !initialDateRange.start.isBefore(DateRangePicker._firstDate) && !initialDateRange.start.isAfter(DateRangePicker._lastDate) &&
        !initialDateRange.end.isBefore(DateRangePicker._firstDate) && !initialDateRange.end.isAfter(DateRangePicker._lastDate) &&
        !initialDateRange.end.isBefore(initialDateRange.start)) {

      _initialDateRange = initialDateRange;

    }

    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: _initialDateRange,
      firstDate: DateRangePicker._firstDate,
      lastDate: DateRangePicker._lastDate,
      initialEntryMode: DatePickerEntryMode.calendar,
      fieldStartHintText: fieldHintText,
      fieldEndHintText: fieldHintText,
    );

    return pickedDateRange;

  }

}
