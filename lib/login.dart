import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'api/api.dart';
import 'landingpage/landingpage_view.dart';

enum authProblems { userNotFound, passwordNotValid, networkError }

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.from}) : super(key: key);
  final String from;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  // TextEditingController emailInputController = TextEditingController();
  TextEditingController hpInputController = TextEditingController();
  TextEditingController pwdInputController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic> dataP;

  @override
  void initState() {
    _getAfterLogin();
    super.initState();
  }

  void _getAfterLogin() async {
    var localStorage = await SharedPreferences.getInstance();
    // emailInputController.text = localStorage.getString('email');
    hpInputController.text = localStorage.getString('hp');
    pwdInputController.text = localStorage.getString('pass');
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

  String hpValidator(String value) {
    Pattern pattern = r'^[0-9]+$';
    var regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Nomor HP berupa angka.';
    } else if (value.length < 10) {
      return 'Panjang minimal 10 dan maksimal 12.';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
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
                    height: 24,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          enabled: false,
                          enableInteractiveSelection: false,
                          maxLength: 12,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            filled: false,
                            prefixIcon: Icon(Icons.phone),
                            labelText: '+62',

                            ///hintText: "Country code",
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: TextFormField(
                          enableInteractiveSelection: false,
                          maxLength: 12,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            filled: false,
                            labelText: 'Nomor hp',
                            hintText: 'example: 85394222196',
                            // prefixIcon:   Icon(Icons.mobile_screen_share),
                          ),
                          controller: hpInputController,
                          keyboardType: TextInputType.number,
                          validator: hpValidator,
                          //  onSaved: (String value) {},
                        ),
                        flex: 5,
                      ),
                    ],
                  ),
                  /*  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email*', hintText: 'john.doe@gmail.com'),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),*/
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Kata Sandi*', hintText: '********'),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    child: Text(
                      _isLoading ? 'SEDANG MASUK...' : 'MASUK',
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: _isLoading ? null : _login,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      child: Text(
                        'Lupa Kata Sandi ?',
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/lupa_pass_pin');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun?',
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
                          'Daftar',
                          style: TextStyle(
                            fontFamily: 'NeoSans',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/register_hp');
                        },
                      )
                    ],
                  )
                ],
              ),
            ))));
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var logInvalid = false;
    var messageError = 'Username  dan Password salah';
    if (_loginFormKey.currentState.validate()) {
      var localStorage = await SharedPreferences.getInstance();
      // await localStorage.setString('email', emailInputController.text);
      await localStorage.setString('hp', hpInputController.text);
      await localStorage.setString('pass', pwdInputController.text);

      var data = {
        // 'email': emailInputController.text,
        "usertype": "customer",
        'phone_id': "+62",
        'phone_number': int.parse(hpInputController.text),
        'password': pwdInputController.text,
        'gcm': "ff"
      };

      var res = await CallApi().postData(data, 'login');
      if (res.statusCode == 200) {
        var body = json.decode(res.body);

        dataP = {
          'uid': body['id'],
          'name': body['firstname'],
          'email': body['email'],
          'hp': body['phone_number'],
          'hp_id': body['phone_id'],
          'point': body['point'],
          'avatar': body['avatar'],
          'aktivasi': "aktivasi",
          'balance': body['balance'],
          'counter_reputation': body['counter_reputation'],
          'divide_reputation': body['divide_reputation'],
          'token': body['token'],
          'gcm': localStorage.getString('gcm').toString(),
        };

        await localStorage.setInt('uid', body['id']);
        await localStorage.setString('token', body['token']);
        await localStorage.setString('is_login', '1');
        logInvalid = true;
        print("gcm login ${localStorage.getString('gcm').toString()}");
        if (widget.from == "" || widget.from == null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingPage(dataP: dataP)));
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          // Navigator.pop(context);
        }
      } else if (res.statusCode == 400) {
        var body = json.decode(res.body);
        messageError = body['error'];
      }
    }
    if (!logInvalid) {
      final snackBar = SnackBar(
        content: Text(messageError),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            //Some code to undo the change!
          },
        ),
      );
      // Scaffold.of(context).showSnackBar(snackBar);
      _scaffoldKey.currentState.showSnackBar(snackBar); // edited line
    }
    /*if (_loginFormKey.currentState.validate()) {
      var localStorage = await SharedPreferences.getInstance();
      await localStorage.setString('email', emailInputController.text);
      await localStorage.setString('pass', pwdInputController.text);

      try {
        var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailInputController.text,
            password: pwdInputController.text);

        //var rnd =   Random();
        // var min = 100000, max = 999999;
        // var num = min + rnd.nextInt(max - min);
        // print('$num is in the range of $min and $max');
        // if( user.user.isEmailVerified){
        await Firestore.instance
            .collection('flutter_customer')
            .document(user.user.uid)
            .get()
            .then((DocumentSnapshot result) {
          var bintang = 0;
          if (result['counter_reputation'] != 0 &&
              result['divide_reputation'] != 0) {
            bintang =
                result['counter_reputation'] ~/ result['divide_reputation'];
          } else {
            bintang = 0;
          }

          dataP = {
            'uid': result['uid'],
            'name': result['name'],
            'email': result['email'],
            'hp': result['hp'],
            'aktivasi': result['aktivasi'],
            'point': result['point'],
            'avatar': result['avatar'],
            'bintang': bintang,
          };
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingPage(dataP: dataP)));
        }).catchError((err) => print(err));
        // }else{
        //    await FirebaseAuth.instance.signOut().then((result) {     });
        //     print('silahkan verifkasi email');
        // }

      } catch (e) {
        authProblems errorType;
        if (Platform.isAndroid) {
          switch (e.message) {
            case 'There is no user record corresponding to this identifier. The user may have been deleted.':
              errorType = authProblems.userNotFound;
              break;
            case 'The password is invalid or the user does not have a password.':
              errorType = authProblems.passwordNotValid;
              break;
            case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
              errorType = authProblems.networkError;
              break;
            // ...
            default:
              print('Case ${e.message} is not yet implemented');
          }
        } else if (Platform.isIOS) {
          switch (e.code) {
            case 'Error 17011':
              errorType = authProblems.userNotFound;
              break;
            case 'Error 17009':
              errorType = authProblems.passwordNotValid;
              break;
            case 'Error 17020':
              errorType = authProblems.networkError;
              break;
            // ...
            default:
              print('Case ${e.message} is not yet implemented');
          }
        }
        print('The error is $errorType');
        final snackBar = SnackBar(
          content: Text('Username tidak ditemukan'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar); // edited line
      }
    }*/

    setState(() {
      _isLoading = false;
    });
  }
}
