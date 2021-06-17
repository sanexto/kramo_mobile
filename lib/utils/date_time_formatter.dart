import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

DateTime? parseDateTime(String dateTimeString, String format, [String? locale]) {

  DateTime? result;

  DateTime? dateTime;

  try {

    dateTime = DateFormat(format, locale).parseStrict(dateTimeString);

  } catch (_) {}

  if (dateTime != null) {

    result = dateTime;

  }

  return result;

}

String? formatDateTime(DateTime dateTime, String format, [String? locale]) {

  String? result;

  String? dateTimeString;

  try {

    dateTimeString = DateFormat(format, locale).format(dateTime);

  } catch (_) {}

  if (dateTimeString != null) {

    result = dateTimeString;

  }

  return result;

}

DateTimeRange? parseDateTimeRange(String dateTimeRangeString, String separator, String format, [String? locale]) {

  DateTimeRange? result;

  final List<String> dateTimeRange = dateTimeRangeString.split(separator);

  if (dateTimeRange.length == 2) {

    DateTime? startDateTime;
    DateTime? endDateTime;

    try {

      startDateTime = DateFormat(format, locale).parseStrict(dateTimeRange[0]);

    } catch (_) {}

    try {

      endDateTime = DateFormat(format, locale).parseStrict(dateTimeRange[1]);

    } catch (_) {}

    if (startDateTime != null && endDateTime != null) {

      result = DateTimeRange(
        start: startDateTime,
        end: endDateTime,
      );

    }

  }

  return result;

}

String? formatDateTimeRange(DateTimeRange dateTimeRange, String separator, String format, [String? locale]) {

  String? result;

  String? startDateTimeString;
  String? endDateTimeString;

  try {

    startDateTimeString = DateFormat(format, locale).format(dateTimeRange.start);

  } catch (_) {}

  try {

    endDateTimeString = DateFormat(format, locale).format(dateTimeRange.end);

  } catch (_) {}

  if (startDateTimeString != null && endDateTimeString != null) {

    result = '$startDateTimeString$separator$endDateTimeString';

  }

  return result;

}
