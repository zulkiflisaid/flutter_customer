import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'landingpage/landingpage_view.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Map<String, dynamic> dataP;
  @override
  void initState() {
    cekLogin();
    super.initState();
  }

  void cekLogin() async {
    var localStorage = await SharedPreferences.getInstance();
    dataP = {
      'uid': localStorage.getInt('uid'),
      'name': localStorage.getString('name').toString(),
      'email': localStorage.getString('email').toString(),
      'hp': localStorage.getString('hp').toString(),
      'hp_id': localStorage.getString('hp_id').toString(),
      'point': localStorage.getString('point').toString(),
      'avatar': localStorage.getString('avatar').toString(),
      'aktivasi': "aktivasi",
      'balance': localStorage.getString('balance').toString(),
      'counter_reputation':
          localStorage.getString('counter_reputation').toString(),
      'divide_reputation':
          localStorage.getString('divide_reputation').toString(),
      'token': localStorage.getString('token').toString(),
      'gcm': localStorage.getString('gcm').toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 500)).asStream().listen((_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LandingPage(
                    dataP: dataP,
                  )));
      //Navigator.pushNamed(context, '/landingpage_view');
    });
    return Scaffold(
      body: Center(
        // child: Container(
        //   child: Text("Loading..."),
        // ),
        child: Image.asset(
          'assets/img_gojek_logo.png',
          height: 100.0,
          width: 200.0,
        ),
      ),
    );
  }
}
