import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/pick_icon.dart';

class ErrorBox extends StatefulWidget {

  final String message;
  final VoidCallback? onRetry;

  ErrorBox({Key? key, required this.message, required this.onRetry}) : super(key: key);

  @override
  _ErrorBoxState createState() => _ErrorBoxState();

}

class _ErrorBoxState extends State<ErrorBox> {

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(
            pickIcon('exclamation-circle'),
            color: Theme.of(context).primaryColor,
            size: 128.0,
          ),
          SizedBox(
            height: 32.0,
          ),
          Text(
            this.widget.message,
            style: TextStyle(
              fontSize: Theme.of(context).primaryTextTheme.subtitle1!.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 32.0,
          ),
           SizedBox(
            height: Theme.of(context).primaryTextTheme.headline2!.fontSize,
            child: ElevatedButton(
              child: Text(
                'Reintentar',
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: this.widget.onRetry,
            ),
          ),
        ],
      ),
    );

  }

}
