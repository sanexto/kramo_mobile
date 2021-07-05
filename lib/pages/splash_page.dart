import 'package:flutter/material.dart';

import 'package:splashscreen/splashscreen.dart';

import '../config.dart';

import './garage/home_page.dart';

class SplashPage extends StatefulWidget {

  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();

}

class _SplashPageState extends State<SplashPage> {

  @override
  Widget build(BuildContext context) {

    return SplashScreen(
      navigateAfterFuture: this._homePage(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      image: Image.asset('assets/logo.png'),
      loadingText: Text(
        config['app']['name'],
        style: TextStyle(
          color: Theme.of(context).textTheme.headline1!.color,
          fontSize: Theme.of(context).primaryTextTheme.headline5!.fontSize,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
      photoSize: 64.0,
      useLoader: false,
    );

  }

  Future<Widget> _homePage() async {

    await Future.delayed(
      Duration(
        seconds: 1,
      ),
    );

    return HomePage();

  }

}
