import 'package:flutter/material.dart';

class TimePicker {

  static Future<DateTime?> show({required BuildContext context, DateTime? initialTime}) async {

    TimeOfDay _initialTime;

    if (initialTime != null) {

      _initialTime = TimeOfDay.fromDateTime(initialTime);

    } else {

      final TimeOfDay nowTime = TimeOfDay.now();

      _initialTime = nowTime;

    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _initialTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    return pickedTime != null ? DateTime(1970, 1, 1, pickedTime.hour, pickedTime.minute) : null;

  }

}
