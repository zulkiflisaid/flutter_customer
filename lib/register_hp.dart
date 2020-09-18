import 'dart:convert';

import 'package:flutter/material.dart';

import 'api/api.dart';
import 'register.dart';

class RegisterHp extends StatefulWidget {
  RegisterHp({Key key}) : super(key: key);

  @override
  _RegisterHpState createState() => _RegisterHpState();
}

class _RegisterHpState extends State<RegisterHp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController hpInputController = TextEditingController();
  TextEditingController inputController_1 = TextEditingController();
  TextEditingController inputController_2 = TextEditingController();
  TextEditingController inputController_3 = TextEditingController();
  TextEditingController inputController_4 = TextEditingController();
  TextEditingController inputController_5 = TextEditingController();
  TextEditingController inputController_6 = TextEditingController();
  bool visibleInputan_6 = false;
  bool kirimNomor = false;
  int pin = 777777;
  String cekPin = '';
  Map<String, dynamic> dataP;

  FocusNode secondNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    inputController_2.dispose();

    super.dispose();
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

  Future<void> pinValidator() async {
    setState(() {
      cekPin = inputController_1.text +
          inputController_2.text +
          inputController_3.text +
          inputController_4.text +
          inputController_5.text +
          inputController_6.text;
    });
    if (pin.toString() == cekPin) {
      await Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) {
        return RegisterPage(hp: hpInputController.text, pin: pin.toString());
      }));
    } else {
      final snackBar1 = SnackBar(
        content: Text('Kode Verifikasi tidak valid'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Buat Akun'),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
                  Visibility(
                    visible: visibleInputan_6 ? false : true,
                    child: Row(
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
                  ),
                  Visibility(
                    visible: visibleInputan_6,
                    child: Center(
                      child: Text("Masukkan kode verifikasi."),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _buildVerfikasi(),
                  RaisedButton(
                    child: Text(
                      _isLoading ? 'SEDANG PROSES...' : 'LANJUTKAN',
                    ),
                    //onPressed: _isLoading ? null : _cekNomor,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (!_isLoading) {
                        if (visibleInputan_6) {
                          pinValidator();
                        } else if (_registerFormKey.currentState.validate()) {
                          _cekKirimSms();
                        }
                      } else {
                        final snackBar1 = SnackBar(
                          content: Text('Sedang proses'),
                          action: SnackBarAction(
                            label: 'Close',
                            onPressed: () {},
                          ),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackBar1);
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

  Widget _buildVerfikasi() {
    return Visibility(
      visible: visibleInputan_6,
      child: Center(
        child: Container(
            padding: const EdgeInsets.all(8.0),
            width: 270,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: inputController_1,
                    onChanged: (value) {
                      if (value != '') FocusScope.of(context).nextFocus();
                      pinValidator();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '-',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 0.0),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    focusNode: secondNode,
                    controller: inputController_2,
                    onChanged: (value) {
                      if (value == '') {
                        FocusScope.of(context).previousFocus();
                      } else {
                        FocusScope.of(context).nextFocus();
                      }
                      pinValidator();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '-',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 1.0),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: inputController_3,
                    onChanged: (value) {
                      if (value == '') {
                        FocusScope.of(context).previousFocus();
                      } else {
                        FocusScope.of(context).nextFocus();
                      }
                      pinValidator();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '-',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 1.0),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: inputController_4,
                    onChanged: (value) {
                      if (value == '') {
                        FocusScope.of(context).previousFocus();
                      } else {
                        FocusScope.of(context).nextFocus();
                      }
                      pinValidator();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '-',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 1.0),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: inputController_5,
                    onChanged: (value) {
                      if (value == '') {
                        FocusScope.of(context).previousFocus();
                      } else {
                        FocusScope.of(context).nextFocus();
                      }
                      pinValidator();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '-',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 1.0),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: inputController_6,
                    onChanged: (value) {
                      if (value == '') {
                        FocusScope.of(context).previousFocus();
                      } else {
                        // FocusScope.of(context).nextFocus();
                      }
                      pinValidator();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '-',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 1.0),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _cekKirimSms() async {
    // var rnd = Random();
    //var min = 100000, max = 999999;
    //var num = min + rnd.nextInt(max - min);
    // print('$num ');
    setState(() {
      _isLoading = true;
    });
    var data = {
      'phone_number': int.parse(hpInputController.text),
      'phone_id': '+62',
      'typeuser': 'customer'
    };
    var res = await CallApi().postData(data, 'validasiregister');
    print(res.body);
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      setState(() {
        pin = int.parse(body['pin']);
        _isLoading = false;
        visibleInputan_6 = true;
      });
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Informasi'),
              content: Text('Buka Inbox SMS untuk melihat kode verifikasi '),
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
      // var body = json.decode(res.body);
      //var phone_number= phoneController.text.replaceAll('+62', '') ;

      // Navigator.push(   context,    MaterialPageRoute(builder: (context) => LandingPage()));
    } else {
      final snackBar = SnackBar(
        content: Text('Silahkan Verifikasi ulang'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            //Some code to undo the change!
          },
        ),
      );
      // Scaffold.of(context).showSnackBar(snackBar);
      _scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() {
        _isLoading = false;
      }); // edited line
    }
  }
}
