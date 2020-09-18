import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pelanggan/api/api.dart';
import 'package:pelanggan/layanan_page/gofood/map_lokasi.dart';
import 'package:pelanggan/layanan_page/gofood/restoran.dart';
import 'package:http/http.dart' as http;

import 'package:pelanggan/librariku/bintang.dart';

import '../../constans.dart';
import 'package:pelanggan/api/firestore_db.dart';

import 'bayar_food.dart';

class Keranjang extends StatefulWidget {
  Keranjang({Key key, this.dataP, this.idRestoPesanan, this.geoRestoPesanan})
      : super(key: key);
  final Map<String, dynamic> dataP;
  final String idRestoPesanan;
  final GeoPoint geoRestoPesanan;
  @override
  _KeranjangState createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  var uang = NumberFormat.currency(locale: 'ID', symbol: '', decimalDigits: 0);
  int awal = 0;
  var header = '';
  final databaseRef = Firestore.instance;
  final controllerKeterangan = TextEditingController();
  final controllerKetItem = TextEditingController();
  bool visibilityitemBayar = false;
  var idResoran = '';
  var itemPesanan = 0;
  var hargaPesanan = 0;
  var hargaOnkir = 0;
  var diskon = 0;
  var totalPrices = 0;
  String distanceValue = '0';
  int pointTransaction = 0;
  int charge = 0;
  bool provAktif1 = false;
  bool provAktif2 = false;
  //data Customer
  int saldoCustomer = 1111210;

  List<DocumentSnapshot> documentListTarif = List();
  ZulLib zulLib = ZulLib();
  Stream<dynamic> snapshotRestoPesanan;
  int hrgPengiriman = 0;
  var idRestoPesanan = '';
  GeoPoint geoRestoPesanan = GeoPoint(0.0, 0.0);
  static LatLng _positionResto = LatLng(0.0, 0.0);
  static LatLng _posisiUser = LatLng(0.0, 0.0);
  CrudMedthods crudObj = CrudMedthods();
  Map<String, dynamic> restoPesanan = {};
  var payCategories = 'tunai';
  String prov_1 = '';
  String prov_2 = '';

  @override
  void initState() {
    //pesanan keranjang
    crudObj.getFoodPesanan(widget.dataP['uid']).then((results) {
      if (mounted) {
        setState(() {
          snapshotRestoPesanan = results;
        });
      }
    });

    //harga tarif food
    /*crudObj.getTarif('food').then((results) {  
      if (mounted){ 
          setState(() {  
              documentListTarif=  results;  
          }); 
      } 
    }); */

    super.initState();

    controllerKeterangan.text = widget.dataP['ket_antar'];
    idRestoPesanan = widget.idRestoPesanan;
    geoRestoPesanan = widget.geoRestoPesanan;

    // _posisiUser = LatLng(widget.dataP['lat_antar'],widget.dataP['long_antar']);
    // print(widget.dataP['lat_antar']);
    //   print(geoRestoPesanan.latitude);
    _getRestoPesanan(idRestoPesanan);
    _getTarif();
  }

