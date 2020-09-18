import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pelanggan/api/api.dart';
import 'package:pelanggan/beranda/file_beranda/upload_bukti.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:pelanggan/model/class_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'topup_history.dart';

class TopUpSaldo extends StatefulWidget {
  TopUpSaldo({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  _TopUpSaldoState createState() => _TopUpSaldoState();
}

class _TopUpSaldoState extends State<TopUpSaldo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var uang = NumberFormat.currency(locale: 'ID', symbol: '', decimalDigits: 0);
  final dbRef = Firestore.instance;
  TextEditingController jumlahInputController = TextEditingController();
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _currentIDBank;
  //SimpleDateFormat sfd =   SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
  // sfd.format(new Date(timestamp));
  var localStorage = SharedPreferences.getInstance();
  static String token = "";
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getDropDownMenuItems();
    // _currentBank = _dropDownMenuItems[0].value;
  }

  Future getDropDownMenuItems() async {
    var items = <DropdownMenuItem<String>>[];

    var response = await CallApi().getData('getallbank?page=1&limit=10');
    print(response.body);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      Iterable list = body['data'];
      // Iterable list = json.decode(response.body);
      var listData = list.map((season) => Bank.fromJson(season)).toList();
      listData.forEach((element) {
        items.add(DropdownMenuItem(
            value: element.id.toString(), child: Text(element.nm_long)));
      });
      if (items.length != 0) _currentIDBank = items[0].value;
      setState(() {
        _dropDownMenuItems = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text(
          'Top Up',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TopUpHistory(
                          dataP: widget.dataP,
                        )),
              );
            },
          ),
        ],
      ),
      body: Container(
          child: FutureBuilder<List<TopUp>>(
        future: fetchTopUps(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data != null) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                if (snapshot.data.isEmpty) {
                  return Center(
                      child: Container(
                          margin: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/topup/topup.png',
                                  // height: 172.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Image.asset( 'assets/images/promo_3.jpg',   ),
                              Text('Data Top Up akan tampil di sini.'),
                              Text(
                                  'Silahkan tekan tombol kanan bawah untuk Top up.'),
                            ],
                          )));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          margin: const EdgeInsets.all(
                            10.0,
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  //////////tanggal//////////////
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Tanggal',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          //snapshot.data[index]  .created_at
                                          Text(
                                            DateFormat('dd-mm-yyyy hh:mm')
                                                .format(DateFormat(
                                                        'yyyy-mm-dd hh:mm')
                                                    .parse(snapshot.data[index]
                                                        .created_at))
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          /*Text(
                                            'tglTopup',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),*/
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: snapshot.data[index]
                                                            .is_verification ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.blue,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                            ),
                                            child: Text(
                                              snapshot.data[index]
                                                          .is_verification ==
                                                      1
                                                  ? 'Terverifikasi'
                                                  : 'Belum Verifikasi',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    height: 16,
                                  ),
                                  /////////bank///////////////
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.all(
                                                0.0,
                                              ),
                                              child: Container(
                                                // padding: const EdgeInsets.all(  10.0, ),
                                                margin: const EdgeInsets.all(
                                                  6.0,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/bank/${snapshot.data[index].url_logo}',
                                                  height: 50.0,
                                                  // width: 50.0,
                                                  //width: double.infinity,
                                                  //fit: BoxFit.cover,
                                                ),
                                              ))),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(
                                          3.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${snapshot.data[index].nm_long}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              '${snapshot.data[index].owner}',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '${snapshot.data[index].no_rek}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                  InkWell(
                                                    child: Icon(
                                                      Icons.content_copy,
                                                      size: 16,
                                                      color: Colors.green,
                                                    ),
                                                    onTap: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: snapshot
                                                                  .data[index]
                                                                  .no_rek));
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Nomor rekening telah dicopy'),
                                                      ));
                                                    },
                                                    onLongPress: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: snapshot
                                                                  .data[index]
                                                                  .no_rek));
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Nomor rekening telah dicopy'),
                                                      ));
                                                    },
                                                  )
                                                ]),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    height: 16,
                                  ),
                                  ///////// kode transfer dan nominal///////////////
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Kode Top Up',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '${snapshot.data[index].code_transfer} ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.blue),
                                                ),
                                                InkWell(
                                                  child: Icon(
                                                    Icons.content_copy,
                                                    size: 16,
                                                    color: Colors.green,
                                                  ),
                                                  onTap: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: snapshot
                                                                .data[index]
                                                                .code_transfer));
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Kode Top Up telah dicopy'),
                                                    ));
                                                  },
                                                  onLongPress: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: snapshot
                                                                .data[index]
                                                                .code_transfer));
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Kode Top Up telah dicopy'),
                                                    ));
                                                  },
                                                )
                                              ])
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Nominal',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            'Rp ${uang.format(snapshot.data[index].amount)}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    height: 10,
                                  ),
                                  //bukti transaksi
                                  //Image.file(_image)  ,

                                  ////select image///////////////////
                                  FlatButton(
                                      color: Colors.green[400],
                                      child: Text(
                                        'KONFIRMASI TUP UP',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UploadBukti(
                                                    dataP: widget.dataP,
                                                    jumlah: snapshot
                                                        .data[index].amount,
                                                    kdTransfer: snapshot
                                                        .data[index]
                                                        .code_transfer,
                                                    bank_id: snapshot
                                                        .data[index].bank_id,
                                                    nm_long: snapshot
                                                        .data[index].nm_long,
                                                    pemilik: snapshot
                                                        .data[index].owner,
                                                    noRek: snapshot
                                                        .data[index].no_rek,
                                                    logo: snapshot
                                                        .data[index].url_logo,
                                                    tgl: DateFormat(
                                                            'dd-mm-yyyy hh:mm')
                                                        .format(DateFormat(
                                                                'yyyy-mm-dd hh:mm')
                                                            .parse(snapshot
                                                                .data[index]
                                                                .created_at))
                                                        .toString(),
                                                    verifikasi: snapshot
                                                        .data[index]
                                                        .is_verification,
                                                    id: snapshot.data[index].id,
                                                    user_id: snapshot
                                                        .data[index].user_id,
                                                  )),
                                        );
                                      }),
                                  Divider(
                                    color: Colors.grey,
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'INFO:',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red),
                                      ),
                                      Expanded(
                                          child: Text(
                                        'Masukkan Kode Top Up pada berita, untuk lebih mempermudah proses Top Up ',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      )),
                                    ],
                                  ),
                                ],
                              )));
                    },
                  );
                }
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )),
      /*floatingActionButton:  Container(
            width: 48.0,
            height: 48.0,
            child:   RawMaterialButton(
              shape:   CircleBorder(),
              elevation: 0.0,
              child: Icon(
                Icons.add_circle, size: 48,
                color: Colors.blue,
              ),
            onPressed: (){
               jumlahInputController.clear(); 
               _showDialog();  
            },
        )
      ),  */
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Tambah Data',
        onPressed: () {
          jumlahInputController.clear();
          _showDialog();
        },
      ),
    );
  }

  Future<void> _tambahData(int jml, String idBank) async {
    //kd_transfer 8 digit
    //var rnd = Random();
    //var min = 10000000, max = 99999999;
    //var kdTransfer = min + rnd.nextInt(max - min);

    var data = {
      'user_category': 'customers',
      'user_id': widget.dataP['uid'],
      'bank_id': int.parse(idBank),
      'amount': jml,
      //  'code_transfer': kdTransfer
    };
    String psn = 'Gagal menyimpan Top Up. Silahkan ulangi';
    var res = await CallApi().postData(data, 'addtopup');
    // print(widget.dataP['uid'].toString());
    print(res.body);
    if (res.statusCode == 200) {
      //var body = json.decode(res.body);
      // psn = body['token'];
      psn = 'Sukses melakukan TOPUP. Silahkan upload bukti pembayaran.';
    } else if (res.statusCode == 400 || res.statusCode == 422) {
      var body = json.decode(res.body);
      psn = body['error'];
    } else {
      psn = 'Gagal menyimpan TopUp. Silahkan ulangi';
    }
    _responTopups(psn);
  }

  void _showDialog() async {
    await showDialog<String>(
      context: context,
      // builder: ,
      child: _SystemPadding(
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Silahkan pilih BANK: '),
                  Container(
                    padding: EdgeInsets.all(16.0),
                  ),
                  /* DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                          child: DropdownButton(isExpanded: true,
                           value: _currentCity,
                            items: _dropDownMenuItems,
                            onChanged: changedDropDownItem,
                            style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    ),*/
                  DropdownButton(
                    isExpanded: true,
                    value: _currentIDBank,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  ),
                  Expanded(
                    child: TextField(
                      controller: jumlahInputController,
                      autofocus: true, maxLength: 7,
                      // keyboardType: TextInputType.numberWithOptions( ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(7),
                      ],
                      onChanged: (String newVal) {
                        var jml = int.parse(newVal);
                        if (jml > 1000000) {
                          jumlahInputController.text = '1000000';
                          // jumlahInputController.clear();
                        }
                      },

                      decoration: InputDecoration(
                          counterText: '',
                          labelText: 'Jumlah Top Up',
                          hintText: 'maksimal 1 juta'),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  Text('NB: Maksimal 1 juta dan minimal 20.000 Rupiah'),
                ],
              )),
            ],
          ),
          /* Row(
          children: <Widget>[
              Expanded(
              child:   TextField(
                autofocus: true,
                decoration:   InputDecoration(
                    labelText: 'Full Name', hintText: 'eg. John Smith'),
              ),
            )
          ],
        ),*/
          actions: <Widget>[
            FlatButton(
                child: const Text('Batal'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            FlatButton(
                child: const Text('Simpan'),
                onPressed: () {
                  if (jumlahInputController.text == '' ||
                      jumlahInputController.text == '0') {
                  } else {
                    var jml = int.parse(jumlahInputController.text);
                    if (jml >= 20000 && jml <= 1000000) {
                      _tambahData(jml, _currentIDBank);
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      final snackBar1 = SnackBar(
                        content: Text(
                            'Gagal menyimpan Top Up. Maksimal 1 juta dan minimal 20.000 Rupiah'),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {
                            //Some code to undo the change!
                          },
                        ),
                      );
                      _scaffoldKey.currentState.showSnackBar(snackBar1);
                    }
                  }
                })
          ],
        ),
      ),
    );
  }

  void changedDropDownItem(String selectedCity) {
    print(selectedCity);
    setState(() {
      _currentIDBank = selectedCity;
    });
  }

  void _responTopups(String psn) async {
    final snackBar1 = SnackBar(
      content: Text(psn),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          //Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar1);
  }

  Future<List<TopUp>> fetchTopUps() async {
    var response = await CallApi().getData(
        'getalltopup?page=1&limit=10&verification=0&verification=0&struck=no');
    //print(widget.dataP["token"] + "00000000000");
    if (response.statusCode == 200) {
      // print(response.body);
      var body = json.decode(response.body);
      // print(response.body);
      Iterable list = body['data'];
      var promosi = list.map((season) => TopUp.fromJson(season)).toList();
      // print(promosi);
      return promosi;
    }
    return null;
  }
}

class _SystemPadding extends StatelessWidget {
  _SystemPadding({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    print(mediaQuery.size.height);
    return AnimatedContainer(
        // padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
