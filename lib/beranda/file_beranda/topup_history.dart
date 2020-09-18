import 'dart:convert';

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pelanggan/api/api.dart';
import 'package:pelanggan/constans.dart';
import 'package:pelanggan/model/class_model.dart';

class TopUpHistory extends StatefulWidget {
  TopUpHistory({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  _TopUpHistoryState createState() => _TopUpHistoryState();
}

class _TopUpHistoryState extends State<TopUpHistory> {
  var uang = NumberFormat.currency(locale: 'ID', symbol: '', decimalDigits: 0);
  final dbRef = Firestore.instance;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  dynamic data;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                title: Text(
                  'Transaksi Top Up',
                  style: TextStyle(color: Colors.black),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                bottom: TabBar(
                    // labelStyle:  TextStyle( color: Colors.black),

                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.green,
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ), //For Selected tab
                    unselectedLabelStyle: TextStyle(
                      color: Colors.black,
                    ), //F
                    tabs: <Widget>[
                      Tab(
                        text: 'Dalam Proses',
                      ),
                      Tab(
                        text: 'Berhasil Top Up',
                      )
                    ]),
              ),
              body: TabBarView(children: <Widget>[
                _listDalamProses(0, "yes"),
                _listDalamProses(1, "yes"),
              ]),
            )));
  }

  Widget _listDalamProses(int verifikasi, String struck) {
    return Container(
        child: FutureBuilder<List<TopUp>>(
      future: fetchTopUps(verifikasi, struck),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Internet error');
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
                      // var date = new DateTime.fromMillisecondsSinceEpoch(document['tgl'] * (1000));
                      // var tgl_topup =  DateFormat('yyyy-MM-dd kk:mm').format(date);
                      ///var rnd = Random();
                      //&h=${rnd.nextInt(100000)}

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
                                                        1
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
                                            Text(
                                              '${snapshot.data[index].no_rek} ',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
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
                                          Text(
                                            '${snapshot.data[index].code_transfer} ',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.blue),
                                          ),
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
                                  Image.network(
                                    // "http://192.168.1.44:8080/img/bank/logo.jpg",
                                    //   "http://192.168.1.44/belajar_api_php/tes.php?tytyt",
                                    '${GojekGlobal.domainUrl}imgtopup?kd=${snapshot.data[index].code_transfer}&id=${snapshot.data[index].id}',
                                    headers: {
                                      "Content-type": "application/json",
                                      "Accept": "application/json",
                                      "Authorization":
                                          "${widget.dataP["token"]}",
                                    },

                                    /// color: Colors.cyan,
                                  ),
                                ],
                              )));
                    });
              }
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }

  Future<List<TopUp>> fetchTopUps(int verifikasi, String struck) async {
    var response = await CallApi().getData(
        'getalltopup?page=1&limit=10&verification=$verifikasi&struck=$struck');
    print(widget.dataP["token"] + "00000000000");
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      //   print(body['data']);
      Iterable list = body['data'];
      var promosi = list.map((season) => TopUp.fromJson(season)).toList();
      // print(promosi);
      return promosi;
    }
    return null;
  }
}