  //mengambil data code rute direction ke google maps
  //kemudian menghitung jarang tempuh dengan harga orderan
  Future<void> _getJsonDirectionGoogle() async {
    try {
      var origin = '${geoRestoPesanan.latitude},${geoRestoPesanan.longitude}';
      var destination =
          '${widget.dataP['lat_antar']},${widget.dataP['long_antar']}';
      //print(widget.dataP['lat_antar']);
      //  print('https://maps.googleapis.com/maps/api/directions/json?mode=driving&key=${CallApi.keyApi}&origin=$origin&destination=$destination');
      var dataPost = {
        'mode': 'driving',
        'key': CallApi.keyApi,
        'origin': origin,
        'destination': destination,
      };
      await http
          .post(
              Uri.encodeFull(
                  'https://maps.googleapis.com/maps/api/directions/json?mode=driving&key=${CallApi.keyApi}&origin=$origin&destination=$destination'),
              headers: {
                //if your api require key then pass your key here as well e.g 'key': 'my-long-key'
                'Accept': 'application/json'
              },
              body: json.encode(dataPost))
          .timeout(const Duration(seconds: 10))
          .then((onResponse) {
        //print(onResponse.body);
        //onResponse.request.finalize();
        if (onResponse.statusCode == 200) {
          var body = onResponse.body;
          var receivedJson = '[$body]';
          List data = json.decode(receivedJson);
          if (data[0]['status'] == 'OK') {
            //print(  data[0]['routes'][0]['legs'][0]['distance']['text']);
            print(data[0]['routes'][0]['legs'][0]['distance']['value']);
            //print(  data[0]['routes'][0]['legs'][0]['duration']['text']);
            // print(  data[0]['routes'][0]['legs'][0]['duration']['value']);
            //  print(  data[0]['routes'][0]['overview_polyline']['points'] );

            setState(() {
              // distanceText = data[0]['routes'][0]['legs'][0]['distance']['text'];
              distanceValue = data[0]['routes'][0]['legs'][0]['distance']
                      ['value']
                  .toString();
              // duration_text = data[0]['routes'][0]['legs'][0]['duration']['text'];
              // duration_value =data[0]['routes'][0]['legs'][0]['duration']['value'].toString();
              // polyline_order= data[0]['routes'][0]['overview_polyline']['points'];
              // _polylines.clear();
            });

            // List  data_steps =  data[0]['routes'][0]['legs'][0]['steps'];
            // data_steps.forEach((element) {
            //   print (element['polyline']['points']) ;
            //    _addPolyline(decodeEncodedPolyline( element['polyline']['points']));
            // });

            //_addPolyline(decodeEncodedPolyline( data[0]['routes'][0]['overview_polyline']['points']));

            //menyesuaikan lokasi  yg terjangkau
            /*var arrProv=[     
                      '91353', 
                      '90222', 
                      'SulawesiBarat91353', 
                      'SulawesiSelatan90222', 
                      'SulawesiBarat', 
                      'SulawesiSelatan', 
                      'SouthSulawesi' ,
                      'WestSulawesi' ,
               ]; 

                arrProv.forEach((element) { 
                  if(element==prov_1){
                     setState(() {
                        provAktif1=true; 
                      }); 
                  }
                  if(element==prov_2){
                      setState(() {
                       provAktif2=true;
                    });
                  }
                });*/

            //terlalu dekat dibawah 500 meter
            if (data[0]['routes'][0]['legs'][0]['distance']['value'] <= 300) {
              //  print('jarak terlalu deka');
              modeReadyToOrder(false,
                  'Harga tidak dapat ditampilkan, jarak terlalu dekat :) ');
            } else if (data[0]['routes'][0]['legs'][0]['distance']['value'] >=
                100000) {
              //print(' jarak terlalu jauh');
              modeReadyToOrder(false,
                  'Harga tidak dapat ditampilkan, jarak terlalu jauh, batas maksimal 100 km :) ');
            } //else if(provAktif1==false && provAktif2==false){
            //diluar kententuan lokasi
            //  print('provAktif1==false && provAktif2==false');
            //  ModeReadyToOrder(false,'Harga untuk di kota ini belum dapat ditampilkan :) ');
            // }
            else if (documentListTarif.isEmpty) {
              //print('documentListTarif.isEmpty');
              modeReadyToOrder(false,
                  'Harga tidak dapat ditampilkan, silahkan ulangi order :) ');
            } else {
              print('object1');
              //hitung Harga sebelum ke mode ready order
              modeReadyToOrder(true, '');
            }
          }
        } else {
          print('object2');
          // ModeReadyToOrder(false,'Harga tidak dapat ditampilkan, silahkan ulangi order :) ');
        }
      }).catchError((onerror) {
        print(onerror.toString());
        print('object3');
        modeReadyToOrder(
            false, 'Harga tidak dapat ditampilkan, silahkan ulangi order :) ');
      });
    } catch (e) {
      print('object4');
      modeReadyToOrder(
          false, 'Harga tidak dapat ditampilkan, silahkan ulangi order :) ');
      print('error!!!! $e');
    }
  }

