import '../utils/date_time_formatter.dart';

class DateTimeValue {

  String _valueFormat = '';
  String? _valueLocale;
  String _maskFormat = '';
  String? _maskLocale;

  String _value = '';
  String _mask = '';
  DateTime? _dateTime;

  DateTimeValue({required String valueFormat, String? valueLocale, required String maskFormat, String? maskLocale}) {

    this._valueFormat = valueFormat;
    this._valueLocale = valueLocale;
    this._maskFormat = maskFormat;
    this._maskLocale = maskLocale;

  }

  String get value => this._value;

  set value(String newValue) {

    if (newValue.isNotEmpty) {

      final DateTime? newDateTime = parseDateTime(newValue, this._valueFormat, this._valueLocale);

      if (newDateTime != null) {

        final String? newMask = formatDateTime(newDateTime, this._maskFormat, this._maskLocale);

        if (newMask != null) {

          this._value = newValue;
          this._mask = newMask;
          this._dateTime = newDateTime;

        }

      }

    } else {

      this._value = '';
      this._mask = '';
      this._dateTime = null;

    }

  }

  String get mask => this._mask;

  set mask(String newMask) {

    if (newMask.isNotEmpty) {

      final DateTime? newDateTime = parseDateTime(newMask, this._maskFormat, this._maskLocale);

      if (newDateTime != null) {

        final String? newValue = formatDateTime(newDateTime, this._valueFormat, this._valueLocale);

        if (newValue != null) {

          this._value = newValue;
          this._mask = newMask;
          this._dateTime = newDateTime;

        }

      }

    } else {

      this._value = '';
      this._mask = '';
      this._dateTime = null;

    }

  }

  DateTime? get dateTime => this._dateTime;

  set dateTime(DateTime? newDateTime) {

    if (newDateTime != null) {

      final String? newValue = formatDateTime(newDateTime, this._valueFormat, this._valueLocale);
      final String? newMask = formatDateTime(newDateTime, this._maskFormat, this._maskLocale);

      if (newValue != null && newMask != null) {

        this._value = newValue;
        this._mask = newMask;
        this._dateTime = newDateTime;

      }

    } else {

      this._value = '';
      this._mask = '';
      this._dateTime = null;

    }

  }

}
