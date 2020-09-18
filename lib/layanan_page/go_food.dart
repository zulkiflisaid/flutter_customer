import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pelanggan/api/api.dart';
import 'package:pelanggan/beranda/beranda_model.dart';
import 'package:pelanggan/librariku/bintang.dart';
import 'package:pelanggan/model/class_model.dart';

import '../constans.dart';
import 'gofood/cari_menu.dart';
import 'package:pelanggan/layanan_page/gofood/list_resto_depan.dart';
import 'package:pelanggan/api/firestore_db.dart';
import 'gofood/keranjang.dart';
import 'gofood/map_lokasi.dart';
import 'gofood/restoran.dart';

class GoFoodPage extends StatelessWidget {
  GoFoodPage({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoFood(
        dataP: dataP,
      ),
    );
  }
}

class GoFood extends StatefulWidget {
  GoFood({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  GoFoodState createState() => GoFoodState();
}

class GoFoodState extends State<GoFood> {
  var uang = NumberFormat.currency(locale: 'ID', symbol: '', decimalDigits: 0);

  final cariController = TextEditingController();

  // Geoflutterfire geo;
  GoogleMapController mapController;
  static LatLng _initialPosition = LatLng(-3.47764787218, 119.141805461);

  var lesserGeopoint = GeoPoint(0, 0);
  var greaterGeopoint = GeoPoint(0, 0);
  //map direction
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  ListResDepan listRestoBloc;
  ScrollController controller = ScrollController();
  String adresUser = '';
  String ketUser = '';
  String nmResoran = '';
  int itemPesanan = 0;
  var hargaPesanan = 0;
  ZulLib zulLib = ZulLib();
  CallApi callApi = CallApi();
  CrudMedthods crudObj = CrudMedthods();
  Stream<dynamic> snapshotRestoPesanan;
  bool visibilityitemPesanan = false;
  var idRestoPesanan = '';
  GeoPoint geoRestoPesanan = GeoPoint(0.0, 0.0);
  Future<List<Promosi>> fetchRestoran;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchRestoran = fetchRestoranPage();
    listRestoBloc = ListResDepan();
    _getPosisiUserAwal();
    controller.addListener(_scrollListener);
  }

  void _hitungHarga() {
    var total = 0;
    bool isibilityitem = true;

    var items = 1;
    var idRestoPesananNya = '';
    GeoPoint geoRestoPesananNya = GeoPoint(0.0, 0.0);

    // total = total + (element.data['hrg'] * element.data['qity']);
    //  items = items + element.data['qity'];
    //  isibilityitem = true;
    //  idRestoPesananNya = element.data['id_resto'];
    //  geoRestoPesananNya = element.data['posisi'];

    if (mounted) {
      setState(() {
        idRestoPesanan = idRestoPesananNya;
        geoRestoPesanan = geoRestoPesananNya;
        visibilityitemPesanan = isibilityitem;
        hargaPesanan = total;
        itemPesanan = items;
      });
    }
  }

  Future<void> _getPosisiUserAwal() async {
    if ((await Geolocator().isLocationServiceEnabled())) {
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() {
          _initialPosition = LatLng(position.latitude, position.longitude);

          widget.dataP['lat_antar'] = _initialPosition.latitude;
          widget.dataP['long_antar'] = _initialPosition.longitude;

          getDocumentNearBy(
              _initialPosition.latitude, _initialPosition.longitude, 222);
        });

        listRestoBloc.fetchFirstList(lesserGeopoint, greaterGeopoint,
            _initialPosition.latitude, _initialPosition.longitude);
        _getAdressLocation();
      }).catchError((e) {
        /*showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Tidak dapat menampilkan lokasi"),
                content: const Text(
                    'Pastikan terkoneksi internet kemudain coba lagi'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                        // Navigator.pop(context);
                      })
                ],
              );
            }).whenComplete(() {
          Navigator.pop(context);
        });*/
      });
    } else {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Tidak dapat menampilkan lokasi"),
                content:
                    const Text('Pastikan Anda mengaktifkan GPS dan coba lagi'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        // Navigator.pop(context);
                      })
                ],
              );
            }).whenComplete(() {
          Navigator.pop(context);
        });
      }
    }
  }

  void _getAdressLocation() async {
    try {
      var placemark = await Geolocator().placemarkFromCoordinates(
          _initialPosition.latitude, _initialPosition.longitude);
      setState(() {
        var placeMark = placemark[0];
        var name = placeMark.name;
        var subLocality = placeMark.subLocality;
        var locality = placeMark.locality;
        var administrativeArea = placeMark.administrativeArea;
        var postalCode = placeMark.postalCode;
        var country = placeMark.country;
        var address =
            '$name, $subLocality, $locality, $administrativeArea $postalCode, $country';
        print(address);
        adresUser = '$address';
      });

      widget.dataP['adress_antar'] = adresUser;
      widget.dataP['lat_antar'] = _initialPosition.latitude;
      widget.dataP['long_antar'] = _initialPosition.longitude;
    } catch (e) {
      print('ERRORku>>$_initialPosition:$e');
      // _initialPosition = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _hitungHarga();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        //title: Text('Profil Saya',style: TextStyle(color: Colors.black ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          child: InkWell(
            borderRadius: BorderRadius.circular(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Text(
                    'Lokasi kamu',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'NeoSans',
                      fontSize: 12,
                      letterSpacing: 0,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      size: 16.0, color: Colors.green),
                ]),
                Text(
                  adresUser == '' ? 'Set lokasi' : adresUser,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'NeoSans',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            onTap: () async {
              var dataLokasi =
                  await navigateToEntryForm(context, 'SetLokasiPage');
              // print(dataLokasi);
              if (dataLokasi != null) {
                setState(() {
                  _initialPosition =
                      LatLng(dataLokasi['lat'], dataLokasi['long']);
                  adresUser = dataLokasi['address'];
                  ketUser = dataLokasi['ket'];
                });
                widget.dataP['ket_antar'] = ketUser;
                widget.dataP['adress_antar'] = adresUser;
                widget.dataP['lat_antar'] = _initialPosition.latitude;
                widget.dataP['long_antar'] = _initialPosition.longitude;
              }
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shop_two, color: Colors.black),
            onPressed: () async {
              await Firestore.instance.collection("flutter_tarif").add({
                'basic_km': 4,
                'basic_price': 4000,
                'category_driver': 'food',
                'charge': 1000,
                'discon_saldo': 1000,
                'discon_tunai': 0,
                'distance_looping_km': 4,
                'min_meter': 100,
                'point_transaction': 1,
                'price_looping_km': 4000,
                'price_per_km': 1000,
                'user_id': 'admin',
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.black),
            onPressed: () {
              showBottomSheet(
                  context: context,
                  elevation: 1,
                  clipBehavior: Clip.antiAlias,
                  builder: (context) {
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
                            color: Colors.blue[800],
                            child: CustomScrollView(
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
                                    childCount: 10,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  });
              /* var sheetController = showBottomSheet(
                    context: context,
                    builder: (context) =>  BottomSheetWidget()
                        
                    );  
                    sheetController.closed.then((value) {
                       print(value);  
                    }); */
            },
          ),
        ],
      ),
      body: //SizedBox.expand(
          //jika loadng map jika tidak ingin pakai loading map silahkan ganti
          _initialPosition == null
              ? Container(
                  child: Center(
                    child: Text(
                      'loading map..',
                      style: TextStyle(
                          fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                    ),
                  ),
                )
              : Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      _body(),

                      //keranjang belanja item pesanan
                      Visibility(
                        visible: itemPesanan == 0 ? false : true,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Keranjang(
                                          dataP: widget.dataP,
                                          idRestoPesanan: idRestoPesanan,
                                          geoRestoPesanan: geoRestoPesanan,
                                        )),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _body() {
    Widget titleCari = Card(
        elevation: 0,
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: GojekPalette.grey200,
              border: Border.all(
                color: Colors.grey,
                width: 0.3,
              ),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: InkWell(
              splashColor: Colors.grey,
              highlightColor: Colors.grey,
              borderRadius: BorderRadius.circular(6.0),
              onTap: () async {
                var dataPencarian =
                    await navigateToEntryForm(context, 'CariMenu');
                if (dataPencarian != null) {
                  Map<String, dynamic> dataResto1 = {
                    'dari_page': '',
                    'laris': 'yes',
                    'id_menu': dataPencarian['id_menu'],
                    'img_menu': dataPencarian['img'],
                    'ket_menu': dataPencarian['ket_menu'],
                    'nm_menu': dataPencarian['nm_menu'],
                    'hrg': dataPencarian['hrg'],
                    'id_resto': dataPencarian['id_resto'],
                    'lat': _initialPosition.latitude,
                    'long': _initialPosition.longitude,
                    'nm_resto': '',
                    'ket_resto': '',
                    'kat_onkir': '',
                    'alamat_resto': '',
                    'img': '',
                    'jarak': 0,
                    'bintang': 0,
                    'divide_reputation': 0,
                    'min_hrg': 0,
                    'status': 'Tutup',
                    'buka': '08]=00',
                    'tutup': '08]=00',
                    'posisi': GeoPoint(0.0, 0.0),
                  };
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Restoran(
                              dataP: widget.dataP,
                              dataResto: dataResto1,
                            )),
                  );
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 0),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => Navigator.of(context).pop(null),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    'Mau makan apa hari ini?',
                    style: TextStyle(
                      fontFamily: 'NeoSans',
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ));

    Widget boardView = StreamBuilder<List<Promosi>>(
      stream: listRestoBloc.restoStream,
      builder: (context, snapshot) {
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
          return ListView.builder(
            // scrollDirection: Axis.vertical,
            // itemCount: ChatModel22.dummyData.length,
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            controller: controller,
            itemBuilder: (context, index) {
              var bintang = zulLib.bintang(0, 0);
              //   var bukaOrtutup =   zulLib.bukaOrtutup("snapshot.data[index]['buka']");
              Map<String, dynamic> bukaOrtutup = {
                'status': "bukaOrtutup",
                'buka': '999 ',
                'tutup': '99',
              };
              GeoPoint geoNya = GeoPoint(0, 0);
              // var jarak=callApi.getDistance( '${geoNya.latitude},${geoNya.longitude}','${_initialPosition.latitude},${_initialPosition.longitude}');
              // String jarak='0';
              // callApi.getDistance( '${geoNya.latitude},${geoNya.longitude}','${_initialPosition.latitude},${_initialPosition.longitude}').then((value) {

              //});
              Map<String, dynamic> dataResto1 = {
                'laris': '',
                'id_resto': snapshot.data[index].id,
                'nm_resto': snapshot.data[index].title,
                'ket_resto': snapshot.data[index].title,
                'kat_onkir': snapshot.data[index].title,
                'alamat_resto': snapshot.data[index].title,
                'img': snapshot.data[index].image,
                //'jarak':  zulLib.calculateDistance(snapshot.data[index]['posisi'],_initialPosition),
                'jarak': '0',
                'bintang': bintang,
                'divide_reputation': snapshot.data[index].title,
                'min_hrg': snapshot.data[index].title,
                'status': bukaOrtutup['status'],
                'buka': bukaOrtutup['tutup'],
                'tutup': bukaOrtutup['tutup'],
                'posisi': GeoPoint(geoNya.latitude, geoNya.longitude),
              };
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        mounted == true
                            ? _buildMenuTerlaris()
                            : SizedBox(
                                height: 2,
                              ),
                        Card(
                          margin: const EdgeInsets.all(4.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4.0),
                            onTap: () {
                              if (bukaOrtutup['status'] == 'Buka') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Restoran(
                                            dataP: widget.dataP,
                                            dataResto: dataResto1,
                                          )),
                                );
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(
                                              "Oupss... Restorannya tutup, Cari restoran lain aja ya :)"),
                                        ));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data[index].image,
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )
                                      // Image.network(snapshot.data[index]['img'],width: 100,height: 90,fit: BoxFit.cover,),
                                      ),
                                  Expanded(
                                    //width: 250,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.0, right: 6.0, top: 0.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          //nama resto
                                          Text(
                                            snapshot.data[index].message,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0,
                                                fontSize: 15),
                                          ),
                                          //ket resto
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0, bottom: 2.0),
                                            child: Text(
                                              snapshot.data[index].message,
                                              style: TextStyle(
                                                letterSpacing: 0,
                                                fontSize: 14,
                                                color: Colors.black45,
                                              ),
                                              maxLines: 3,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          //rating jarak
                                          Row(
                                            children: [
                                              //bintang
                                              bintang == 0
                                                  ? SizedBox(
                                                      width: 0,
                                                    )
                                                  : Icon(Icons.grade,
                                                      size: 16.0,
                                                      color: Colors.orange),
                                              bintang == 0
                                                  ? SizedBox(
                                                      width: 0,
                                                    )
                                                  : Text(
                                                      '$bintang',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'NeoSansBold',
                                                        fontSize: 11,
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                              bintang == 0
                                                  ? SizedBox(
                                                      width: 0,
                                                    )
                                                  : SizedBox(
                                                      width: 16,
                                                    ),
                                              //Text('$jarak km' ,style: TextStyle( fontFamily:'NeoSansBold',fontSize:11,)),
                                              new FutureBuilder<String>(
                                                future: callApi.getDistance(
                                                    '${geoNya.latitude},${geoNya.longitude}',
                                                    '${_initialPosition.latitude},${_initialPosition.longitude}'), // async work
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<String>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    dataResto1['jarak'] =
                                                        snapshot.data;
                                                    //print(snapshot.data);
                                                    return Text(
                                                        '${snapshot.data} km',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'NeoSansBold',
                                                          fontSize: 11,
                                                        ));
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text('0 km',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'NeoSansBold',
                                                          fontSize: 11,
                                                        ));
                                                    ;
                                                  }
                                                  return Text('0 km',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'NeoSansBold',
                                                        fontSize: 11,
                                                      ));
                                                  ;
                                                },
                                              ),
                                            ],
                                          ),
                                          //buka tutup
                                          Text(
                                            "Buka: ${bukaOrtutup['buka']} - Tutup: ${bukaOrtutup['tutup']} ",
                                            style: TextStyle(
                                              letterSpacing: 0,
                                              fontSize: 12,
                                              color: bukaOrtutup['status'] ==
                                                      'Buka'
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            maxLines: 2,
                                            textAlign: TextAlign.left,
                                          ),
                                          //gartis onkir
                                          snapshot.data[index].message == '0'
                                              ? SizedBox()
                                              : SizedBox(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(Icons.motorcycle,
                                                          size: 16.0,
                                                          color: Colors.orange),
                                                      Expanded(
                                                        child: Text(
                                                            '-Bebas biaya antar maksimal jarak ${snapshot.data[index].message} km',
                                                            maxLines: 3,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              letterSpacing: 0,
                                                              color: Colors.red,
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                );
              } else {
                return Card(
                  margin: const EdgeInsets.all(4.0),
                  child: InkWell(
                    // splashColor: Colors.yellow,
                    //highlightColor: Colors.blue ,
                    borderRadius: BorderRadius.circular(4.0),
                    //focusColor:  Colors.green,
                    // hoverColor: Colors.red,
                    onTap: () {
                      if (bukaOrtutup['status'] == 'Buka') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Restoran(
                                    dataP: widget.dataP,
                                    dataResto: dataResto1,
                                  )),
                        );
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(
                                      "Oupss... Restorannya tutup, Cari restoran lain aja ya :)"),
                                ));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data[index].image,
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )),
                          Expanded(
                            //width: 250,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 6.0, right: 6.0, top: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[index].message,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2.0, bottom: 2.0),
                                    child: Text(
                                      snapshot.data[index].message,
                                      style: TextStyle(
                                        letterSpacing: 0,
                                        fontSize: 14,
                                        color: Colors.black45,
                                      ),
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Row(
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      bintang == 0
                                          ? SizedBox(
                                              width: 0,
                                            )
                                          : Icon(Icons.grade,
                                              size: 16.0, color: Colors.orange),
                                      bintang == 0
                                          ? SizedBox(
                                              width: 0,
                                            )
                                          : Text(
                                              '$bintang',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'NeoSansBold',
                                                fontSize: 11,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                      bintang == 0
                                          ? SizedBox(
                                              width: 0,
                                            )
                                          : SizedBox(
                                              width: 16,
                                            ),
                                      //  Text('$jarak km' ,style: TextStyle( fontFamily:'NeoSansBold',fontSize:11,)),
                                      new FutureBuilder<String>(
                                        future: callApi.getDistance(
                                            '${geoNya.latitude},${geoNya.longitude}',
                                            '${_initialPosition.latitude},${_initialPosition.longitude}'), // async work
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasData) {
                                            //print(snapshot.data);
                                            return Text('${snapshot.data} km',
                                                style: TextStyle(
                                                  fontFamily: 'NeoSansBold',
                                                  fontSize: 11,
                                                ));
                                          } else if (snapshot.hasError)
                                            return Text('0 km',
                                                style: TextStyle(
                                                  fontFamily: 'NeoSansBold',
                                                  fontSize: 11,
                                                ));
                                          ;
                                          return Text('0 km',
                                              style: TextStyle(
                                                fontFamily: 'NeoSansBold',
                                                fontSize: 11,
                                              ));
                                          ;
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Buka: ${bukaOrtutup['buka']} - Tutup: ${bukaOrtutup['tutup']} ",
                                    style: TextStyle(
                                      letterSpacing: 0,
                                      fontSize: 12,
                                      color: bukaOrtutup['status'] == 'Buka'
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                  ),
                                  //gartis onkir
                                  snapshot.data[index].message == '0'
                                      ? SizedBox()
                                      : SizedBox(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.motorcycle,
                                                  size: 16.0,
                                                  color: Colors.orange),
                                              Expanded(
                                                child: Text(
                                                    '-Bebas biaya antar maksimal jarak ${snapshot.data[index].message} km',
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        letterSpacing: 0,
                                                        color: Colors.red)),
                                              )
                                            ],
                                          ),
                                        )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            titleCari,
            //  tagList,
            //_buildMenuTerlaris(),

            Expanded(
              child: boardView,
            ),
            itemPesanan == 0
                ? SizedBox(
                    height: 0,
                  )
                : SizedBox(
                    height: 55,
                  ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> navigateToEntryForm(
      BuildContext context, String panggilPage) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      if (panggilPage == 'CariMenu') {
        return CariMenu(
          dataP: widget.dataP,
        );
      } else if (panggilPage == 'SetLokasiPage') {
        return SetLokasiPage();
      }
      return CariMenu(
        dataP: widget.dataP,
      );
    }));
    return result;
  }

  Widget _buildMenuTerlaris() {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Text(  'KULINER',  style:   TextStyle(fontFamily: 'NeoSansBold'),   ),
          //Padding(  padding: EdgeInsets.only(top: 8.0),    ),
          Text(
            'Kuliner Terlaris',
            style: TextStyle(fontFamily: 'NeoSansBold'),
          ),
          SizedBox(
            height: 152.0,
            child: FutureBuilder<List>(
                future: fetchFoodLaris(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.only(top: 4.0),
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return _rowTerlaris(snapshot.data[index]);
                      },
                    );
                  }
                  return Center(
                    child: SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: const CircularProgressIndicator()),
                  );
                }),
          ),
          Text(
            'Pilih Restoran Favorit',
            style: TextStyle(fontFamily: 'NeoSansBold'),
          ),
        ],
      ),
    );
  }

  Future<List<Food<dynamic>>> fetchFoodLaris() async {
    var _terlarisList = <Food>[];
    var response = await CallApi().getData('terlaris_menu.php');
    // print(response.body);
    if (response.statusCode == 200) {
      // print(response.body);
      Iterable list = json.decode(response.body);
      _terlarisList = list.map((season) => Food.fromJson(season)).toList();
      return _terlarisList;
    }
    return _terlarisList;
  }

  Widget _rowTerlaris(Food food) {
    Map<String, dynamic> dataResto1 = {
      'dari_page': '',
      'laris': 'yes',
      'id_menu': food.idMenu,
      'img_menu': food.img_menu,
      'ket_menu': food.ketMenu,
      'nm_menu': food.nmMmenu,
      'hrg': food.hrg,
      'id_resto': food.idresto,
      'nm_resto': '',
      'ket_resto': '',
      'kat_onkir': '',
      'alamat_resto': '',
      'img': '',
      'jarak': 0,
      'bintang': 0,
      'divide_reputation': 0,
      'min_hrg': 0,
      'status': 'Tutup',
      'buka': '08:00',
      'tutup': '08:00',
      'posisi': GeoPoint(0.0, 0.0),
    };
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(right: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Restoran(
                      dataP: widget.dataP,
                      dataResto: dataResto1,
                    )),
          );
        },
        child: Container(
          // margin: EdgeInsets.only(right: 16.0),
          child: Column(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: food.img_menu,
                    fit: BoxFit.cover,
                    height: 110,
                    width: 120,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                  // Image.network(  food.image , width: 132.0,  height: 132.0,   ),
                  ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
              ),
              Text(
                food.nmMmenu.length >= 15
                    ? '${food.nmMmenu.substring(0, 15)}..'
                    : food.nmMmenu,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black, letterSpacing: 0,
                  // fontSize: 12
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getDocumentNearBy(double latitude, double longitude, double distance) {
    // ~1 mile of lat and lon in degrees
    var lat = 0.0144927536231884; //-3.479875 ;//
    var lon = 0.0181818181818182;

    ///119.14480830000002 ;//

    var lowerLat = latitude - (lat * distance);
    var lowerLon = longitude - (lon * distance);

    var greaterLat = latitude + (lat * distance);
    var greaterLon = longitude + (lon * distance);

    // var lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
    //var greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)

    //var docRef =Firestore.instance.collection('locations');
    //var query = docRef.whereField("location", isGreaterThan: lesserGeopoint).whereField("location", isLessThan: greaterGeopoint)
    /* query.getDocuments { snapshot, error in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            for document in snapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }*/

    //geo = Geoflutterfire();
    //var lesserGeopoint = geo.point(latitude: lowerLat, longitude: lowerLon);
    // var greaterGeopoint = geo.point(latitude: greaterLat, longitude: greaterLon);
    setState(() {
      lesserGeopoint = GeoPoint(lowerLat, lowerLon);
      greaterGeopoint = GeoPoint(greaterLat, greaterLon);
    });
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print('at the end of list');
      listRestoBloc.fetchNextMovies(lesserGeopoint, greaterGeopoint,
          _initialPosition.latitude, _initialPosition.longitude);
    }
  }

  void _showSheet() {
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
            expand: false,
            initialChildSize: 0.95,
            minChildSize: 0.0,
            maxChildSize: 0.95,
            builder: (_, controller) {
              // if (controller.hasClients) {
              //    var dimension = controller.position.viewportDimension;
              //if (dimension<=    200) {
              //   print(controller.position);
              // }
              //  }
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
                      color: Colors.blue[800],
                      child: CustomScrollView(
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
                              childCount: 10,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            });
      },
    );
  }

  //coba promosi
  Future<List<Promosi>> fetchRestoranPage() async {
    var response = await CallApi().getData('promotion.php');
    // print(response.body);
    if (response.statusCode == 200) {
      // print(response.body);
      Iterable list = json.decode(response.body);
      var promos = list.map((season) => Promosi.fromJson(season)).toList();
      return promos;
    }

    //else{
    //print('Error!!');
    // throw Exception('Failed to Load Post');
    // }
  }
}
