import 'package:flutter/material.dart';

import '../config.dart';

import '../utils/date_time_formatter.dart';

class DatePicker {

  static final DateTime _firstDate = parseDateTime(config['types']['date']['min'], 'yyyy-M-d H:m:s')!;
  static final DateTime _lastDate = parseDateTime(config['types']['date']['max'], 'yyyy-M-d H:m:s')!;

  static Future<DateTime?> show({required BuildContext context, DateTime? initialDate, String? fieldHintText}) async {

    DateTime _initialDate;

    if (initialDate != null) {

      if (initialDate.isBefore(DatePicker._firstDate)) {

        _initialDate = DatePicker._firstDate;

      } else if (initialDate.isAfter(DatePicker._lastDate)) {

        _initialDate = DatePicker._lastDate;

      } else {

        _initialDate = initialDate;

      }

    } else {

      final DateTime nowDate = DateTime.now();

      if (nowDate.isBefore(DatePicker._firstDate)) {

        _initialDate = DatePicker._firstDate;

      } else if (nowDate.isAfter(DatePicker._lastDate)) {

        _initialDate = DatePicker._lastDate;

      } else {

        _initialDate = nowDate;

      }

    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DatePicker._firstDate,
      lastDate: DatePicker._lastDate,
      initialEntryMode: DatePickerEntryMode.calendar,
      fieldHintText: fieldHintText,
    );

    return pickedDate;

  }

}
