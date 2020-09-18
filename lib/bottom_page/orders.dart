import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pelanggan/layanan_page/chat.dart';
import 'package:intl/intl.dart';

import 'file_order/detail_order.dart';

class Orders extends StatefulWidget {
  // Orders() : super();
  //Orders({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor
  // final String title;
  //final String uid; //include this

  Orders({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var uang = NumberFormat.currency(locale: 'ID', symbol: '', decimalDigits: 0);
  final DateTime _now = DateTime.now();
  var mundurSatuhari;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    mundurSatuhari = DateTime(_now.year, _now.month, _now.day - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text(
          'Pesanan',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history, color: Colors.black),
            onPressed: () {
              print(widget.dataP['uid']);
            },
          ),
        ],
      ),
      body: Container(
          // padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('flutter_order')
            .where('pelanggan_uid', isEqualTo: widget.dataP['uid'])
            //  .where('created', isGreaterThan: mundur_satuhari)
            //.document(widget.data_p['uid'])
            //.collection('order')
            .orderBy('created')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
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
                            'assets/images/no_inbox.png',
                            // height: 172.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text('Data pesan masuk akan muncul disini.'),
                      ],
                    )));
          } else if (snapshot.data != null) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();

              default:
                return ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    var tglCreated = '';
                    var d = document['created'] == null
                        ? null
                        : document['created'].toDate();
                    if (d != null) {
                      tglCreated = DateFormat('yyyy-MM-dd kk:mm').format(d);
                    }

                    var tombolChat = false;
                    if (document['status_order'] != 'selesai' &&
                        document['status_order'] != 'batal' &&
                        document['driver_id'] != '') {
                      tombolChat = true;
                    }
                    return InkWell(
                        child: Card(
                          margin: const EdgeInsets.all(
                            10.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //////////tanggal//////////////
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Tanggal',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        //Text(DateFormat('y:M:d H:m:s') .format(  document['tgl'].toDate() )  .toString(),style: TextStyle(fontSize: 14),),
                                        Text(
                                          tglCreated,
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
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
                                              color: document['status_order'] ==
                                                      'selesai'
                                                  ? Colors.blue
                                                  : document['status_order'] ==
                                                          'batal'
                                                      ? Colors.red
                                                      : Colors.green,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          child: Text(
                                            document['status_order'] ==
                                                    'selesai'
                                                ? 'selesai'
                                                : document['status_order'] ==
                                                        'batal'
                                                    ? 'dibatalkan'
                                                    : 'dalam proses',
                                            style:
                                                TextStyle(color: Colors.black),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      document['category_order'] == 'ojek'
                                          ? 'OJEK'
                                          : document['category_order'] == 'car4'
                                              ? 'MOBIL 4'
                                              : document['category_order'] ==
                                                      'car5'
                                                  ? 'MOBIL 6'
                                                  : document['category_order'] ==
                                                          'food'
                                                      ? 'KULINER'
                                                      : document['category_order'] ==
                                                              'semabko'
                                                          ? 'SEMBAKO'
                                                          : 'OJEK',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '${document['tujuan_alamat']}',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontFamily: 'NeoSans',
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),

                                Divider(
                                  color: Colors.grey,
                                  height: 16,
                                ),
                                ///////// kode transfer dan nominal///////////////
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'ID',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '${document['kd_transaksi']} ',
                                                style: TextStyle(
                                                    fontSize: 16,
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
                                                          text: document[
                                                              'kd_transaksi']));
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                    content:
                                                        Text('ID telah dicopy'),
                                                  ));
                                                },
                                                onLongPress: () {
                                                  //  Clipboard.setData( ClipboardData(text: document['kd_transfer']));
                                                  // _scaffoldKey.currentState.showSnackBar(
                                                  //  SnackBar(content:  Text('Kode Top Up telah dicopy'),));
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
                                          'Total',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          'Rp ${uang.format(document['total_prices'])}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                tombolChat == false
                                    ? SizedBox()
                                    : Divider(
                                        color: Colors.grey,
                                        height: 10,
                                      ),

                                ////chat///////////////////
                                tombolChat == false
                                    ? SizedBox()
                                    : Container(
                                        height: 45,
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Chat(
                                                          dataP: widget.dataP,
                                                          peerId: document[
                                                              'driver_id'],
                                                          peerAvatar: document[
                                                              'driver_id'],
                                                        )));
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          color: Colors.white,
                                          elevation: 0,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.0, horizontal: 1.0),
                                          child: Row(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.message,
                                                  size: 24.0,
                                                  color: Colors.grey),
                                              Text(
                                                ' Chat Driver',
                                                style: TextStyle(
                                                  fontFamily: 'NeoSans',
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.normal,
                                                  letterSpacing: 0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                /*Align(
                                  alignment: Alignment.topCenter,
                                  child:   FlatButton(color: Colors.green[400],
                                    child: Text('Detail...',style: TextStyle(fontSize: 14, color: Colors.white),),
                                    onPressed: () {   
                                          Navigator.push(  context, MaterialPageRoute(
                                          builder: (context) => 
                                           DetailOrder(
                                              data_p: widget.data_p, 
                                              uid: document.documentID,
                                              created: tgl_created,  
                                              kd_transaksi: document['kd_transaksi'],
                                              total_prices: document['total_prices'], 
                                              category_order: document['category_order'], 
                                            )
                                          ),  
                                        ); 
                                    }
                                  ), 
                                ),*/
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailOrder(
                                      dataP: widget.dataP,
                                      uid: document.documentID,
                                      created: tglCreated,
                                      kdTransaksi: document['kd_transaksi'],
                                      totalPrices: document['total_prices'],
                                      categoryOrder: document['category_order'],
                                      payCategories: document['pay_categories'],
                                      statusOrder: document['status_order'],
                                      jemputAlamat: document['jemput_alamat'],
                                      tujuanAlamat: document['tujuan_alamat'],
                                      distanceText: document['distance_text'],
                                    )),
                          );
                        });
                  }).toList(),
                );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )),
    );
  }
}
