import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pelanggan/api/api.dart';
import 'package:pelanggan/layanan_page/gofood/keranjang.dart';
import 'package:pelanggan/librariku/bintang.dart';
import 'package:pelanggan/api/firestore_db.dart';

class Restoran extends StatelessWidget {
  Restoran({Key key, this.dataP, this.dataResto}) : super(key: key);
  final Map<String, dynamic> dataP;
  final Map<String, dynamic> dataResto;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RestoranPage(
        dataP: dataP,
        dataResto: dataResto,
      ),
    );
  }
}

class RestoranPage extends StatefulWidget {
  RestoranPage({Key key, this.dataP, this.dataResto}) : super(key: key);
  final Map<String, dynamic> dataP;
  final Map<String, dynamic> dataResto;
  @override
  _RestoranState createState() => _RestoranState();
}

class _RestoranState extends State<RestoranPage> {
  var uang = NumberFormat.currency(locale: 'ID', symbol: '', decimalDigits: 0);
  int awal = 0;
  var header = '';
  final databaseRef = Firestore.instance;

  bool visibilityitemPesanan = false;
  Map<String, dynamic> qityPesanan = {};
  Map<String, dynamic> idFoodPesanan = {};
  var itemPesanan = 0;
  var hargaPesanan = 0;
  var idRestoPesanan = '';
  GeoPoint geoRestoPesanan = GeoPoint(0.0, 0.0);
  GeoPoint geoNya = GeoPoint(0.0, 0.0);
  ZulLib zulLib = ZulLib();
  Stream<dynamic> snapshotRestoPesanan;
  //var menus;
  CrudMedthods crudObj = CrudMedthods();
  CallApi callApi = CallApi();

  /*
  SCROLL APPBAR 
  ScrollController _scrollController; 
  bool lastStatus = true; 
  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  } 
  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (MediaQuery.of(context).size.height/2-50 - kToolbarHeight);
  }*/
  @override
  void dispose() {
    //   _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    /*
    //  _scrollController = ScrollController();
    //  _scrollController.addListener(_scrollListener);
    //mengambil keranjang
    crudObj.getFoodPesanan(widget.dataP['uid']).then((results) {
      setState(() {
        snapshotRestoPesanan = results;
      });
    });

    //mengambil data list menu untuk resto yg dibuka bukan resto pesanan
    // crudObj.getMenu(widget.dataResto['id_resto']).then((results) { 
    //     setState(() {   
    //        menus = results;
    //    }); 
    //});  

    //mengambil data resto by id
    //dan restoran ini belum tentu data restoran yang ada di keranjang belanja
    //bisa saja berbeda dari yg sebelumnya ada di pesanan
    if (widget.dataResto['nm_resto'] == '') {
      crudObj.getRestoById(widget.dataResto['id_resto']).then((results) {
        DocumentReference aa = results;
        aa.get().then((value) {
          var bukaOrtutup = zulLib.bukaOrtutup(value.data['buka']);

          // double geoNyalatitude=geoNya.latitude;
          //  double geoNyalongitude=geoNya.longitude;
          // print(widget.dataResto['img']);
          //  print(widget.dataResto['img']);
          setState(() {
            geoNya = value.data['posisi'];

            widget.dataResto['nm_resto'] = value.data['nm_resto'];
            widget.dataResto['ket_resto'] = value.data['ket_resto'];
            widget.dataResto['kat_onkir'] = value.data['kat_onkir'];
            widget.dataResto['alamat_resto'] = value.data['alamat_resto'];
            widget.dataResto['img'] = value.data['img'];
            // widget.dataResto['jarak']  = callApi.getDistance( '$geoNyalatitude,$geoNyalongitude','${widget.dataP['lat_antar']},${widget.dataP['long_antar']}') ;
            //  widget.dataResto['jarak']  =  zulLib.calculateDistance(value.data['posisi'],LatLng(widget.dataP['lat_antar'], widget.dataP['long_antar']));
            widget.dataResto['bintang'] = zulLib.bintang(
                value.data['counter_reputation'],
                value.data['divide_reputation']);
            widget.dataResto['divide_reputation'] =
                value.data['divide_reputation'];
            widget.dataResto['min_hrg'] = value.data['min_hrg'];
            widget.dataResto['status'] = bukaOrtutup['status'];
            widget.dataResto['buka'] = bukaOrtutup['tutup'];
            widget.dataResto['tutup'] = bukaOrtutup['tutup'];
            widget.dataResto['posisi'] = widget.dataResto[
                'posisi']; //GeoPoint (geoNya.latitude,geoNya.longitude);
          });
        });
      });
    } else {}
    if (widget.dataResto['laris'] == 'yes') {
      Future.delayed(Duration(milliseconds: 700), () {
        if (widget.dataResto['laris'] == 'yes' &&
            mounted &&
            widget.dataResto['nm_resto'] != '') {
          _showSheetItem({
            'id_resto': widget.dataResto['id_resto'],
            'id_menu': widget.dataResto['id_menu'],
            'img_menu': widget.dataResto['img_menu'],
            'ket_menu': widget.dataResto['ket_menu'],
            'nm_menu': widget.dataResto['nm_menu'],
            'hrg': widget.dataResto['hrg'],
          });
        }
      });
    }
  */
    super.initState();
  }