  void modeReadyToOrder(bool loadHarga, String responGagalDirection) {
    if (loadHarga) {
      getOnkirFood();
    } else {
      setState(() {
        hargaOnkir = 0;
        visibilityitemBayar = false;
        totalPrices = (hargaPesanan + hargaOnkir) - diskon;
      });

      if (responGagalDirection == '') {
        responGagalDirection = 'Tidak dapat menampilkan harga..!';
      }
      _showGagalOrder('Opps apa yang salah.?', 'assets/images/promo_1.jpg',
          responGagalDirection);
    }
  }

  void getOnkirFood() {
    if (documentListTarif.isNotEmpty && mounted) {
      documentListTarif.forEach((element) {
        //konversi ke integr
        var distanceValueInt = int.parse(distanceValue);

        //mulai menghitung semu jenis harga
        //meter ke kilo meter bisa jadi terdapat koma
        //pembulatan meter ke km
        var kiloDariMeter = ((distanceValueInt + 1) ~/ 1000).round();

        var pricesRumus = 0;
        var totalRumus = 0;

        if (kiloDariMeter <= element.data['distance_looping_km']) {
          //dibawah jarak looping atau dibawah jarak standar yg ditetapkan pemerintah
          //atau dengan kata lain harga sesuai kondisi lokasi pasar atau pemukiman
          pricesRumus = element.data['price_per_km'] * kiloDariMeter;
        } else {
          //bulatkan ke bawah km berapa kali looping
          var berapaKaliLooping =
              (kiloDariMeter ~/ element.data['distance_looping_km']).floor();

          //harga hasil looping tergantung looping dan harga looping
          var hargaHasilLooping =
              element.data['price_looping_km'] * berapaKaliLooping;

          //mengambil sisa km
          var sisaKilometer =
              (kiloDariMeter / element.data['distance_looping_km']) -
                  berapaKaliLooping;

          //bulatakan ketas sisa km looping dikali harga per kilo
          var hargaSisaKilometer =
              (sisaKilometer).ceil() * element.data['price_per_km'];

          pricesRumus = hargaHasilLooping + hargaSisaKilometer;
        }

        if (payCategories == 'tunai') {
          totalRumus = (pricesRumus +
                  element.data['charge'] +
                  element.data['basic_price']) -
              element.data['discon_tunai'];
        }
        if (payCategories == 'saldo') {
          totalRumus = (pricesRumus +
                  element.data['charge'] +
                  element.data['basic_price']) -
              element.data['discon_saldo'];
        }

        pointTransaction = element.data['point_transaction'];
        charge = element.data['charge'];

        setState(() {
          visibilityitemBayar = true;
          hargaOnkir = totalRumus;
          totalPrices = (hargaPesanan + hargaOnkir) - diskon;
        });
      });
    } else {
      setState(() {
        hargaOnkir = 0;
        visibilityitemBayar = false;
        totalPrices = (hargaPesanan + hargaOnkir) - diskon;
      });
    }
  }

  Future<void> _getTarif() async {
    crudObj.getTarif('food').then((results) {
      if (mounted) {
        setState(() {
          documentListTarif = results;
        });
      }
    }).whenComplete(() {
      _getJsonDirectionGoogle();
    });
  }

