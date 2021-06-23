import 'package:flutter/material.dart';

import '../utils/date_time_formatter.dart';

class DateTimeRangeValue {

  String _valueSeparator = '';
  String _valueFormat = '';
  String? _valueLocale;
  String _maskSeparator = '';
  String _maskFormat = '';
  String? _maskLocale;

  String _value = '';
  String _mask = '';
  DateTimeRange? _dateTimeRange;

  DateTimeRangeValue({required String valueSeparator, required String valueFormat, String? valueLocale, required String maskSeparator, required String maskFormat, String? maskLocale}) {

    this._valueSeparator = valueSeparator;
    this._valueFormat = valueFormat;
    this._valueLocale = valueLocale;
    this._maskSeparator = maskSeparator;
    this._maskFormat = maskFormat;
    this._maskLocale = maskLocale;

  }

  String get value => this._value;

  set value(String newValue) {

    final DateTimeRange? newDateTimeRange = parseDateTimeRange(newValue, this._valueSeparator, this._valueFormat, this._valueLocale);

    if (newDateTimeRange != null) {

      final String? newMask = formatDateTimeRange(newDateTimeRange, this._maskSeparator, this._maskFormat, this._maskLocale);

      if (newMask != null) {

        this._value = newValue;
        this._mask = newMask;
        this._dateTimeRange = newDateTimeRange;

      } else {

        this._value = newValue;
        this._mask = newValue;
        this._dateTimeRange = null;

      }

    } else {

      this._value = newValue;
      this._mask = newValue;
      this._dateTimeRange = null;

    }

  }

  String get mask => this._mask;

  set mask(String newMask) {

    final DateTimeRange? newDateTimeRange = parseDateTimeRange(newMask, this._maskSeparator, this._maskFormat, this._maskLocale);

    if (newDateTimeRange != null) {

      final String? newValue = formatDateTimeRange(newDateTimeRange, this._valueSeparator, this._valueFormat, this._valueLocale);

      if (newValue != null) {

        this._value = newValue;
        this._mask = newMask;
        this._dateTimeRange = newDateTimeRange;

      } else {

        this._value = newMask;
        this._mask = newMask;
        this._dateTimeRange = null;

      }

    } else {

      this._value = newMask;
      this._mask = newMask;
      this._dateTimeRange = null;

    }

  }

  DateTimeRange? get dateTimeRange => this._dateTimeRange;

  set dateTimeRange(DateTimeRange? newDateTimeRange) {

    if (newDateTimeRange != null) {

      final String? newValue = formatDateTimeRange(newDateTimeRange, this._valueSeparator, this._valueFormat, this._valueLocale);
      final String? newMask = formatDateTimeRange(newDateTimeRange, this._maskSeparator, this._maskFormat, this._maskLocale);

      if (newValue != null && newMask != null) {

        this._value = newValue;
        this._mask = newMask;
        this._dateTimeRange = newDateTimeRange;

      } else {

        this._value = '';
        this._mask = '';
        this._dateTimeRange = null;

      }

    } else {

      this._value = '';
      this._mask = '';
      this._dateTimeRange = null;

    }

  }

}
