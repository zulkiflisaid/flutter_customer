import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:pelanggan/login.dart';

import 'api/api.dart';

enum authProblems { ERROR_EMAIL_ALREADY_IN_USE, PasswordNotValid, NetworkError }

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.hp, this.pin}) : super(key: key);
  final String hp, pin;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  //TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController hpInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  Map<String, dynamic> dataP;

  @override
  void initState() {
    firstNameInputController = TextEditingController();
    //  lastNameInputController = TextEditingController();
    emailInputController = TextEditingController();
    hpInputController = TextEditingController();
    pwdInputController = TextEditingController();
    confirmPwdInputController = TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password panjang 8 karakter';
    } else {
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

  String nmValidator(String value) {
    Pattern pattern = r'^[a-zA-Z ]+$';
    var regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Nama berupa karakter huruf.';
    } else if (value.length < 1) {
      return 'Nama harus panjang 1 karakter.';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Buat akun'),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'assets/img_gojek_logo.png',
                      height: 80.0,
                      width: 80.0,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    maxLength: 30,
                    decoration: InputDecoration(
                        labelText: 'Nama Lengkap*', hintText: 'John'),
                    controller: firstNameInputController,
                    validator: nmValidator,
                  ),
                  /* TextFormField(
                      maxLength: 20,
                      decoration: InputDecoration(
                          labelText: 'Nama belakang*', hintText: 'Doe'),
                      controller: lastNameInputController,
                      validator: (value) {
                        if (value.length < 3) {
                          return 'Masukkan nama yang valid.';
                        }
                        return value;
                      }),*/
                  TextFormField(
                    maxLength: 40,
                    decoration: InputDecoration(
                        labelText: 'Email*', hintText: 'john.doe@gmail.com'),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    maxLength: 20,
                    decoration: InputDecoration(
                        labelText: 'Password*', hintText: '********'),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  TextFormField(
                    maxLength: 20,
                    decoration: InputDecoration(
                        labelText: 'Ulangi Password*', hintText: '********'),
                    controller: confirmPwdInputController,
                    obscureText: true,
                    validator: sameValidator,
                  ),
                  RaisedButton(
                    child: Text(
                      _isLoading ? 'Mengirim data...' : 'Daftar',
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
      "usertype": "customer",
      'name': firstNameInputController.text,
      'email': emailInputController.text,
      'password': pwdInputController.text,
      "phone_number": int.parse(widget.hp),
      "phone_id": "+62",
      "pin_register": int.parse(widget.pin),
      "gcm": "-"
    };

    var res = await CallApi().postData(data, 'register');
    print(res.body);
    if (res.statusCode == 200) {
      firstNameInputController.clear();
      // lastNameInputController.clear();
      emailInputController.clear();
      hpInputController.clear();
      pwdInputController.clear();
      confirmPwdInputController.clear();
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sukses'),
              content: Text('Akun berhasil dibuat, silahkan masuk.'),
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
    } else if (res.statusCode == 400) {
      var body = json.decode(res.body);
      messageError = body['error'];
    }

    if (!logInvalid) {
      final snackBar = SnackBar(
        content: Text(messageError),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    /*
    try {
      var currentUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailInputController.text,
              password: pwdInputController.text);

      await Firestore.instance
          .collection('flutter_customer')
          .document(currentUser.user.uid)
          .setData({
        'uid': currentUser.user.uid,
        'name':
            firstNameInputController.text + ' ' + lastNameInputController.text,
        'email': emailInputController.text,
        'hp': '+62' + widget.hp,
        'saldo': 0,
        'aktivasi': '0',
        'point': 0,
        'create_at': FieldValue.serverTimestamp(),
        'counter_reputation': 0,
        'divide_reputation': 0,
        'avatar': '',
        'trip': 0,
        'radius': 60,
        'status': '',
        'blok': false,
      }).then((result) {
        setState(() {
          _isLoading = false;
        });

        firstNameInputController.clear();
        lastNameInputController.clear();
        emailInputController.clear();
        hpInputController.clear();
        pwdInputController.clear();
        confirmPwdInputController.clear();

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => LoginPage()), (_) => false);
      }).catchError((err) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'The email address is already in use by another account.':
            break;
          case 'The password is invalid or the user does not have a password.':
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            break;
          default:
          // print('Case ${e.message} is not yet implemented');
        }
      } else if (Platform.isIOS) {
        switch (e.code) {
          case 'Error 17011':
            break;
          case 'Error 17009':
            break;
          case 'Error 17020':
            break;
          // ...
          default:
          // print('Case ${e.message} is not yet implemented');
        }
      }
      //print('The error is $errorType');
      final snackBar1 = SnackBar(
        content: Text('Email telah terdaftar'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            //Some code to undo the change!
          },
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar1);
    }*/
  }
}