  Future<void> _getRestoPesanan(String idResto) async {
    crudObj.getRestoById(idResto).then((results) {
      DocumentReference aa = results;
      aa.get().then((value) {
        var bukaOrtutup = zulLib.bukaOrtutup(value.data['buka']);
        print('00000000');
        // print(zulLib.getDistansDirectionGoogle());
        setState(() {
          restoPesanan['id_resto'] = value.documentID;
          restoPesanan['nm_resto'] = value.data['nm_resto'];
          restoPesanan['ket_resto'] = value.data['ket_resto'];
          restoPesanan['alamat_resto'] = value.data['alamat_resto'];
          restoPesanan['img'] = value.data['img'];
          restoPesanan['kat_onkir'] = value.data['kat_onkir'];
          restoPesanan['jarak'] = zulLib.calculateDistance(value.data['posisi'],
              LatLng(widget.dataP['lat_antar'], widget.dataP['long_antar']));
          restoPesanan['bintang'] = zulLib.bintang(
              value.data['counter_reputation'],
              value.data['divide_reputation']);
          restoPesanan['divide_reputation'] = value.data['divide_reputation'];
          restoPesanan['min_hrg'] = value.data['min_hrg'];
          restoPesanan['status'] = bukaOrtutup['status'];
          restoPesanan['buka'] = bukaOrtutup['tutup'];
          restoPesanan['tutup'] = bukaOrtutup['tutup'];
          restoPesanan['posisi'] = geoRestoPesanan;
        });
        print('0000000022222222');
      });
    }).catchError((err) {
      print('0000000022222222');
    });
  }

  void setKetItem(String ketItem, String idItem) {
    if (ketItem.length < 240) {
      databaseRef
          .collection('flutter_keranjang')
          .document(widget.dataP['uid'])
          .collection('food')
          //.where('field',isEqualTo: '');
          .document(idItem)
          .updateData({
        'item_ket': ketItem,
      }).whenComplete(() {
        //  _hitungHarga();
      }).catchError((err) {
        print('catchError');
      });
    }
  }

  void setQity(int numQity, String idItem) {
    if (numQity > 0) {
      databaseRef
          .collection('flutter_keranjang')
          .document(widget.dataP['uid'])
          .collection('food')
          //.where('field',isEqualTo: '');
          .document(idItem)
          .updateData({
        'qity': numQity,
      }).whenComplete(() {
        //  _hitungHarga();
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
        if (itemPesanan == 0 && mounted) {
          Navigator.pop(context);
        }
        //_hitungHarga();
      }).catchError((err) {
        print('catchError');
      });
    }
  }

  void _hitungHargaTotal() {
    snapshotRestoPesanan.listen((snapshot) {
      var total = 0;
      var items = 0;
      var visibilityitem = false;
      var idRestoPesananNya = '';
      GeoPoint geoRestoPesananNya = GeoPoint(0.0, 0.0);
      snapshot.documents.forEach((element) {
        total = total + (element.data['hrg'] * element.data['qity']);
        items = items + element.data['qity'];
        visibilityitem = true;
        idRestoPesananNya = element.data['id_resto'];
        geoRestoPesananNya = element.data['posisi'];
      });
      if (mounted) {
        setState(() {
          idRestoPesanan = idRestoPesananNya;
          geoRestoPesanan = geoRestoPesananNya;
          visibilityitemBayar = visibilityitem;
          hargaPesanan = total;
          totalPrices = (hargaPesanan + hargaOnkir) - diskon;
          itemPesanan = items;
        });
      }
    });
  }

  void setModeBayar(String modeBayar) {
    if (payCategories != modeBayar &&
        int.parse(distanceValue) >= 300 &&
        int.parse(distanceValue) <= 100000) {
      if (modeBayar == 'saldo') {
        // setState(() {
        //   payCategories=modeBayar;
        //});
        // _hitungHargaTotal();
        if (saldoCustomer >= totalPrices) {
          setState(() {
            payCategories = modeBayar;
          });
        } else {
          setState(() {
            payCategories = 'tunai';
          });
        }
      } else {
        setState(() {
          payCategories = modeBayar;
        });
      }
      _hitungHargaTotal();
    }
  }

