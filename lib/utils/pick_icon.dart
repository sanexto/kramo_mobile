import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Map<String, IconData> _icons = {
  'exclamation-circle': FontAwesomeIcons.exclamationCircle,
  'eye': FontAwesomeIcons.solidEye,
  'eye-slash': FontAwesomeIcons.solidEyeSlash,
  'lock': FontAwesomeIcons.lock,
  'power-off': FontAwesomeIcons.powerOff,
  'user': FontAwesomeIcons.solidUser,
  'user-circle': FontAwesomeIcons.solidUserCircle,
  'user-lock': FontAwesomeIcons.userLock,
};

IconData? pickIcon(String name) {

  return _icons[name];

}
