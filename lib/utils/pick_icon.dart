import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Map<String, IconData> _icons = {
  'ellipsis-v': FontAwesomeIcons.ellipsisV,
  'exclamation-circle': FontAwesomeIcons.exclamationCircle,
  'eye': FontAwesomeIcons.solidEye,
  'eye-slash': FontAwesomeIcons.solidEyeSlash,
  'lock': FontAwesomeIcons.lock,
  'plus': FontAwesomeIcons.plus,
  'power-off': FontAwesomeIcons.powerOff,
  'search': FontAwesomeIcons.search,
  'sliders-h': FontAwesomeIcons.slidersH,
  'sync': FontAwesomeIcons.sync,
  'user': FontAwesomeIcons.solidUser,
  'user-circle': FontAwesomeIcons.solidUserCircle,
  'user-lock': FontAwesomeIcons.userLock,
};

IconData? pickIcon(String name) {

  return _icons[name];

}