  void postBayar() {}

  @override
  Widget build(BuildContext context) {
    if (snapshotRestoPesanan != null && mounted) {
      _hitungHargaTotal();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Keranjang',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: double.maxFinite,
        child: Stack(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                //lokasi
                Container(
                  padding: EdgeInsets.only(
                      left: 6.0, right: 6.0, top: 16.0, bottom: 1),
                  child: Text(
                    'Antar ke',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'NeoSans',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                    ),
                  ),
                ),

                //keterangan lokasi
                Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 3.0),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () async {
                            var dataLokasi = await navigateToEntryForm(
                                context, 'SetLokasiPage');

                            if (dataLokasi != null) {
                              controllerKeterangan.text = dataLokasi['ket'];
                              setState(() {
                                //_initialPosition =LatLng(dataLokasi['lat'], dataLokasi['long']);
                                widget.dataP['adress_antar'] =
                                    dataLokasi['address'];
                                widget.dataP['lat_antar'] = dataLokasi['lat'];
                                widget.dataP['long_antar'] = dataLokasi['long'];
                                widget.dataP['ket_antar'] = dataLokasi['ket'];
                              });

                              _getTarif();
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 1.0),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${widget.dataP['adress_antar']}',
                                      maxLines: 3,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontFamily: 'NeoSans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.search,
                                  size: 16.0, color: Colors.grey),
                            ],
                          ),
                        ),
                        Container(
                          //padding:   EdgeInsets.symmetric(vertical: 1.0, horizontal: 0.0),
                          //margin:   EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                          decoration: BoxDecoration(
                            color: GojekPalette.grey200,
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.3,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 0),
                                child: Icon(Icons.message,
                                    size: 24.0, color: Colors.green),
                              ),
                              Expanded(
                                child: TextField(
                                  maxLines: 1,
                                  controller: controllerKeterangan,
                                  style: TextStyle(
                                    fontFamily: 'NeoSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0,
                                  ),
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.go,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      hintText: 'Tambahkan Rincian alamat...'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ],
                    )),
                Divider(
                  height: 16,
                  color: Colors.grey[200],
                  thickness: 12.0,
                ),

                //mode bayar
                Container(
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                  child: Text(
                    'Metode Pembayaran',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'NeoSans',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    _showModeBayar();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.monetization_on,
                          size: 30.0, color: Colors.green),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              payCategories == 'tunai'
                                  ? 'BAYAR TUNAI KE DRIVER '
                                  : 'BAYAR PAKAI SALDO',
                              softWrap: true,
                              style: TextStyle(
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Icon(Icons.more_vert, size: 24.0, color: Colors.grey),
                    ],
                  ),
                ),
                Divider(
                  height: 16,
                  color: Colors.grey[200],
                  thickness: 12.0,
                ),

                //header pesanan dan tombol tambah
                Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 3.0),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Daftar Pesanan',
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'NeoSans',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        OutlineButton(
                            child: Text('Tambah',
                                style: TextStyle(
                                  color: Colors.black,
                                  wordSpacing: 0,
                                  decoration: TextDecoration.none,
                                )),
                            onPressed: () async {
                              restoPesanan['laris'] = '';
                              restoPesanan['dari_page'] = 'keranjang';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Restoran(
                                          dataP: widget.dataP,
                                          dataResto: restoPesanan,
                                        )),
                              );
                            },
                            borderSide: BorderSide(color: Colors.green),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                      ],
                    )),

                // nama restoran
                Container(
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                  child: Text(
                    '${restoPesanan['nm_resto']}',
                    maxLines: 3,
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: 'NeoSans',
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                Divider(height: 10),

                //item
                Container(
                    // padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 0.0),
                    color: Colors.white,
                    child: _keranjangList()),
                Divider(
                  height: 16,
                  color: Colors.grey[200],
                  thickness: 12.0,
                ),

                //Rincian Harga
                Container(
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                  child: Text(
                    'Rincian Harga',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'NeoSans',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total harga kuliner  ',
                        ),
                        Text('Rp$hargaPesanan'),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ongkos antar  ',
                        ),
                        Text('Rp$hargaOnkir'),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Diskon  ',
                        ),
                        Text('Rp$diskon'),
                      ],
                    )),
                Divider(
                  height: 16,
                  color: Colors.grey[200],
                  thickness: 12.0,
                ),
                SizedBox(
                  height: 90,
                )
              ],
            ),

            //tempat tombol bayar dan harga total belajaan
            Visibility(
                visible: visibilityitemBayar,
                child: Positioned(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.3,
                        ),
                        //  borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 3.0, bottom: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Total Pembayaran',
                                      style: TextStyle(
                                        letterSpacing: 0,
                                        decoration: TextDecoration.none,
                                      )),
                                  Text('Rp${uang.format(totalPrices)}',
                                      style: TextStyle(
                                        letterSpacing: 0,
                                        // color: Colors.orange[800],
                                        decoration: TextDecoration.none,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  if (restoPesanan['status'] == 'Buka') {
                                    showDialogBayar();
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => BayarFood( dataP: widget.dataP, restoPesanan: restoPesanan,)),  );
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
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Colors.orange[900], elevation: 0,
                                // padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0),
                                child: Text(
                                    itemPesanan == 0
                                        ? 'Bayar'
                                        : 'Bayar $payCategories ($itemPesanan)',
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                    )),
                              ),
                            )
                          ]),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> navigateToEntryForm(
      BuildContext context, String panggilPage) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return SetLokasiPage();
    }));

    return result;
  }

  Widget _keranjangList() {
    if (snapshotRestoPesanan != null) {
      return StreamBuilder(
        stream: snapshotRestoPesanan,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return (Center(child: CircularProgressIndicator()));
          } else {
            return ListView.builder(
              //separatorBuilder: (BuildContext context, int index) {
              //     return Divider(height: 6 );
              // },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.documents.length,
              //padding: EdgeInsets.all(5.0),
              itemBuilder: (context, i) {
                return _rowKerangjang(snapshot.data.documents[i]);
              },
            );
          }
        },
      );
    } else {
      return Text('Loading, Please wait..');
    }
  }

  Widget _rowKerangjang(DocumentSnapshot queueDoc) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () async {
          controllerKetItem.text = queueDoc['item_ket'];
          _showEditKet({
            'id_resto': queueDoc['id_resto'],
            'id_menu': queueDoc.documentID,
            'img_menu': queueDoc['img_menu'],
            'ket_menu': queueDoc['ket_menu'],
            'item_ket': queueDoc['item_ket'],
            'nm_menu': queueDoc['nm_menu'],
            'hrg': queueDoc['hrg'],
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: CachedNetworkImage(
                  imageUrl: queueDoc['img_menu'],
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
            Expanded(
              //width: 250,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //nama menu
                    Text(queueDoc.data['nm_menu'],
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                          color: Colors.black,
                          fontFamily: 'NeoSans',
                          fontSize: 16,
                        )),
                    //sub total
                    Text(
                        'Rp${uang.format(queueDoc.data['hrg'] * queueDoc.data['qity'])}',
                        style: TextStyle(
                          letterSpacing: 0,
                          color: Colors.orange[800],
                          fontFamily: 'NeoSans',
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        )),
                    //text  ket item
                    Text('${queueDoc.data['item_ket']}',
                        maxLines: 3,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                          color: Colors.grey,
                          fontFamily: 'NeoSans',
                          fontSize: 11,
                        )),
                    //edit ket
                    Row(
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
                                  setQity(0, queueDoc.documentID);
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
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          awal = queueDoc.data['qity'] - 1;
                                        });
                                        setQity(awal, queueDoc.documentID);
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
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 8),
                                    width: 40, height: 34,
                                    child: Text(
                                      '${queueDoc.data['qity']}',
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
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          awal = queueDoc.data['qity'] + 1;
                                        });
                                        setQity(awal, queueDoc.documentID);
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
                        ]),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //dialog _showEditKet
  void _showEditKet(Map<String, dynamic> dataMenu) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'Rincian catatan pesanan',
                      style: TextStyle(
                        fontFamily: 'NeoSans',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            child: CachedNetworkImage(
                              imageUrl: dataMenu['img_menu'],
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(dataMenu['nm_menu'],
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0,
                                      fontFamily: 'NeoSans',
                                    )),
                                Text(
                                  dataMenu['ket_menu'],
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(3.0),
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: GojekPalette.grey200,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 2,
                      autofocus: true,
                      controller: controllerKetItem,
                      cursorColor: Colors.black,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          hintText:
                              'Contoh: jangan terlalu manis, jangan terlalu pedis...'),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          top: 6,
                          left: 6.0,
                          right: 6.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setKetItem(
                                controllerKetItem.text, dataMenu['id_menu']);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.green,
                          elevation: 0,
                          // padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0),
                          child: Text('Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              )),
                        ),
                      )),
                  SizedBox(height: 10),
                ],
              ),
            ));
  }

  //dialog pilih metodebayar
  void _showModeBayar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 4,
      isDismissible: true,
      //useRootNavigator: useRootNavigator,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          height: 200,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                )
              ]),
          child: ListView(
            children: <Widget>[
              Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              //SizedBox( height: 10.0, ),
              Divider(
                color: Colors.grey,
                height: 5,
              ),
              RaisedButton(
                onPressed: () {
                  setModeBayar('tunai');
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.monetization_on,
                        size: 30.0, color: Colors.green),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'TUNAI',
                            style: TextStyle(
                              fontFamily: 'NeoSans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //Icon(  Icons.more_vert ,  size: 24.0, color: Colors.grey ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 5,
              ),
              RaisedButton(
                onPressed: () {
                  setModeBayar('saldo');
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.local_atm, size: 30.0, color: Colors.green),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'SALDO',
                            style: TextStyle(
                              fontFamily: 'NeoSans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text('Rp ${uang.format(saldoCustomer)} ')
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //dialog pesan gagal harga dan gagal order
  void _showGagalOrder(String _titlenya, String _img, String _Message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        // return  StatefulBuilder(builder: (c, s) {
        //  return  SafeArea(
        //child:
        return Container(
          // height: 650,
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                )
              ]),
          child: Column(children: <Widget>[
            // Icon( Icons.drag_handle,  color: GojekPalette.grey,  ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Icon( Icons.close,  color: GojekPalette.grey,size: 16,  ),
                Text(
                  '$_titlenya',
                  style: TextStyle(fontFamily: 'NeoSansBold', fontSize: 18.0),
                ),
                OutlineButton(
                  color: GojekPalette.green,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'TUTUP',
                    style: TextStyle(fontSize: 12.0, color: GojekPalette.green),
                  ),
                ),
              ],
            ),
            Image.asset(
              '$_img',
              height: 250.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              '$_Message',
              style: TextStyle(
                fontFamily: 'NeoSans',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                letterSpacing: 0,
              ),
            ),
            /*OutlineButton(
                    color: GojekPalette.green,
                    onPressed: () {  Navigator.pop(context);},
                    child:  Text(
                      'TUTUP',
                      style:
                          TextStyle(fontSize: 12.0, color: GojekPalette.green),
                    ),
               ),*/
          ]),
        );
        // );
        // }
        ///);
      },
    );
  }

  //selesaikan pesanan dengan bayar
  void showDialogBayar() {
    //
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
        postBayar();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Selesaikan pesanan"),
      content: Text("Anda yakin ingin membayar pesanan ini?"),
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
  }
}
