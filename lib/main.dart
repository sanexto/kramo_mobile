import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import './config.dart';

import './pages/splash_page.dart';

void main() {

  runApp(App());

}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('es'),
      ],
      title: config['app']['name'],
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
        ),
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );

  }

}