  void _hitungHarga() {
    snapshotRestoPesanan.listen((snapshot) {
      var subTotal = 0;
      bool isibilityitem = false;
      var itemsQity = 0;
      var idnyaResto = '';
      qityPesanan.clear();
      idFoodPesanan.clear();

      snapshot.documents.forEach((element) {
        DocumentSnapshot docSnapshot = element;
        subTotal = subTotal + (element.data['hrg'] * element.data['qity']);
        itemsQity = itemsQity + element.data['qity'];
        isibilityitem = true;
        idnyaResto = element.data['id_resto'];

        // print(element.data['id_menu']);
        if (mounted) {
          setState(() {
            idFoodPesanan['${element.data['id_menu']}'] =
                docSnapshot.documentID;
            qityPesanan['${element.data['id_menu']}'] = element.data['qity'];
          });
        } else {
          idFoodPesanan['${element.data['id_menu']}'] = docSnapshot.documentID;
          qityPesanan['${element.data['id_menu']}'] = element.data['qity'];
        }
      });
      //.fold(0, (tot, doc) => tot + (doc.data['hrg']*doc.data['qity']));
      if (mounted) {
        setState(() {
          idRestoPesanan = idnyaResto;
          visibilityitemPesanan = isibilityitem;
          hargaPesanan = subTotal;
          itemPesanan = itemsQity;
        });
      }
    });
  }

