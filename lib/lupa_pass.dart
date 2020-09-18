import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:pelanggan/login.dart';

import 'api/api.dart';

enum authProblems { ERROR_EMAIL_ALREADY_IN_USE, PasswordNotValid, NetworkError }

class LupaPassPage extends StatefulWidget {
  LupaPassPage({Key key, this.hp}) : super(key: key);
  final String hp;
  @override
  _LupaPassPageState createState() => _LupaPassPageState();
}

class _LupaPassPageState extends State<LupaPassPage> {
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController pinInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  Map<String, dynamic> dataP;

  @override
  void initState() {
    pwdInputController = TextEditingController();
    pinInputController = TextEditingController();
    confirmPwdInputController = TextEditingController();
    super.initState();
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password panjang 8 karakter';
    } else {
      return null;
    }
  }

  String pinValidator(String value) {
    Pattern pattern = r'^[0-9]+$';
    var regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Kode verifikasi berupa angka.';
    } else if (value.length != 6) {
      return 'Panjang kode verifikasi 6.';
    } //else if (pinInputController.text != widget.pin) {
    //return 'Kode verifikasi tidak sesuai.';
    //}
    else {
      return null;
    }
  }

  String sameValidator(String value) {
    if (value != pwdInputController.text) {
      return 'Ulangi password tidak sama.';
    } else if (value.length < 8) {
      return 'Password panjang 8 karakter';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Reset Kata Sandi'),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'assets/img_gojek_logo.png',
                      height: 80.0,
                      width: 80.0,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Kode Verifikasi*',
                        hintText: 'Kode Verifikasi'),
                    controller: pinInputController,
                    obscureText: true,
                    validator: pinValidator,
                  ),
                  TextFormField(
                    maxLength: 20,
                    decoration: InputDecoration(
                        labelText: 'Kata Sandi*', hintText: '********'),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  TextFormField(
                    maxLength: 20,
                    decoration: InputDecoration(
                        labelText: 'Ulangi Kata Sandi*', hintText: '********'),
                    controller: confirmPwdInputController,
                    obscureText: true,
                    validator: sameValidator,
                  ),
                  RaisedButton(
                    child: Text(
                      _isLoading ? 'Mengirim data...' : 'GANTI KATA SANDI',
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_registerFormKey.currentState.validate()) {
                        if (pwdInputController.text ==
                            confirmPwdInputController.text) {
                          buatAkunBaru();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content:
                                      Text('Input ulang Password tidak sama.'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun?',
                        style: TextStyle(
                          fontFamily: 'NeoSans',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: Text(
                          'Masuk di sisni!',
                          style: TextStyle(
                            fontFamily: 'NeoSans',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ))));
  }

  void buatAkunBaru() async {
    setState(() {
      _isLoading = true;
    });

    var logInvalid = false;
    var messageError = 'Register gagal.';

    var data = {
      "typeuser": "customer",
      'password': pwdInputController.text,
      "phone_number": int.parse(widget.hp),
      "phone_id": "+62",
      "pin": int.parse(pinInputController.text),
      "gcm": ""
    };

    var res = await CallApi().postData(data, 'resetpassword');
    print(res.body);
    if (res.statusCode == 200) {
      pwdInputController.clear();
      confirmPwdInputController.clear();
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sukses Mengubah Kata Sandi'),
              content: Text('Silakan masuk menggunakan kata sandi baru.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (_) => false);
                  },
                )
              ],
            );
          });

      logInvalid = true;
    } else if (res.statusCode == 400 || (res.statusCode == 422)) {
      var body = json.decode(res.body);
      messageError = body['error'];
    }

    if (!logInvalid) {
      setState(() {
        _isLoading = false;
      });
      final snackBar = SnackBar(
        content: Text(messageError),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }
}
