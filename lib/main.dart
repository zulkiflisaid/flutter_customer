import 'dart:async';

import 'package:flutter/material.dart';

import 'landingpage/landingpage_view.dart';
import 'lupa_pass.dart';
import 'lupa_pass_pin.dart';
import 'task.dart';
import 'register.dart';
import 'splash.dart';
import 'login.dart';
import 'register_hp.dart';

void main() => runApp(MyApp());
//Map<String, dynamic> dataP;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Driver Daring',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: SplashPage(),
        /* Scaffold(
          body: Center(
            child: Image.asset(
              'assets/img_gojek_logo.png',
              height: 100.0,
              width: 200.0,
            ),
          ),
        ),*/
        routes: <String, WidgetBuilder>{
          '/task': (BuildContext context) => TaskPage(title: 'Task'),
          '/landingpage_view': (BuildContext context) => LandingPage(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/register_hp': (BuildContext context) => RegisterHp(),
          '/lupa_pass_pin': (BuildContext context) => LupaPassPin(),
          '/lupa_pass': (BuildContext context) => LupaPassPage(),
        });
  }
}