  showAlertDialog(Map<String, dynamic> dataMenu) {
    if (widget.dataResto['id_resto'] != idRestoPesanan &&
        idRestoPesanan != '') {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Tidak"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = FlatButton(
        child: Text("Ya"),
        onPressed: () {
          Navigator.of(context).pop();

          //hapus pesanan lama
          //dan tambah pesanan baru
          setState(() {
            idRestoPesanan = '';
          });
          _addKeranjang(dataMenu);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Informasi"),
        content: Text(
            "Pesanan sebelumnya berbeda tempat. Untuk melanjutkan pesanan baru ini, pesanan sebelumnya di keranjang dihapus ya?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      print('+++++++++++++++++++++  ');
      _addKeranjang(dataMenu);
    }
  }

  void _addKeranjang(Map<String, dynamic> dataMenu) {
    print(dataMenu['id_menu']);
    //cek apakah kode belum terpakai
    databaseRef
        .collection('flutter_keranjang')
        .document(widget.dataP['uid'])
        .collection('food')
        .where('id_menu', isEqualTo: dataMenu['id_menu'])
        // .where('kd_transaksi',isEqualTo: '$order')
        .getDocuments()
        .then((event) {
      if (event.documents.isEmpty) {
        var documentReference = databaseRef
            .collection('flutter_keranjang')
            .document(widget.dataP['uid'])
            .collection('food')
            .document();
        documentReference.setData({
          'id_resto': dataMenu['id_resto'],
          'id_menu': dataMenu['id_menu'],
          'img_menu': dataMenu['img_menu'],
          'nm_menu': dataMenu['nm_menu'],
          'item_ket': '',
          'ket_menu': dataMenu['ket_menu'],
          'hrg': dataMenu['hrg'],
          'qity': 1,
          'posisi': widget.dataResto['posisi'],
          // 'img_menu': 'https://firebasestorage.googleapis.com/v0/b/wide-plating-227823.appspot.com/o/img_resto%2Ffood_1.jpg?alt=media&token=d07e35e1-50af-4a6a-969e-b867b8c3df7c',
        }).whenComplete(() async {
          // _hitungHarga();
        }).catchError((err) {
          print('catchError');
          //  setState(() {    habis_waktu_menunggu = false;  });
          //ModeReseiveFalse( 'Koneksi internet mungkin lagi lelet, Silah ulangi order');
        });
        //documentIDNYA=documentReference.documentID;
      } else {
        var numQity = event.documents[0].data['qity'] + 1;
        // print(numQity);
        databaseRef
            .collection('flutter_keranjang')
            .document(widget.dataP['uid'])
            .collection('food')
            //.where('field',isEqualTo: '');
            .document(event.documents[0].documentID)
            .updateData({
          'qity': numQity,
        }).whenComplete(() {
          //  _hitungHarga();
        }).catchError((err) {
          print('catchError');
        });
        // setState(() {      habis_waktu_menunggu = false;   });
        //ModeReseiveFalse( 'Koneksi internet mungkin lagi lelet, Silah ulangi order');
      }
    }).catchError((e) {
      //setState(() {    habis_waktu_menunggu = false;  });
      //ModeReseiveFalse( 'Koneksi internet mungkin lagi lelet, Silah ulangi order');
    });
  }

  void setQity(int numQity, String idItem) {
    if (numQity > 0) {
      databaseRef
          .collection('flutter_keranjang')
          .document(widget.dataP['uid'])
          .collection('food')
          //.where('field',isEqualTo: '')
          .document(idItem)
          .updateData({
        'qity': numQity,
      }).whenComplete(() {
        setState(() {
          qityPesanan[idItem] = numQity;
        });
      }).catchError((err) {
        print('catchError');
      });
    } else {
      databaseRef
          .collection('flutter_keranjang')
          .document(widget.dataP['uid'])
          .collection('food')
          //.where('field',isEqualTo: '');
          .document(idItem)
          .delete()
          .whenComplete(() {
        setState(() {
          qityPesanan[idItem] = 0;
        });
      }).catchError((err) {
        print('catchError');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (snapshotRestoPesanan != null) {
      _hitungHarga();
    }
    double fullSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      //backgroundColor: Colors.white,
      body: //itemMenuResto == null ? Container(child: Center(child:Text('loading map..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) :
          Stack(
              // alignment: Alignment.topCenter,
              children: <Widget>[
            NestedScrollView(
              // controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    // backgroundColor: Colors.orangeAccent,
                    elevation: 2,
                    // titleSpacing:200 ,
                    expandedHeight: fullSizeHeight / 2 - 10, //210.0,
                    // backgroundColor:Colors.white,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: Text(
                      widget.dataResto['nm_resto'],
                      style: TextStyle(color: Colors.white),
                    ),
                    floating: true,
                    pinned: true,
                    // snap: true,
                    flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        titlePadding: const EdgeInsets.all(0.0),
                        //centerTitle: true,
                        //    title: Text("text sample",
                        //            style: TextStyle(
                        //              color: isShrink ? Colors.black : Colors.white,
                        //              fontSize: 16.0,
                        // )),
                        // background: Image.network(   "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",  fit: BoxFit.cover,  )
                        background: widget.dataResto['img'] != ''
                            ? CachedNetworkImage(
                                imageUrl: widget.dataResto['img'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Center(
                                    child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )),
                              )
                            : Image.asset(
                                'assets/images/no_image/no_resto.jpg',
                                fit: BoxFit.cover,
                              )),
                  ),
                ];
              },
              body: _body(),
            ),

            //keranjang belanja item pesanan
            Visibility(
              visible: visibilityitemPesanan,
              child: Positioned(
                bottom: 10,
                right: 10,
                left: 10,
                child: RaisedButton(
                  color: Colors.green,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 2, right: 6),
                        child: Icon(Icons.add_shopping_cart,
                            size: 24.0, color: Colors.white),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Harga belum termasuk onkir',
                            style: TextStyle(
                              fontFamily: 'NeoSans',
                              fontSize: 11,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '$itemPesanan item',
                            style: TextStyle(
                              fontFamily: 'NeoSans',
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      )),
                      Text(
                        'Rp ${uang.format(hargaPesanan)}',
                        style: TextStyle(
                          fontFamily: 'NeoSans',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (widget.dataResto['dari_page'] == 'keranjang') {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Keranjang(
                                  dataP: widget.dataP,
                                  idRestoPesanan: idRestoPesanan,
                                  geoRestoPesanan: geoRestoPesanan,
                                )),
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            )
          ]),
    );
  }

  Widget _body1() {
    return SingleChildScrollView(
        child: Column(
            //crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
          widgetResto(),
          _fooList(),
          itemPesanan == 0
              ? SizedBox(
                  height: 0,
                )
              : SizedBox(
                  height: 55,
                ),
        ]));
  }

  Widget widgetResto() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
            child: Text(
              '${widget.dataResto['nm_resto']}',
              maxLines: 3,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'NeoSansBold',
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Text(widget.dataResto['ket_resto']),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Text(
              'Alamat: ${widget.dataResto['alamat_resto']}',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 4.0,
              right: 4.0,
              top: 16.0,
              bottom: 16.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: Text(
                  '${widget.dataResto['status']}',
                  style: TextStyle(
                    fontFamily: 'NeoSans',
                    fontSize: 16,
                    color: widget.dataResto['status'] == 'Buka'
                        ? Colors.orange
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                )),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: Text(
                        '-Buka jam ${widget.dataResto['buka']}:${widget.dataResto['tutup']} hari ini')),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Color(0xffe99e1e),
                          ),
                          Text(widget.dataResto['bintang'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: 'NeoSansBold',
                                decoration: TextDecoration.none,
                              )),
                        ]),
                    Text('${widget.dataResto['divide_reputation']}+ rating')
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.location_on, color: Colors.red),
                          widget.dataResto['laris'] == ''
                              ? Text('${widget.dataResto['jarak']} km',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0,
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'NeoSansBold',
                                    decoration: TextDecoration.none,
                                  ))
                              : FutureBuilder<String>(
                                  future: callApi.getDistance(
                                      '${geoNya.latitude},${geoNya.longitude}',
                                      '${widget.dataP['lat_antar']},${widget.dataP['long_antar']}'), // async work
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.hasData) {
                                      widget.dataResto['jarak'] = snapshot.data;
                                      print(widget.dataP['lat_antar']);
                                      return Text('${snapshot.data} km',
                                          style: TextStyle(
                                            fontFamily: 'NeoSansBold',
                                            fontSize: 11,
                                          ));
                                    } else if (snapshot.hasError) {
                                      return Text('0 km',
                                          style: TextStyle(
                                            fontFamily: 'NeoSansBold',
                                            fontSize: 11,
                                          ));
                                      ;
                                    }
                                    return Text('0 km',
                                        style: TextStyle(
                                          fontFamily: 'NeoSansBold',
                                          fontSize: 11,
                                        ));
                                    ;
                                  },
                                ),
                        ]),
                    Text('Dari Lokasimu')
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Icon(Icons.attach_money, color: Colors.blue),
                          Text('\$\$\$',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                                fontSize: 18,
                                color: Colors.black38,
                                fontFamily: 'NeoSansBold',
                                decoration: TextDecoration.none,
                              )),
                        ]),
                    Text('Rp ${widget.dataResto['min_hrg']} an')
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            height: 4,
          ),
        ]);
  }

  Widget _body() {
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return widgetResto();
        } else if (index == 1) {
          return _fooList();
        } else if (index == 2) {
          return itemPesanan == 0
              ? SizedBox(
                  height: 0,
                )
              : SizedBox(
                  height: 55,
                );
        } else {
          return SizedBox(
            height: 1,
          );
        }
      },
    );
  }

  Widget _fooList() {
    //if (menus != null) {
    return FutureBuilder(
      future: crudObj.getMenu(widget.dataResto['id_resto']),
      builder: (BuildContext context, AsyncSnapshot packSnap) {
        if (packSnap.hasData) {
          if (packSnap.data != null) {
            //var size = MediaQuery.of(context).size;
            // var itemHeight = (size.height - kToolbarHeight - 24) / 3;
            // var itemWidth = size.width / 2;
            return /* GridView.builder( 
                // scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(6.0),
                 shrinkWrap: true, 
                 physics: ScrollPhysics(), 
                // physics: const AlwaysScrollableScrollPhysics(),
                itemCount:  packSnap.data.documents.length,   
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, 
                      // childAspectRatio: (itemWidth / itemHeight), 
                      childAspectRatio:1,
                ), */
                ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 15,
                  indent: 120.1,
                );
              },
              itemCount: packSnap.data.documents.length, //ds.data.length,
              padding: EdgeInsets.all(3),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // physics:   ClampingScrollPhysics(),
              //scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                // packSnap.data.documents[0].documentID
                // ItemMenuResto list=ds.data[index];
                //print('awallllll buat ${packSnap.data.documents.length}' );
                // DocumentSnapshot ds = packSnap.data.documents[index];
                if (header == '') {
                  //  print('awallllll buat ${ds.data['kategori']}' );
                  header = packSnap.data.documents[index].data['kategori'];
                  return _rowHeader(
                      packSnap.data.documents[index]); //_rowHeader
                } else {
                  if (header ==
                      packSnap.data.documents[index].data['kategori']) {
                    // print('sama ${ds.data['kategori']}');
                    header = packSnap.data.documents[index].data['kategori'];
                    return _rowDefault(packSnap.data.documents[index]);
                  } else {
                    // print('akhir buat ${ds.data['kategori']}');
                    header = packSnap.data.documents[index].data['kategori'];
                    return _rowHeader(
                        packSnap.data.documents[index]); //_rowHeader
                  }
                }
              },
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
        return CircularProgressIndicator();
      },
    );
    //} else {
    //  return Center(child: CircularProgressIndicator(backgroundColor:  Colors.white ,));
    //}
  }

  Widget _rowDefault(DocumentSnapshot food) {
    if (itemPesanan == 0) {
      qityPesanan[food.documentID] = 0;
    } else if (qityPesanan[food.documentID] != null && itemPesanan != 0) {
    } else {
      qityPesanan[food.documentID] = 0;
    }

    return InkWell(
      onTap: () async {
        _showSheetItem({
          'id_resto': food['id_resto'],
          'id_menu': food.documentID,
          'img_menu': food['img'],
          'ket_menu': food['ket_menu'],
          'nm_menu': food['nm_menu'],
          'hrg': food['hrg'],
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          zulLib.widgetResto(food['img']),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(food['nm_menu'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        color: Colors.black,
                        fontFamily: 'NeoSans',
                        fontSize: 13,
                      )),
                  Text(food['ket_menu'],
                      style: TextStyle(
                        letterSpacing: 0,
                        color: Colors.black,
                        fontFamily: 'NeoSans',
                        fontSize: 13,
                      )),
                  Text('Rp${uang.format(food['hrg'])}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        color: Colors.orange[800],
                        fontFamily: 'NeoSans',
                        fontSize: 12,
                        decoration: TextDecoration.none,
                      )),
                  /*Row(
                          crossAxisAlignment: CrossAxisAlignment.start,  
                          mainAxisAlignment: MainAxisAlignment.start, 
                          children: <Widget>[ 
                              Text('100.0000', style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 0,
                              color: Colors.black, fontFamily: 'NeoSans',fontSize: 12, 
                              decoration: TextDecoration.none,  
                              )
                            ), 
                            SizedBox( width: 16, ),         
                            Text('100.0000', style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 0,
                              color: Colors.black38, fontFamily: 'NeoSans',
                              decoration: TextDecoration.lineThrough,  fontSize: 12,  
                              )
                            ), 
                          ]
                      ), */
                  qityPesanan[food.documentID] != 0
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              //text  ket item
                              // Expanded(
                              //    flex: 1,
                              //     child: SizedBox(),
                              //  ) ,
                              //button delete
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 30.0),
                                //width: 100,height:  32,color:Colors.yellow,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Colors.white,
                                      //borderRadius: BorderRadius.all(  Radius.circular(2.0)   ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green,
                                          blurRadius: 1.0,
                                        )
                                      ]),
                                  width: 32, height: 32, //color:Colors.yellow,
                                  child: RaisedButton(
                                    onPressed: () {
                                      setQity(
                                          0, idFoodPesanan[food.documentID]);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    color: Colors.white,
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 0.0),
                                  ),
                                ),
                              ),
                              // plus amd mines
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.0),
                                    //borderRadius: BorderRadius.all(  Radius.circular(2.0)   ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green,
                                        blurRadius: 1.0,
                                      )
                                    ]),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      //minies
                                      Container(
                                        width: 32,
                                        height: 33,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              awal =
                                                  qityPesanan[food.documentID] -
                                                      1;
                                            });
                                            setQity(awal,
                                                idFoodPesanan[food.documentID]);
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            size: 18,
                                            color: Colors.green,
                                          ),
                                          color: Colors.white,
                                          elevation: 0,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                      //jumlah qity
                                      Container(
                                        //color: Colors.transparent,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 8),
                                        width: 40, height: 34,
                                        child: Text(
                                          '${qityPesanan[food.documentID]}',
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'NeoSans',
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                      //plus
                                      Container(
                                        width: 32,
                                        height: 33,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              awal =
                                                  qityPesanan[food.documentID] +
                                                      1;
                                            });
                                            setQity(awal,
                                                idFoodPesanan[food.documentID]);
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: 18,
                                            color: Colors.green,
                                          ),
                                          color: Colors.white,
                                          elevation: 0,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            ])
                      : RaisedButton(
                          onPressed: () {
                            if (widget.dataResto['status'] == 'Buka') {
                              showAlertDialog({
                                'id_resto': food['id_resto'],
                                'id_menu': food.documentID,
                                'img_menu': food['img'],
                                'ket_menu': food['ket_menu'],
                                'nm_menu': food['nm_menu'],
                                'hrg': food['hrg'],
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Text(
                                            "Oupss... Restorannya tutup, Cari restoran lain aja ya :)"),
                                      ));
                            }
                          },
                          textColor: Colors.white,
                          child: Text('Tambah,'),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                ],
              ),
            ),
          )
        ],
      ),
      // ),
    );
  }

  Widget _rowHeader(DocumentSnapshot food) {
    if (itemPesanan == 0) {
      qityPesanan[food.documentID] = 0;
    } else if (qityPesanan[food.documentID] != null && itemPesanan != 0) {
    } else {
      qityPesanan[food.documentID] = 0;
    }
    return // Padding(
        // padding: const EdgeInsets.only(left: 0,right:0, top: 6,bottom: 10 ),
        // child:
        Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 10),
            child: Text(food['kategori'],
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                  color: Colors.black87,
                  fontFamily: 'NeoSansBold',
                  fontSize: 16,
                  decoration: TextDecoration.none,
                )),
          ),
          InkWell(
            onTap: () async {
              _showSheetItem({
                'id_resto': food['id_resto'],
                'id_menu': food.documentID,
                'img_menu': food['img'],
                'ket_menu': food['ket_menu'],
                'nm_menu': food['nm_menu'],
                'hrg': food['hrg'],
              });
            },
            child: //Padding(
                //padding: const EdgeInsets.only(left: 4,right:4, top: 6,bottom: 10 ),
                // child:
                Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  //image
                  zulLib.widgetResto(food['img']),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(food['nm_menu'],
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0,
                                      color: Colors.black,
                                      fontFamily: 'NeoSansBold',
                                      fontSize: 13,
                                      decoration: TextDecoration.none,
                                    )),
                              ),
                              /*  Container ( 
                                  padding: EdgeInsets.symmetric(vertical: 0.0, horizontal:0.0),
                                  width: 18,height:  18,//color:Colors.yellow,
                                  child: RaisedButton( 
                                    onPressed: () {  
                                        
                                    },
                                    child:   Icon(Icons.favorite,size: 16,color: Colors.pink ,),   
                                      shape:   RoundedRectangleBorder( 
                                      borderRadius:   BorderRadius.circular(5.0),
                                    ), 
                                    color: Colors.white,elevation: 0,
                                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                  ), 
                            ) ,  */
                            ],
                          ),
                          Text(
                            food['ket_menu'],
                            maxLines: 2,
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 13,
                            ),
                          ),
                          Text('Rp${uang.format(food['hrg'])}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                                color: Colors.orange[800],
                                fontFamily: 'NeoSans',
                                fontSize: 12,
                                decoration: TextDecoration.none,
                              )),
                          /*Row(
                          crossAxisAlignment: CrossAxisAlignment.start,  
                          mainAxisAlignment: MainAxisAlignment.start, 
                          children: <Widget>[ 
                              Text('100.0000', style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 0,
                              color: Colors.black, fontFamily: 'NeoSans',fontSize: 12, 
                              decoration: TextDecoration.none,  
                              )
                            ), 
                            SizedBox( width: 16, ),         
                            Text('100.0000', style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 0,
                              color: Colors.black38, fontFamily: 'NeoSans',
                              decoration: TextDecoration.lineThrough,  fontSize: 12,  
                              )
                            ), 
                          ]
                      ), */
                          //edit ket
                          qityPesanan[food.documentID] != 0
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                      //text  ket item
                                      // Expanded(
                                      //    flex: 1,
                                      //     child: SizedBox(),
                                      //  ) ,
                                      //button delete
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 30.0),
                                        //width: 100,height:  32,color:Colors.yellow,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              color: Colors.white,
                                              //borderRadius: BorderRadius.all(  Radius.circular(2.0)   ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.green,
                                                  blurRadius: 1.0,
                                                )
                                              ]),
                                          width: 32,
                                          height: 32, //color:Colors.yellow,
                                          child: RaisedButton(
                                            onPressed: () {
                                              setQity(
                                                  0,
                                                  idFoodPesanan[
                                                      food.documentID]);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Colors.grey,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            color: Colors.white,
                                            elevation: 0,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 0.0),
                                          ),
                                        ),
                                      ),
                                      // plus amd mines
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            //borderRadius: BorderRadius.all(  Radius.circular(2.0)   ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green,
                                                blurRadius: 1.0,
                                              )
                                            ]),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              //minies
                                              Container(
                                                width: 32,
                                                height: 33,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      awal = qityPesanan[
                                                              food.documentID] -
                                                          1;
                                                    });
                                                    setQity(
                                                        awal,
                                                        idFoodPesanan[
                                                            food.documentID]);
                                                  },
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 18,
                                                    color: Colors.green,
                                                  ),
                                                  color: Colors.white,
                                                  elevation: 0,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.0,
                                                      horizontal: 0.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                ),
                                              ),
                                              //jumlah qity
                                              Container(
                                                //color: Colors.transparent,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0, vertical: 8),
                                                width: 40, height: 34,
                                                child: Text(
                                                  '${qityPesanan[food.documentID]}',
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'NeoSans',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                              ),
                                              //plus
                                              Container(
                                                width: 32,
                                                height: 33,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      awal = qityPesanan[
                                                              food.documentID] +
                                                          1;
                                                    });
                                                    setQity(
                                                        awal,
                                                        idFoodPesanan[
                                                            food.documentID]);
                                                  },
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 18,
                                                    color: Colors.green,
                                                  ),
                                                  color: Colors.white,
                                                  elevation: 0,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.0,
                                                      horizontal: 0.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ])
                              : RaisedButton(
                                  onPressed: () {
                                    if (widget.dataResto['status'] == 'Buka') {
                                      showAlertDialog({
                                        'id_resto': food['id_resto'],
                                        'id_menu': food.documentID,
                                        'img_menu': food['img'],
                                        'ket_menu': food['ket_menu'],
                                        'nm_menu': food['nm_menu'],
                                        'hrg': food['hrg'],
                                      });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: Text(
                                                    "Oupss... Restorannya tutup, Cari restoran lain aja ya :)"),
                                              ));
                                    }
                                  },
                                  textColor: Colors.white,
                                  child: Text('Tambah'),
                                  color: Colors.green,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )
                ]),
          ),
          //),
        ]);
    // );
  }

  void _showSheetItem(Map<String, dynamic> dataMenu) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // elevation:500,
      isDismissible: true,
      //useRootNavigator: useRootNavigator,
      isScrollControlled:
          true, // set this to true when using DraggableScrollableSheet as child
      builder: (_) {
        return DraggableScrollableSheet(
            expand: true,
            initialChildSize: 0.95,
            minChildSize: 0.0,
            maxChildSize: 0.95,
            builder: (_, controller) {
              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return ClipRRect(
                    //borderRadius: borderRadius.evaluate(CurvedAnimation(parent: _controller, curve: Curves.ease)),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16.0),
                      topRight: const Radius.circular(16.0),
                    ),
                    child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                color: Colors.green,
                                child: Text(
                                  '${dataMenu['nm_menu']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            CachedNetworkImage(
                              imageUrl: '${dataMenu['img_menu']}',
                              fit: BoxFit.cover,

                              height:
                                  MediaQuery.of(context).size.height / 2 - 10,
                              //width: MediaQuery.of(context).size.width,
                              //height: double.infinity,
                              width: double.infinity,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('${dataMenu['nm_menu']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                          color: Colors.black,
                                          fontFamily: 'NeoSans',
                                          fontSize: 12,
                                          decoration: TextDecoration.none,
                                        )),
                                    Text('${dataMenu['ket_menu']}'),
                                    Divider(
                                      color: Colors.grey,
                                      height: 16,
                                    ),
                                    Text('Rp ${uang.format(dataMenu['hrg'])}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                          color: Colors.black,
                                          fontFamily: 'NeoSans',
                                          fontSize: 12,
                                          decoration: TextDecoration.none,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                            //SizedBox(
                            //   height: MediaQuery.of(context).size.height-(MediaQuery.of(context).size.height/20) -100,
                            //),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: RaisedButton(
                                  color: Colors.green,
                                  child: Text(
                                    widget.dataResto['status'] == 'Buka'
                                        ? 'Tabah ke keranjang'
                                        : 'Restoran Tutup',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    if (widget.dataResto['status'] == 'Buka') {
                                      showAlertDialog(dataMenu);
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: Text(
                                                    "Oupss... Restorannya tutup, Cari restoran lain aja ya :)"),
                                              ));
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                        /*CustomScrollView(
                              controller: controller,  
                              slivers: <Widget>[
                                 SliverAppBar(
                                  title: Text("What's Up?"),
                                  backgroundColor: Colors.orange,
                                  automaticallyImplyLeading: false,
                                  primary: false,
                                  floating: true,
                                  pinned: true,
                                ), 
                                
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        (context, idx) => ListTile(
                                      title: Text('Nothing much'),
                                      subtitle: Text('$idx'),
                                    ),
                                    childCount: 4,
                                  ),
                                )
                              ],
                            ),*/
                        ),
                  );
                },
              );
            });
      },
    );
  }
}
