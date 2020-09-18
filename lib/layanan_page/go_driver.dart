import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pelanggan/api/api.dart';
import 'package:pelanggan/layanan_page/chat.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pelanggan/model/class_model.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constans.dart';
import 'package:pelanggan/librariku/shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login.dart';

class GoDriverPage extends StatelessWidget {
  GoDriverPage({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GoDriver(
        key: key,
        dataP: dataP,
      ),
    );
  }
}

class GoDriver extends StatefulWidget {
  GoDriver({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  GoDriverState createState() => GoDriverState();
}

class GoDriverState extends State<GoDriver> with AutomaticKeepAliveClientMixin {
  // with AutomaticKeepAliveClientMixin  untuk keep alive

  //GoDriverState({
  //  Key key,
  //});
  GoDriverState() {
    //print("GoDriverState GoDriverState GoDriverState ");
    platform1.setMethodCallHandler((call) {
      ///print("setMethodCallHandler ${call.method}");
      if (call.method == 'gcm_masuk') {
        //print('aaaaaaaaaaaaaaaaaa ${call.arguments.cast<String, dynamic>()}');
        setAcceptOrder(call.arguments);
        //accept_order
      } else {}
      return;
    });
  }

  static const platform1 = MethodChannel('ada_pesan_masuk');
  var uang = NumberFormat.currency(locale: 'ID', symbol: '', decimalDigits: 0);

  String namaCustomer = '';
  String uidCustomer = '';
  int saldoCustomer = 0;
  int pointCustomer = 0;
  int radiusCustomer = 60;
  String hpCustomer = '';
  String tripCustomer = '0';
  String bintangCustomer = '0';
  String avatarCustomer = '0';
  String bearToken = '';
  String gcmToken = '';

  //var text keterangan
  final controllerKeterangan = TextEditingController();
  //cari alamat pakai text
  final cariController = TextEditingController();
  // List<String> drivers_gcm = [];
  HashMap data_order_filter = HashMap<dynamic, dynamic>();
  //var divider
  Timer _timer;

  final PanelController _pc = PanelController();
  //map
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  static LatLng _initialPosition = LatLng(0.0, 0.0);
  static LatLng _lastMapPosition = LatLng(0.0, 0.0);

  //map direction
  //int _polylineCount = 1;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  //final Set<Marker> _markers = {};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> markers_order = <MarkerId, Marker>{};

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Geoflutterfire geo;
  BitmapDescriptor customIcon;

  //membuat respon google
  //Response _responseGoogle;
  //Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];
  //pencarian tempat
  List<dynamic> _placePredictions = [];

  //variabel data kusioner
  //Default Radio Button Item kusioner
  // String radioItem = 'Saya telah menunggu terlalu lama';
  // int id_pilihan_kusioner = 1;
  List<KusionersList> fList = [
    KusionersList(
      index: 1,
      name: 'Saya telah menunggu terlalu lama',
    ),
    KusionersList(
      index: 2,
      name: 'Lokasi driver terlalu jauh',
    ),
    KusionersList(
      index: 3,
      name: 'Driver tidak bisa dihubungi',
    ),
    KusionersList(
      index: 4,
      name: 'Driver meminta dibatalkan',
    ),
    KusionersList(
      index: 5,
      name: 'Alasan lain',
    ),
  ];

  //notifier
  final _channgeMode = ChanngeModeLoadingAdress();

  //untuk keep alive
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _channgeMode.dispose();
    controllerKeterangan.dispose();
    cariController.dispose();

    //
    // mapController = null;
    // mapController.dispose();
    if (_timer != null) _timer.cancel();
    patterns = null;
    uang = null;
    geo = null;
    fList = null;
    _placePredictions = null;
    _polylines = null; /**/

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //meload asset image ke BitmapDescriptor
    //_createMarkerImageFromAsset('assets/motor.png');

    //cek internet
    //_cekInternet();

    //regiter chanel resume app untuk membuka kembali jika ada pesan masuk
    _initChanel();

    //tampilan mode pertama dibuka
    //_channgeModeLoadingAdress._modeFirstOpen(documentListTarif);

    //meload data harga driver dari server sejak awal agar tidak meload berulang kali
    _getPosisiUserAwal();
    //mengambil posisi driver untuk untuk map
    //sekalgus menjadikan variabel tersebut sebagai broadcast untuk gcm permintaan order
    //getDriverPosisi();
  }

  //memeriksa gps sekaligus mengambil harga
  Future<void> _getPosisiUserAwal() async {
    if (!await Geolocator().isLocationServiceEnabled()) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialogSettingOrLogin("", "Tidak dapat menampilkan lokasi",
            "Pastikan GPS ON kemudain coba lagi");
      } else {}
    } else {
      selectDaftarHarga();
      _getUserLocation();
    }
  }

  //mengabil data semua daftar harga tarif
  void selectDaftarHarga() async {
    var response = await CallApi().getData(
        'getalldriverprice?page=1&limit=10&verification=0&verification=0&struck=no');
    //print(response.body);
    if (response.statusCode == 200) {
      // print(response.body);
      var body = json.decode(response.body);
      // print(response.body);
      Iterable list = body['data'];
      _channgeMode.documentListTarif(
          list.map((season) => DriverPrice.fromJson(season)).toList());
    } else if (response.statusCode == 401) {
      showDialogSettingOrLogin("login", "Silahkan Login.?",
          "Silahkan login untuk melakukan transaksi");
      _channgeMode.documentListTarif([]);
    } else {
      _channgeMode.documentListTarif([]);
    }
  }

  void showDialogSettingOrLogin(String by, String title, String msg) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    if (by == "login") {
                      Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      //  Navigator.of(context, rootNavigator: true).pop();
                      Navigator.pop(context);
                      AppSettings.openLocationSettings();
                    }

                    //  Navigator.of(context, rootNavigator: true).pop();
                    // Navigator.pop(context);
                  })
            ],
          );
        }).whenComplete(() {
      if (by == "login") {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    from: "ojek",
                  )),
        );
      } else {}
    });
  }

  //inisialisasi chanel resume
  Future<String> _initChanel() async {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      print(
          'SystemChannels modempa=${_channgeMode.modeMap}  dan setMessageHandler=  $msg');
      if (msg.contains('resumed')) {
        if (_channgeMode.modeMap == 3) {
        } else {}

        _getPosisiUserAwal();
        //_channgeMode._modeFirstOpen(documentListTarif);
        return '';
      }
      return '';
    });

    return '';
  }

  //mendapatkan lattitude posisi user
  //mengambil varibel posisi
  void _getUserLocation() {
    print(' _getUserLocation()');
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$_lastMapPosition");
      //if (_channgeMode.modeMap == 99) {
      // setState(() {
      //  _initialPosition = LatLng(position.latitude, position.longitude);
      // _lastMapPosition = LatLng(position.latitude, position.longitude);
      // });
      // _channgeMode._setModeMap(0);
      // _getUserLocation();
      // } else {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        //_lastMapPosition = LatLng(position.latitude, position.longitude);
      });
      _moveToPosition(_initialPosition);
      //}
    }).catchError((e) {
      print(e);
      _showGagalOrder('Opps apa yang salah.?', 'assets/images/promo_1.jpg',
          "Tidak dapat menampilkan lokasi pastikan GPS aktif.");
    });
  }

  //perintah mengarahkan camera maps ke posisi tertentu
  //void _moveToPosition(LatLng pos) async {
  Future<void> _moveToPosition(LatLng pos) async {
    // if (mapController == null) {
    // mapController = await _controller.future;
    // }

    // print('moving to position1 ${pos.latitude}, ${pos.longitude}');
    if (mapController == null) return;

    await mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 16.0,
      // bearing: -20,
    )));
  }

  //digunakan untuk mendapatkan alama center map atau center marker
  //dan mengambil data variabel alamat
  //kemudian dikonversi ke alamat jemput atau tujuan
  void _getAdressLocation() async {
    print(' _getAdressLocation() $_lastMapPosition');
    /*
    pengambilan data alamat pada server google maps
    berdasarkan posisi tengah maps atau marker yg berada di tengah
  
    1. hasil alamatnya akan dimasukkan ke variabel jemput atau tujuan
    
    */

    try {
      var placemark = await Geolocator().placemarkFromCoordinates(
          _lastMapPosition.latitude, _lastMapPosition.longitude);
      var placeMark = placemark[0];
      var name = placeMark.name;
      var subLocality = placeMark.subLocality;
      var locality = placeMark.locality;
      var administrativeArea = placeMark.administrativeArea;
      var postalCode = placeMark.postalCode;
      var country = placeMark.country;
      var address =
          '$name, $subLocality, $locality, $administrativeArea $postalCode, $country';

      _channgeMode._setAdressLocation(_channgeMode.modeMap, placeMark.name,
          address, _lastMapPosition, placeMark.administrativeArea);
    } catch (e) {
      print('_getAdressLocation ERRORku>>  :$e');
      _showGagalOrder('Opps apa yang salah.?', 'assets/images/promo_1.jpg',
          "Tidak dapat menampilkan alamat lokasi.");
    }
  }

  //mendasain jalur dari titik jemput ke titik tujuan
  void _addPolyline(List<LatLng> _coordinates) {
    var id = PolylineId('poly$_coordinates');
    var polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates,
        width: 7,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
      markers_order.clear();
      var _markerJemput = Marker(
        markerId: MarkerId(_channgeMode.jemputPosition.toString()),
        position: _channgeMode.jemputPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
            title: 'Lokasi Jemput', snippet: '${_channgeMode.jemputAlamat}'),
      );

      var _markerTujuan = Marker(
        markerId: MarkerId(_channgeMode.tujuanPosition.toString()),
        position: _channgeMode.tujuanPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
            title: 'Lokasi Tujuan', snippet: '${_channgeMode.tujuanAlamat}'),
      );

      markers_order[MarkerId(_channgeMode.jemputPosition.toString())] =
          _markerJemput;
      markers_order[MarkerId(_channgeMode.tujuanPosition.toString())] =
          _markerTujuan;
      //_polylineCount++;
    });

    var latMin = 0.0;
    var latMax = 0.0;
    var longMin = 0.0;
    var longMax = 0.0;

    if (_channgeMode.jemputPosition.latitude >=
        _channgeMode.tujuanPosition.latitude) {
      latMin = _channgeMode.tujuanPosition.latitude;
      latMax = _channgeMode.jemputPosition.latitude;
      longMin = _channgeMode.tujuanPosition.longitude;
      longMax = _channgeMode.jemputPosition.longitude;

      if (longMin >= longMax) {
        longMin = _channgeMode.jemputPosition.longitude;
        longMax = _channgeMode.tujuanPosition.longitude;
      }
    } else {
      latMin = _channgeMode.jemputPosition.latitude;
      latMax = _channgeMode.tujuanPosition.latitude;

      longMin = _channgeMode.tujuanPosition.longitude;
      longMax = _channgeMode.jemputPosition.longitude;

      if (longMin >= longMax) {
        longMin = _channgeMode.jemputPosition.longitude;
        longMax = _channgeMode.tujuanPosition.longitude;
      }
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
          southwest: LatLng(latMin, longMin),
          northeast: LatLng(latMax, longMax)),
      50.0,
    ));
    print('setelah kamera');
  }

  //mendecode data direction dari google menjadi sebuat lattitude
  List<LatLng> decodeEncodedPolyline(String encoded) {
    var poly = <LatLng>[];
    var index = 0, len = encoded.length;
    var lat = 0, lng = 0;

    while (index < len) {
      var b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      var dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      var dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      var p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  //mengambil data code rute direction ke google maps
  //kemudian menghitung jarang tempuh dengan harga orderan
  Future<void> getJsonDirectionGoogle() async {
    try {
      var origin =
          '${_channgeMode.jemputPosition.latitude},${_channgeMode.jemputPosition.longitude}';
      var destination =
          '${_channgeMode.tujuanPosition.latitude},${_channgeMode.tujuanPosition.longitude}';

      var data_post = {
        'mode': 'driving',
        'key': CallApi.keyApi,
        'origin': origin,
        'destination': destination,
      };
      print(
          'https://maps.googleapis.com/maps/api/directions/json?mode=driving&key=${CallApi.keyApi}&origin=$origin&destination=$destination');
      await http
          .post(
              //Uri.encodeFull removes all the dashes or extra characters present in our Uri
              Uri.encodeFull(
                  'https://maps.googleapis.com/maps/api/directions/json?mode=driving&key=${CallApi.keyApi}&origin=$origin&destination=$destination'),
              headers: {
                //if your api require key then pass your key here as well e.g 'key': 'my-long-key'
                'Accept': 'application/json'
              },
              body: json.encode(data_post))
          .timeout(const Duration(seconds: 120))
          // .whenComplete(() => null)
          .then((onResponse) {
        //print(onResponse.body);
        // print(onResponse.statusCode);
        //onResponse.request.finalize();
        if (onResponse.statusCode == 200) {
          var body = onResponse.body;
          var receivedJson = '[$body]';
          List data = json.decode(receivedJson);
          if (data[0]['status'] == 'OK') {
            //print(  data[0]['routes'][0]['legs'][0]['distance']['text']);
            // print(  data[0]['routes'][0]['legs'][0]['distance']['value']);
            //print(  data[0]['routes'][0]['legs'][0]['duration']['text']);
            // print(  data[0]['routes'][0]['legs'][0]['duration']['value']);
            // print(  data[0]['routes'][0]['overview_polyline']['points'] );

            /* setState(() {
              distanceText =
                  data[0]['routes'][0]['legs'][0]['distance']['text'];
              distanceValue = data[0]['routes'][0]['legs'][0]['distance']
                      ['value']
                  .toString();
              duration_text =
                  data[0]['routes'][0]['legs'][0]['duration']['text'];
              duration_value = data[0]['routes'][0]['legs'][0]['duration']
                      ['value']
                  .toString();
              polyline_order =
                  data[0]['routes'][0]['overview_polyline']['points'];
            
            });*/
            _polylines.clear();
            // List  data_steps =  data[0]['routes'][0]['legs'][0]['steps'];
            // data_steps.forEach((element) {
            //   print (element['polyline']['points']) ;
            //    _addPolyline(decodeEncodedPolyline( element['polyline']['points']));
            // });

            _addPolyline(decodeEncodedPolyline(
                data[0]['routes'][0]['overview_polyline']['points']));

            //menyesuaikan lokasi  yg terjangkau
            var arrProv = [
              '91353',
              //'90222',
              'SulawesiBarat91353',
              //  'SulawesiSelatan90222',
              'SulawesiBarat',
              // 'SulawesiSelatan',
              //  'SouthSulawesi',
              'WestSulawesi',
            ];

            bool provAktif1 = false;
            bool provAktif2 = false;

            arrProv.forEach((element) {
              if (element == _channgeMode.prov_1) {
                provAktif1 = true;
              }
              if (element == _channgeMode.prov_2) {
                provAktif2 = true;
              }
            });

            // print(data[0]['routes'][0]['legs'][0]['distance']['value']);
            //terlalu dekat dibawah 500 meter
            if (data[0]['routes'][0]['legs'][0]['distance']['value'] <= 300) {
              print('object44');
              _showGagalOrder(
                  'Opps apa yang salah.?',
                  'assets/images/promo_1.jpg',
                  'Harga tidak dapat ditampilkan, jarak terlalu dekat :) ');
              _channgeMode._modeReadyToOrder(
                  false,
                  "${data[0]['routes'][0]['legs'][0]['distance']['text']}Km",
                  0);
            } else if (data[0]['routes'][0]['legs'][0]['distance']['value'] >=
                100000) {
              print('object33');
              _showGagalOrder(
                  'Opps apa yang salah.?',
                  'assets/images/promo_1.jpg',
                  'Harga tidak dapat ditampilkan, jarak terlalu jauh, batas maksimal 100 km :) ');
              _channgeMode._modeReadyToOrder(
                  false,
                  "${data[0]['routes'][0]['legs'][0]['distance']['text']}Km",
                  0);
            } else if (provAktif1 == false && provAktif2 == false) {
              //diluar kententuan lokasi
              print('object22');
              _showGagalOrder(
                  'Opps apa yang salah.?',
                  'assets/images/promo_1.jpg',
                  'Harga untuk di kota ini belum dapat ditampilkan :) ');
              _channgeMode._modeReadyToOrder(
                  false,
                  "${data[0]['routes'][0]['legs'][0]['distance']['text']}Km",
                  0);
            } else if (_channgeMode.listTarif.length == 0) {
              print('object11');
              selectDaftarHarga();
              /*_showGagalOrder(
                  'Opps apa yang salah.?',
                  'assets/images/promo_1.jpg',
                  'Harga tidak dapat ditampilkan, silahkan ulangi order :) ');
              _channgeMode._modeReadyToOrder(
                  false,
                  'Harga tidak dapat ditampilkan, silahkan ulangi order :) ',
                  "${distanceText}Km",
                  0);*/
            } else {
              print('object1');
              //hitung Harga sebelum ke mode ready order
              if (_channgeMode.listTarif.length != 0) {
                _channgeMode._hitungHargaTotal(
                    data[0]['routes'][0]['legs'][0]['distance']['text'],
                    data[0]['routes'][0]['legs'][0]['distance']['value'],
                    data[0]['routes'][0]['legs'][0]['duration']['text'],
                    data[0]['routes'][0]['legs'][0]['duration']['value']);
              } else {
                _channgeMode._modeReadyToOrder(
                    false,
                    "${data[0]['routes'][0]['legs'][0]['distance']['text']}",
                    0);
              }
            }
          } else {
            // _pc.show();
            // _pc.open();
            print('object00');
            _showGagalOrder(
                'Opps apa yang salah.?',
                'assets/images/promo_1.jpg',
                'Harga untuk di kota ini belum dapat ditampilkan :) ');
            _channgeMode._modeReadyToOrder(false, '0Km', 0);
          }
        } else {
          print('object2');
          _showGagalOrder('Opps apa yang salah.?', 'assets/images/promo_1.jpg',
              'Harga untuk di kota ini belum dapat ditampilkan :) ');
          _channgeMode._modeReadyToOrder(false, '0Km', 0);
        }
      }).catchError((onerror) {
        print(onerror.toString());

        print('object3');
        _showGagalOrder('Opps apa yang salah.?', 'assets/images/promo_1.jpg',
            'Harga untuk di kota ini belum dapat ditampilkan :) ');
        _channgeMode._modeReadyToOrder(false, '0Km', 0);
      });
    } catch (e) {
      print('object4');
      _showGagalOrder('Opps apa yang salah.?', 'assets/images/promo_1.jpg',
          'Harga untuk di kota ini belum dapat ditampilkan :) ');
      _channgeMode._modeReadyToOrder(false, '0Km', 0);
      print('error!!!! $e');
    }
  }

  //mengambil posisi driver untuk untuk map
  //sekalgus menjadikan variabel tersebut sebagai broadcast untuk gcm permintaan order
  void getDriverPosisi() {
    /*geo = Geoflutterfire(); 
    var center = geo.point(latitude:_initialPosition.latitude,longitude:_initialPosition.longitude); 
    var collectionReference = databaseRef.collection('flutter_driver')
    .where('status_driver' ,isEqualTo: 'siap' ) 
    .where('blok' ,isEqualTo: false )
    //.orderBy('trip') 
    .limit(20) ; 
  
    stream = geo.collection(collectionRef: collectionReference)   .within(center: center, radius: radiusCustomer.toDouble(), field: 'position', strictMode: true);
 
    setState(() { 
       stream.listen((List<DocumentSnapshot> documentListDriver) {
         print('blokblokblokblokblokblokblokblokblokblokblokblok');
         _updateMarkers(documentListDriver);
      });
    }); */
  }

  void _updateMarkers(List<DocumentSnapshot> documentListDriver) {
    //drivers_gcm.clear();
    markers.clear();

    documentListDriver.forEach((DocumentSnapshot document) {
      GeoPoint point = document.data['position']['geopoint'];
      //  drivers_gcm.add(document.data['gcm']);
      // print( document.data['gcm']);
      _addMarker(point.latitude, point.longitude);
    });
  }

  //meload asset image ke BitmapDescriptor
  Future<BitmapDescriptor> _createMarkerImageFromAsset(String iconPath) async {
    var configuration = ImageConfiguration();
    customIcon = await BitmapDescriptor.fromAssetImage(configuration, iconPath);
    return customIcon;
  }

  void _addMarker(double lat, double lng) {
    var id = MarkerId(lat.toString() + lng.toString());
    var _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      //  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      // infoWindow: InfoWindow(title: 'latLng', snippet: '$lat,$lng'),
      icon: customIcon,
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    if (mapController == null) {
      mapController = controller;
      _controller.complete(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    //_panelHeightOpen = MediaQuery.of(context).size.height ;
    //double fullSizeHeight = MediaQuery.of(context).size.height;
    print("BuildContext GoDriverPage $_initialPosition");
    return WillPopScope(
      onWillPop: () async {
        print("modeddddddddddddddddddddMap ${_channgeMode.modeMap}");
        // print(_channgeMode.tujuanPosition);
        if (_channgeMode.modeMap == 0) {
          if (_timer != null) _timer.cancel();
          return true;
        } else if (_channgeMode.modeMap == 1) {
          if (_timer != null) _timer.cancel();
          _channgeMode._modeJemput();
          _moveToPosition(_channgeMode.jemputPosition);

          return false;
        } else if (_channgeMode.modeMap == 2 || _channgeMode.modeMap == 3) {
          if (_timer != null) _timer.cancel();
          _channgeMode._modeTujuan();
          _moveToPosition(_channgeMode.tujuanPosition);

          return false;
        } else if (_channgeMode.modeMap == 4) {
          if (_timer != null) _timer.cancel();
          _channgeMode._modeReadyToOrder(
              true, _channgeMode.distanceText, _channgeMode.totalPrices);
          return false;
        } else if (_channgeMode.modeMap == 5) {
          if (_timer != null) _timer.cancel();
          _channgeMode._modeJemput();
          _moveToPosition(_channgeMode.jemputPosition);
          return false;
        }
        return true;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // transparent status bar
            systemNavigationBarColor: Colors.black, // navigation bar color
            statusBarIconBrightness: Brightness.dark, // status bar icons' color
            systemNavigationBarIconBrightness:
                Brightness.dark, //navigation bar icons' color
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            // overflow: Overflow.clip,
            children: <Widget>[
              //map
              _initialPosition ==
                      LatLng(
                        0.0,
                        0.0,
                      )
                  ? Container(
                      child: Center(
                        child: Text(
                          'Cheking internet and loading map...',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: 'Avenir-Medium',
                              fontSize: 12,
                              color: Colors.blue),
                        ),
                      ),
                    )
                  : GoogleMap(
                      //  indoorViewEnabled: true,
                      padding: const EdgeInsets.only(bottom: 150),
                      polylines: Set<Polyline>.of(_polylines.values),
                      //markers: _markers,
                      markers: _channgeMode.modeMap == 3
                          ? Set<Marker>.of(markers_order.values)
                          : Set<Marker>.of(markers.values),
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      zoomGesturesEnabled: true,
                      trafficEnabled: true,
                      //  showUserLocation: true,
                      // mapViewType: MapViewType.normal,
                      //trackCameraPosition: true,
                      mapType: MapType.normal,
                      //markers: Set.of((marker != null) ? [marker] : []),
                      //circles: Set.of((circle != null) ? [circle] : []),
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition == LatLng(0.0, 0.0)
                            ? LatLng(-3.47764787218, 119.141805461)
                            : _initialPosition,
                        zoom: 16.0,
                        bearing: 20, //berputar
                      ),
                      //markers: _markers.values.toSet(),
                      onCameraMoveStarted: () {
                        //print('onCameraMoveStarted');
                        if ((_channgeMode.modeMap == 0 ||
                                _channgeMode.modeMap == 1) &&
                            _polylines.length > 0) {
                          setState(() {
                            _polylines.clear();
                          });
                        }
                      },
                      onCameraMove: (CameraPosition cameraPosition) {
                        _lastMapPosition = cameraPosition.target;
                        if ((_channgeMode.modeMap == 0 ||
                                _channgeMode.modeMap == 1) &&
                            _channgeMode.visible_Shimmer == false) {
                          _channgeMode._modeLoadingAdress(_channgeMode.modeMap);
                        }
                      },
                      buildingsEnabled: false,
                      onCameraIdle: () async {
                        if (_channgeMode.modeMap == 0 ||
                            _channgeMode.modeMap == 1) {
                          _getAdressLocation();
                        }
                      },
                      onMapCreated: _onMapCreated,
                    ),

              //tombol fab
              AnimatedBuilder(
                animation: _channgeMode,
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.gps_fixed,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _getUserLocation();
                    },
                    backgroundColor: Colors.white,
                  ),
                ),
                builder: (BuildContext context, Widget child) {
                  // print("the fab  ");
                  return Visibility(
                    visible: _channgeMode._fabVisible,
                    //  maintainAnimation: true,
                    child: Positioned(
                      right: 15.0,
                      bottom: _channgeMode._fabHeight,
                      child: child,
                    ),
                  );
                },
              ),

              //jarak kilometer
              AnimatedBuilder(
                animation: _channgeMode,
                //child: ,
                builder: (BuildContext context, Widget child) {
                  // print("the  jarak ");
                  return Visibility(
                    visible: _channgeMode.visible_distance_text,
                    child: Positioned(
                      top: 52.0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        child: Text(
                          _channgeMode.distanceText,
                          style: TextStyle(
                            fontFamily: 'NeoSans',
                            fontSize: 12,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, .25),
                                blurRadius: 5.0)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              //marker jemput
              AnimatedBuilder(
                animation: _channgeMode,
                builder: (BuildContext context, Widget child) {
                  // print("marker jemput ");
                  return Visibility(
                    visible: _channgeMode.visible_marker_jemput,
                    //  maintainAnimation: true,
                    child: Positioned(
                        top: ((MediaQuery.of(context).size.height - 40.0) -
                                (_channgeMode.minBottomMap + 80)) /
                            2,
                        right: (MediaQuery.of(context).size.width - 40.0) / 2,
                        child: Column(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              margin: EdgeInsets.all(1.0),
                              decoration: BoxDecoration(
                                  color: Colors.blue, shape: BoxShape.circle),
                              child: Icon(Icons.gps_fixed,
                                  size: 24, color: Colors.white),
                            ),
                            Container(
                              height: _channgeMode.height_marker_jemput,
                              width: 2.5,
                              color: Colors.black87,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  bottom: _channgeMode.margin_marker_jemput),
                            ),
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[700],
                                      spreadRadius: 4,
                                      blurRadius: 7,
                                    )
                                  ]),
                              // margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                            ),
                          ],
                        )),
                  );
                },
              ),

              //marker tujuan
              AnimatedBuilder(
                animation: _channgeMode,
                builder: (BuildContext context, Widget child) {
                  // print("marker tujuan ");
                  return Visibility(
                    visible: _channgeMode.visible_marker_tujuan,
                    //  maintainAnimation: true,
                    child: Positioned(
                      top: ((MediaQuery.of(context).size.height - 40.0) -
                              (_channgeMode.minBottomMap + 80)) /
                          2,
                      right: (MediaQuery.of(context).size.width - 40.0) / 2,
                      child: Column(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            margin: EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                shape: BoxShape.circle),
                            child: Icon(Icons.adjust,
                                size: 24, color: Colors.white),
                          ),
                          Container(
                            height: _channgeMode.height_marker_tujuan,
                            width: 2.5,
                            color: Colors.black87,
                            margin: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                bottom: _channgeMode.margin_marker_tujuan),
                          ),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                                color: Colors.grey[700],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[700],
                                    spreadRadius: 4,
                                    blurRadius: 7,
                                  )
                                ]),
                            // margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              //SlidingUpPanel
              AnimatedBuilder(
                animation: _channgeMode,
                /*child: */
                builder: (BuildContext context, Widget child) {
                  print("SlidingUpPanel  ");
                  return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: SlidingUpPanel(
                        backdropEnabled: false,
                        maxHeight: _channgeMode.maxHeight,
                        minHeight: _channgeMode.minHeight,
                        // parallaxEnabled: true,
                        parallaxOffset: .5,
                        controller: _pc,
                        //padding: MediaQuery.of(context).viewInsets,
                        // body:    _body(),
                        // panel: Text("data"),
                        // panelBuilder: (sc) => _panel(sc),

                        panelBuilder: (sc) => MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: Padding(
                              // padding: MediaQuery.of(context).viewInsets,
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 10),
                              child: ListView(
                                controller: sc,
                                children: <Widget>[
                                  //icon drag
                                  Visibility(
                                    visible: _channgeMode.visible_drag_icon,
                                    child: Icon(Icons.drag_handle,
                                        size: 16.0, color: Colors.grey),
                                  ),

                                  //order diterima oleh driver dan foto driver
                                  Visibility(
                                    visible: _channgeMode.visible_driver,
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: _channgeMode
                                                      .orderan.driver_avatar !=
                                                  ""
                                              ? CircleAvatar(
                                                  radius: 24.0,
                                                  backgroundImage: NetworkImage(
                                                      _channgeMode.orderan
                                                          .driver_avatar),
                                                )
                                              : CircleAvatar(
                                                  child: Icon(
                                                    Icons.account_box,
                                                    size: 24.0,
                                                  ),
                                                ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Driver : ',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'NeoSans',
                                                  fontSize: 10,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.normal,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              Text(
                                                  '${_channgeMode.orderan.driver}',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: 'NeoSans',
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0,
                                                  )),
                                              Container(
                                                child: Row(
                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.grade,
                                                        size: 16.0,
                                                        color: Colors.orange),
                                                    Text(
                                                      '${_channgeMode.orderan.driver_bintang}',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: 'NeoSans',
                                                        fontSize: 13,
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    Icon(Icons.directions_bike,
                                                        size: 16.0,
                                                        color: Colors.orange),
                                                    Text(
                                                        '${_channgeMode.orderan.driver_trip}',
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          fontFamily: 'NeoSans',
                                                          fontSize: 12,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          letterSpacing: 0,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                            ],
                                          ),
                                        ),
                                        //  Icon(  Icons.search ,  size: 16.0, color: Colors.grey ),
                                      ],
                                    ),
                                  ),

                                  //1 header jemput
                                  Visibility(
                                    visible: _channgeMode.visibleHeaderJemput,
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          _channgeMode._setText,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0,
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontFamily: 'NeoSansBold',
                                            decoration: TextDecoration.none,
                                            //  decorationStyle: TextDecorationStyle.dashed,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //2 header pilihan kategori kedaraan
                                  Visibility(
                                    visible: _channgeMode.visible_mode_bayar,
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          _channgeMode.header_category,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'NeoSansBold',
                                            fontSize: 18,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        Align(
                                          child: Container(
                                            width: 120,
                                            height: 26,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 2.0, horizontal: 0.0),
                                            child: OutlineButton(
                                              child: Text(
                                                _channgeMode.penumpang,
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontFamily: 'NeoSans',
                                                  fontSize: 11,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  side: BorderSide(
                                                      color: Colors.green)),

                                              onPressed: () {
                                                _showModePesanan();
                                              }, //callback when button is clicked
                                              borderSide: BorderSide(
                                                color: Colors
                                                    .green, //Color of the border
                                                style: BorderStyle
                                                    .solid, //Style of the border
                                                width:
                                                    0.8, //width of the border
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  Divider(
                                    color: Colors.grey,
                                    height: 5,
                                  ),

                                  //3 alamat jemput
                                  Visibility(
                                    visible: _channgeMode.visibleJemput,
                                    child: RaisedButton(
                                      onPressed: () {
                                        _showCari(0);
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
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 6),
                                            child: Icon(Icons.gps_fixed,
                                                size: 32.0, color: Colors.blue),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Jemput : ${_channgeMode.jemputJudul}',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: 'NeoSans',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                Text(
                                                  _channgeMode.jemputAlamat,
                                                  maxLines: 3,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontFamily: 'NeoSans',
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                                  ),

                                  //4
                                  Visibility(
                                    visible: _channgeMode
                                        .visible_divider_buttom_jemput,
                                    maintainSize: false,
                                    child: Divider(
                                      color: Colors.grey,
                                      height: 5,
                                    ),
                                  ),

                                  //5 Shimmer
                                  Visibility(
                                    visible: _channgeMode.visible_Shimmer,
                                    child: SizedBox(
                                      width: 200.0,
                                      height: 50.0,
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300],
                                        highlightColor: GojekPalette.grey,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 6, top: 3),
                                              child: Container(
                                                height: 32,
                                                width: 32,
                                                decoration: BoxDecoration(
                                                    color: Color(0xffcacaca),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.5)),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 11,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffcacaca),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 11,
                                                    width: 230,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 11,
                                                    width: 230,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffcacaca),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //6 alamat tujuan
                                  Visibility(
                                    visible: _channgeMode.visibleTujuan,
                                    child: RaisedButton(
                                      onPressed: () {
                                        _showCari(1);
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
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 6),
                                            child: Icon(Icons.adjust,
                                                size: 32.0,
                                                color: Colors.orange),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Tujuan : ${_channgeMode.tujuanJudul}',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: 'NeoSans',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                Text(_channgeMode.tujuanAlamat,
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                      fontFamily: 'NeoSans',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      letterSpacing: 0,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Icon(Icons.search,
                                              size: 16.0, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ),

                                  //7
                                  Visibility(
                                    visible: _channgeMode
                                        .visible_divider_buttom_tujuan,
                                    maintainSize: false,
                                    child: Divider(
                                      color: Colors.grey,
                                      height: 5,
                                    ),
                                  ),

                                  //8 keterangan jemput
                                  Visibility(
                                    maintainSize: false,
                                    visible: _channgeMode.visibleTextKeterangan,
                                    child: Container(
                                      //padding:   EdgeInsets.symmetric(vertical: 1.0, horizontal: 0.0),
                                      //margin:   EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                      decoration: BoxDecoration(
                                        color: GojekPalette.grey200,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.3,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 0),
                                            child: Icon(Icons.message,
                                                size: 24.0,
                                                color: Colors.green),
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
                                              textInputAction:
                                                  TextInputAction.go,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 0),
                                                  hintText:
                                                      'Rincian alamat...'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  //9
                                  Visibility(
                                    visible: _channgeMode
                                        .visible_divider_buttom_keterangan,
                                    maintainSize: false,
                                    child: Divider(
                                      color: Colors.grey,
                                      height: 5,
                                    ),
                                  ),

                                  //10 button set
                                  Visibility(
                                    maintainSize: false,
                                    visible: _channgeMode.visibleButtonSet,
                                    child: RaisedButton(
                                      textColor: Colors.white,
                                      color: Colors.green,
                                      child: Text('${_channgeMode._setText}'),
                                      onPressed: () {
                                        //  print(_channgeMode.modeMap);
                                        //  print(_channgeMode.prov_1);
                                        //  print(_channgeMode.prov_2);

                                        if (_channgeMode.modeMap == 0) {
                                          // setState(() {
                                          //  modeMap = 1;
                                          //   _positionJemput =
                                          //       _lastMapPosition;
                                          //  });
                                          _channgeMode._modeTujuan();
                                          _moveToPosition(_initialPosition);
                                        } else if (_channgeMode.modeMap == 1) {
                                          // setState(() {
                                          //  modeMap = 2;
                                          //   _positionTujuan =
                                          //       _lastMapPosition;
                                          // });
                                          _channgeMode._modeLoadPrice(true);
                                          getJsonDirectionGoogle();
                                        } else if (_channgeMode.modeMap == 2) {}
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),

                                  // mode bayar tunai dan lain lain
                                  Visibility(
                                    maintainSize: false,
                                    visible: _channgeMode.visible_mode_bayar,
                                    child: RaisedButton(
                                      onPressed: () {
                                        _showModeBayar();
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
                                          Icon(Icons.monetization_on,
                                              size: 30.0, color: Colors.green),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  _channgeMode.pay_categories ==
                                                          'tunai'
                                                      ? 'BAYAR TUNAI KE DRIVER '
                                                      : 'BAYAR PAKAI SALDO',
                                                  style: TextStyle(
                                                    fontFamily: 'NeoSans',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Icon(Icons.more_vert,
                                              size: 24.0, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ),

                                  //11 button order dan harga
                                  Visibility(
                                      visible:
                                          _channgeMode.visible_button_order,
                                      child: RaisedButton(
                                        color: Colors.green,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                'ORDER',
                                                style: TextStyle(
                                                  fontFamily: 'NeoSans',
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Rp ${uang.format(_channgeMode.totalPrices)}',
                                              style: TextStyle(
                                                fontFamily: 'NeoSans',
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6, bottom: 2),
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.white,
                                                highlightColor: Colors.orange,
                                                child: Icon(Icons.send,
                                                    size: 16.0,
                                                    color: Colors.orange),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          // if (drivers_gcm.isNotEmpty) {
                                          // print(_channgeMode.modeMap);
                                          _channgeMode._modeRequestOrder();
                                          _startTimeWaitOrder();
                                          // } else {
                                          //   _errorDriverNotFount();
                                          // }
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                      )),

                                  //12 harga tidak muncul
                                  Visibility(
                                    visible: _channgeMode.visible_harga_invalid,
                                    child: RaisedButton(
                                      color: Colors.green,
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.white,
                                        highlightColor: Colors.orange,
                                        child: Text(
                                          'UPSS, HARGA TIDAK TAMPIL',
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'NeoSans',
                                            fontSize: 13.0,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      onPressed: () {
                                        _channgeMode._modeLoadPrice(true);
                                        getJsonDirectionGoogle();
                                      },
                                    ),
                                  ),

                                  //13 animation mode waiting reseive order respon
                                  //dan batal sebelum terima
                                  Visibility(
                                      visible: _channgeMode
                                          .visible_animation_waiting_order,
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                _channgeMode.bool_meminta_batal ==
                                                        true
                                                    ? 'Sabar yaa....  ${_channgeMode._start} '
                                                    : 'Order akan dibatlkan',
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'NeoSans',
                                                  fontSize: 20.0,
                                                  letterSpacing: 0,
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              Container(
                                                width: 100,
                                                child: Visibility(
                                                    visible: _channgeMode
                                                        .visible_batalkan_pertama,
                                                    child: MaterialButton(
                                                      elevation: 1.0,
                                                      minWidth: double.infinity,
                                                      height: 43.0,
                                                      color: Colors.blue,
                                                      child: _channgeMode
                                                                  .bool_meminta_batal ==
                                                              true
                                                          ? Text(
                                                              'Batalkan',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'NeoSans',
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    0,
                                                              ),
                                                            )
                                                          : CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .white),
                                                            ),
                                                      onPressed: () async {
                                                        //batal biasa langsung matikan timer dan kembalikan mode ready order
                                                        //kembalikan ke mode load price tapi bukan minta harga ke server akan tetapi harga sebelumnya diambil
                                                        if (_channgeMode
                                                                .bool_meminta_batal ==
                                                            true) {
                                                          if (_timer != null)
                                                            _timer.cancel();
                                                          _channgeMode
                                                              ._modeBatalOrderPertama();
                                                          _sendPostBatal(0);
                                                        }
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                      ),
                                                    )),
                                              )
                                            ],
                                          ))),

                                  //order chat dan telepon
                                  Visibility(
                                    visible:
                                        _channgeMode.visible_order_chat_telepon,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          height: 45,
                                          child: RaisedButton(
                                            onPressed: () {
                                              launch(
                                                  'tel://${_channgeMode.orderan.driver_hp}');
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
                                                Icon(Icons.call,
                                                    size: 24.0,
                                                    color: Colors.green[300]),
                                                Text(
                                                  ' Telepon',
                                                  style: TextStyle(
                                                    fontFamily: 'NeoSans',
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    letterSpacing: 0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 45,
                                          child: RaisedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Chat(
                                                            dataP: widget.dataP,
                                                            peerId:
                                                                '${_channgeMode.orderan.driver_uid}',
                                                            peerAvatar:
                                                                '${_channgeMode.orderan.driver_avatar}',
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
                                                    color: Colors.blue[300]),
                                                Text(
                                                  ' Chat',
                                                  style: TextStyle(
                                                    fontFamily: 'NeoSans',
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    letterSpacing: 0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  //tombol batal order yg telah diterima driver
                                  Visibility(
                                      visible: _channgeMode.visible_order_batal,
                                      child: Center(
                                        child: RaisedButton(
                                            onPressed: () {
                                              //setState(() {
                                              //  id_pilihan_kusioner = 1;
                                              _channgeMode._setKusioner(1);
                                              //  });
                                              _showKusionerGagal();
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            color: Colors.white,
                                            elevation: 0,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.0, horizontal: 1.0),
                                            child: Text(
                                              'Batal',
                                              style: TextStyle(
                                                fontFamily: 'NeoSans',
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0,
                                              ),
                                            )),
                                      )),
                                ],
                              ),
                            )),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0)),
                        //  onPanelSlide: (double pos)   { } ,
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //dialog pilih driver motor , mobil dll
  void _showModePesanan() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 4,
      isDismissible: true,
      //useRootNavigator: useRootNavigator,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          height: 260,
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
                'Pilih Kendaraan',
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
                  _channgeMode._modeKendaraan('ojek');
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
                    Icon(Icons.directions_bike,
                        size: 30.0, color: GojekPalette.menuRide),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'MOTOR',
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
                    Text('1 Penumpang')
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
                  _channgeMode._modeKendaraan('car4');
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
                    Icon(Icons.directions_car,
                        size: 30.0, color: GojekPalette.menuCar),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'MOBIL 4',
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
                    Text('4 Penumpang')
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 5,
              ),
              RaisedButton(
                onPressed: () {
                  _channgeMode._modeKendaraan('car6');
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
                    Icon(Icons.directions_car, size: 30.0, color: Colors.red),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'MOBIL 6',
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
                    Text('6 Penumpang')
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    ;
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
                'Bayar Dengan',
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
                  _channgeMode._modeBayar('tunai');
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
                  _channgeMode._modeBayar('saldo');
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
                    //Icon(  Icons.more_vert ,  size: 24.0, color: Colors.grey ),
                    Text('Rp $saldoCustomer ') // ${uang.format(saldoCustomer)}
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
  void _showGagalOrder(String _Titlenya, String _img, String _Message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        // return  StatefulBuilder(builder: (c, s) {
        //  return  SafeArea(
        //child:
        return Container(
          height: 550,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                  blurRadius: 8.0,
                )
              ]),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Icon( Icons.drag_handle,  color: GojekPalette.grey,  ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //Icon( Icons.close,  color: GojekPalette.grey,size: 16,  ),
                    Text(
                      '$_Titlenya',
                      maxLines: 1,
                      style:
                          TextStyle(fontFamily: 'NeoSansBold', fontSize: 17.0),
                    ),
                    OutlineButton(
                      color: GojekPalette.green,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'TUTUP',
                        style: TextStyle(
                            fontSize: 12.0, color: GojekPalette.green),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  '$_img',
                  //    height: 250.0,
                  //  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  '$_Message',
                  maxLines: 2,
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

  //dialog batal kusioner
  void _showKusionerGagal() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        //elevation:500,
        isDismissible: true,
        //useRootNavigator: useRootNavigator,
        isScrollControlled:
            true, // set this to true when using DraggableScrollableSheet as child
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.95,
              minChildSize: 0.0,
              maxChildSize: 0.95,
              builder: (_, controller) {
                //bisa dimanfaatkan ketika scroll berada di posisi mana
                /*
            if (controller.hasClients) {
                var dimension = controller.position.viewportDimension; 
                if (dimension<=    200) { 
                  print(controller.position);
                }  
            }   
            */
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter state) {
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
                            child: CustomScrollView(
                              controller: controller,
                              slivers: <Widget>[
                                SliverAppBar(
                                  title: Text(
                                    'Alasan Order dibatalkan?',
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black),
                                  ),
                                  backgroundColor: Colors.white,
                                  automaticallyImplyLeading: false,
                                  primary: false,
                                  floating: true,
                                  pinned: true,
                                ),
                                /*SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, idx) => ListTile(
                                    title: Text('Nothing much'),
                                    subtitle: Text('$idx'),
                                  ),
                                  childCount: 100,
                                ),
                              ),*/
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      AnimatedBuilder(
                                        animation: _channgeMode,
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return Container(
                                            height: 280.0,
                                            child: Column(
                                              children: fList
                                                  .map((data) => RadioListTile(
                                                        title: Text(
                                                            '${data.name}'),
                                                        groupValue: _channgeMode
                                                            .id_pilihan_kusioner,
                                                        value: data.index,
                                                        onChanged: (val) {
                                                          // state(() {
                                                          //radioItem = data.name;
                                                          //id_pilihan_kusioner =
                                                          //   data.index;
                                                          _channgeMode
                                                              ._setKusioner(
                                                                  data.index);
                                                          //});
                                                        },
                                                      ))
                                                  .toList(),
                                            ),
                                          );
                                        },
                                      ),

                                      /*Container(
                                        height: 280.0,
                                        child: Column(
                                          children: fList.map((data) {
                                            return RadioListTile(
                                                  title: Text('${data.name}'),
                                                  groupValue: _channgeMode
                                                      .id_pilihan_kusioner,
                                                  value: data.index,
                                                  onChanged: (val) {
                                                    // state(() {
                                                    //radioItem = data.name;
                                                    //id_pilihan_kusioner =
                                                    //   data.index;
                                                    _channgeMode._setKusioner(
                                                        data.index);
                                                    //});
                                                  },
                                                );

                                           
                                          }).toList(),
                                        ),
                                      ),*/
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          color: Colors.green,
                                          elevation: 0,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            //kirim kusioner tidak usah menunggu resopon dan kembalikan ke mode ModeFirstOpen()
                                            _sendPostBatal(_channgeMode
                                                .id_pilihan_kusioner);
                                            //_getUserLocation();
                                            // _channgeMode._modeFirstOpen(
                                            //     _channgeMode.listTarif);
                                          },
                                          child: Text('Kirim',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        height: 50.0,
                                        width: 100.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              });
        });
  }

  /// API request function. Returns the Predictions
  Future<dynamic> _makeRequestKeyWord(String input) async {
    var location = '${_initialPosition.latitude},${_initialPosition.longitude}';
    //  var radius = '3000';
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${CallApi.keyApi}&language=id&location=$location&radius=3000';
    print(url);
    try {
      final response = await http.get(url);
      final _json = json.decode(response.body);
      // print(response.body);
      if (_json['error_message'] != null) {
        var error = _json['error_message'];
        if (error == 'This API project is not authorized to use this API.') {
          error +=
              ' Make sure the Places API is activated on your Google Cloud Platform';
        }
        // throw Exception(error);
        print(error);
        return _placePredictions;
      } else {
        final predictions = _json['predictions'];

        return predictions;
      }
    } catch (e) {
      print('_makeRequestKeyWord >>$input:$e');
      return _placePredictions;
    }
  }

  void _showCari(int modeCari) {
    showModalBottomSheet(
        context: context,
        // clipBehavior: ,
        //backgroundColor: Colors.transparent,
        isDismissible: true,
        // elevation: 10,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.drag_handle,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Cari alamat',
                      style:
                          TextStyle(fontFamily: 'NeoSansBold', fontSize: 18.0),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: TextField(
                    autofocus: true,
                    //focusNode: myFocusNode,
                    onChanged: (value) async {
                      if (value.isEmpty) {
                        setState(() {
                          _placePredictions = [];
                        });
                        print('kosong');
                      } else {
                        // print(value);
                        final predictions = await _makeRequestKeyWord(value);
                        setState(() {
                          _placePredictions = predictions;
                        });
                      }
                    },
                    style: TextStyle(
                        fontFamily: 'NeoSans',
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0,
                        color: Colors.black),
                    cursorColor: Colors.black,

                    keyboardType: TextInputType.text,
                    // textInputAction: TextInputAction.go,
                    controller: cariController,
                    decoration: InputDecoration(
                      //labelText: 'Search',
                      hintText: 'Search',
                      filled: true,

                      fillColor: GojekPalette.grey200,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.green,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.3),
                      ),
                    ),
                  ),
                ),
                OutlineButton(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.map,
                        color: Colors.green,
                      ),
                      Text(
                        'Pilih lewat peta',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'NeoSans',
                          fontSize: 11,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(color: Colors.green)),
                  onPressed: () async {
                    print('modeCari $modeCari');
                    _channgeMode._setModeMap(modeCari);
                    print('jemputPosition ${_channgeMode.jemputPosition}');
                    print('tujuanPosition ${_channgeMode.tujuanPosition}');
                    if (modeCari == 0) {
                      // _channgeMode._modeJemput();
                      await _moveToPosition(_channgeMode.jemputPosition);
                    } else if (modeCari == 1) {
                      //  _channgeMode._modeTujuan();
                      await _moveToPosition(_channgeMode.tujuanPosition);
                    } else {}

                    // _getUserLocation();
                    Navigator.pop(context);
                  }, //callback when button is clicked
                  borderSide: BorderSide(
                    color: Colors.green, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 0.3, //width of the border
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 5,
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    // controller: scrollcontroller,
                    itemCount: _placePredictions.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          _placePredictions[index]['description'],
                          //place.length < 45 ? '$place' : '${place.replaceRange(45, place.length, '')} ...',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.grey[850],
                          ),
                          maxLines: 1,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        onTap: () async {
                          //_channgeModeLoadingAdress.modeMap = modeCari;
                          _channgeMode._setModeMap(modeCari);
                          try {
                            var placemark = await Geolocator()
                                .placemarkFromAddress(
                                    _placePredictions[index]['description']);
                            _moveToPosition(LatLng(
                                placemark[0].position.latitude,
                                placemark[0].position.longitude));

                            Navigator.pop(context);
                          } catch (e) {
                            print('ERROR _showCari>>$_lastMapPosition :$e');
                            _getUserLocation();

                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  ),
                )
              ]),
            );
          });
        });
  }

  //muli mengirim order dan menungggu tanggapan driver
  void _startTimeWaitOrder() {
    if (_timer != null) _timer.cancel();

    _newOrder();

    _timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (_channgeMode._start < 1 || _channgeMode._start == 1) {
        if (_timer != null) _timer.cancel();
        _showGagalOrder(
            'Opss belum menemukan diver...!',
            'assets/images/para_ojek.png',
            'Pasukan driver pada sibuk nihhh, silahkan ulangi order ya...!');
        _channgeMode._modeReadyToOrder(
            true, _channgeMode.distanceText, _channgeMode.totalPrices);
      } else {
        _channgeMode._setTime();
      }
    });
  }

  //penyiman data order ke server
  //apakah suskes atau tidak
  //jika ya maka silahkan tunggu driver
  //jika gagal maka silahkan tombol order di ulangi
  Future<void> _newOrder() async {
    print(widget.dataP['gcm']);
    var messageError = '';
    var titleError = 'Opss belum menemukan diver...!';

    var data = {
      // 'email': emailInputController.text,
      "gcm": widget.dataP['gcm'],
      "customer_id": widget.dataP['uid'],
      //"driver_id": 1,
      // "charge": 1,
      //"point_transaction": 10,
      "total_prices": _channgeMode.totalPrices,
      "pay_category": _channgeMode.pay_categories,
      "category_driver": _channgeMode.category_driver,

      "pickup_lat": _channgeMode.jemputPosition.latitude,
      "pickup_long": _channgeMode.jemputPosition.longitude,
      "pickup_address": _channgeMode.jemputAlamat,
      "pickup_place": _channgeMode.jemputJudul,
      "pickup_desc": controllerKeterangan.text,

      "desti_lat": _channgeMode.tujuanPosition.latitude,
      "desti_long": _channgeMode.tujuanPosition.longitude,
      "desti_address": _channgeMode.tujuanAlamat,
      "desti_place": _channgeMode.tujuanJudul,

      "distance_text": _channgeMode.distanceText,
      "duration_text": _channgeMode.durationText,
      "duration_value": _channgeMode.durationValue,
      "distance_value": _channgeMode.distanceValue,

      "polyline": "-",
      //"status_order": 0,
    };
    print("ddd ${widget.dataP['gcm']} fff");

    var res = await CallApi().postData(data, 'newordergojek');
    print(res.body);
    if (res.statusCode == 200) {
      var body = json.decode(res.body);

      /*dataP = {
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
        };*/
      print("behasil mengirim ${body['order']} dddddddddd ${body['id']} ");
      _channgeMode._setOrder(body['order'], body['id']);
      // await localStorage.setInt('uid', body['id']);

    } else if (res.statusCode == 401) {
      var body = json.decode(res.body);
      messageError = 'Driver pada sibuk nihhh, silahkan ulangi order ya...!';

      if (body['error'] == "Unauthorized") {
        titleError = "Silahkan Login.?";
        messageError = "Silahkan login untuk melakukan transaksi";
      }
    } else if (res.statusCode == 400) {
      var body = json.decode(res.body);
      messageError = body['error'];
    } else {
      messageError = 'Driver pada sibuk nihhh, silahkan ulangi order ya...!';
    }
    //res.statusCode
    if (messageError != "") {
      if (_timer != null) _timer.cancel();

      _showGagalOrder(titleError, 'assets/images/para_ojek.png', messageError);
      _channgeMode._modeReadyToOrder(
          true, _channgeMode.distanceText, _channgeMode.totalPrices);
    }
  }

  //notifikasi untuk data order di terima oleh driver
  void setAcceptOrder(Map<dynamic, dynamic> dataMasuk) async {
    try {
      //cek jika id order sama dengan yg masuk dengan yg barusan dikirim
      //pada mode menunggu balasan order diterima oleh driver maka
      //maka segera ubah mode ke mode orde diterima
      print(
          " ${dataMasuk['order']} ---  ${_channgeMode.order} ----   ${_channgeMode.modeMap}   ---- ${dataMasuk['category_message']}");
      if (dataMasuk['order'] == _channgeMode.order &&
          dataMasuk['category_message'] == 'accept_order' &&
          _channgeMode.modeMap == 4) {
        //set data json orderan

        if (_timer != null) _timer.cancel();
        _channgeMode.orderan =
            OrderanJson.fromJson(jsonDecode(dataMasuk['data_json']));
        _pc.hide();
        _pc.close();
        _channgeMode._modeReseiveTrue();
        print("  ------------>>>  ${_channgeMode.order}  ");
        //mode permintaan order diterima driver

      } else if (dataMasuk['order'] == _channgeMode.order &&
          dataMasuk['category_message'] == 'cancel_order' &&
          _channgeMode.modeMap == 5) {
        print(
            "2 ${dataMasuk['order']} ---  ${_channgeMode.order} ----   ${_channgeMode.modeMap}");
        //mode dimana kembalikan ke mode ready to order karena orederan dibatalkan driver
        //jika mode masih dalam keadaan order diterima driver
        //dan pesan  yg masuk adalah  batal maka  kembalikan ke mode ready to order
        _showGagalOrder('Opss order dibatalkan diver...!',
            'assets/images/para_ojek.png', "Ulangi cari driver lain");
        _channgeMode._modeReadyToOrder(
            true, _channgeMode.distanceText, _channgeMode.totalPrices);
        //_getUserLocation();
        //_channgeMode. _modeFirstOpen(documentListTarif);
      }
    } catch (e) {
      print('print err, from service: $e');
      throw (e.toString());
    }
  }

  //mengirim post pembatalan memesan driver
  //dan kembalikan ke mode pertama
  //mengirim survei kusioner batal ke server
  Future<void> _sendPostBatal(int cancelid) async {
    // await Future.delayed(Duration(seconds: 5));
    try {
      await http
          .post(
            Uri.encodeFull(
                "${CallApi.url}cancelordergojek?id=${_channgeMode.order_id}&cancelid=$cancelid&codetran=${_channgeMode.order}"),
            headers: {
              'Accept': 'application/json',
              'Content-type': 'application/json',
              'Authorization': '${widget.dataP["token"]}'
            },
            /* body: json.encode({
              'codetran': _channgeMode.order,
              'cancelid': 0,
              'id': 1,
            }),*/
          )
          .timeout(const Duration(seconds: 30))
          .then((onResponse) {
            _channgeMode._modeJemput();
            _moveToPosition(_channgeMode.jemputPosition);
            if (onResponse.statusCode == 200) {
            } else {
              print('object2');
            }
          })
          .catchError((onerror) {
            _channgeMode._modeJemput();
            _moveToPosition(_channgeMode.jemputPosition);
            print('object3');
          });
    } catch (e) {
      _channgeMode._modeJemput();
      _moveToPosition(_channgeMode.jemputPosition);

      print('object4 $e');
    }
  }
}
//end class

class ChanngeModeLoadingAdress extends ChangeNotifier {
  // LatLng _lastMapPosition = LatLng(-3.47764787218, 119.141805461);
  var orderan = OrderanJson.fromJson(jsonDecode(
      '{"category_driver":"","total_prices":"","pay_categories":"","driver":"","driver_uid":"","driver_avatar":"","driver_hp":"","driver_bintang":"","driver_trip":"","driver_gcm":"","jemput_judul":"","jemput_alamat":"","jemput_ket":"","tujuan_judul":"","tujuan_alamat":""}'));
  String order = "";
  int order_id = 0;
  List<DriverPrice> listTarif = [];
  int _start;
  int modeMap = 0;
  String penumpang = "1 PENUMPANG";
  String header_category = "OJEK";
  String pay_categories = "tunai";
  String category_driver = 'ojek';
  //int point_transaction = 0;
  bool bool_meminta_batal = true;

  //variable untuk jemput dan tujuan
  String jemputJudul = "";
  String jemputAlamat = "";
  LatLng jemputPosition = LatLng(-3.47764787218, 119.141805461);
  String prov_1 = '';
  bool visible_marker_jemput = false;
  double height_marker_jemput = 15.0;
  double margin_marker_jemput = 0;
  //jemputKet = controllerKeterangan.text;

  //tujuan
  String tujuanJudul = "";
  String tujuanAlamat = "";
  LatLng tujuanPosition = LatLng(-3.47764787218, 119.141805461);
  String prov_2 = '';
  bool visible_marker_tujuan = false;
  double height_marker_tujuan = 15.0;
  double margin_marker_tujuan = 0;

  int totalPrices = 0;
  String distanceText = "0";
  int distanceValue = 0;
  String durationText = "0";
  int durationValue = 0;

  //berlaku umum ketika mencari lokasi akan hidden
  bool _fabVisible = false;
  bool visibleTextKeterangan = false;
  bool visibleButtonSet = false;
  bool visible_button_order = false;
  bool visible_harga_invalid = false;
  bool visible_animation_waiting_order = false;
  bool visible_batalkan_pertama = false;
  bool visible_mode_bayar = false;
  bool visible_distance_text = false;

  bool visible_order_batal = false;
  bool visible_order_chat_telepon = false;
  bool visible_driver = false;
  bool visibleHeaderJemput = true;
  bool visible_Shimmer = true;
  bool visibleTujuan = false;
  bool visible_divider_buttom_tujuan = false;
  bool visible_divider_buttom_keterangan = false;

  //berlaku khusus jikan mode map 0 atau 1
  bool visible_drag_icon = false;
  bool visibleJemput = false;
  bool visible_divider_buttom_jemput = false;
  double maxHeight = 150;
  double minHeight = 150;
  double _fabHeight = 166;
  double minBottomMap = 137;
  String _setText = 'Pencarian lokasi...';

  //berlaku khusus jika kondisi tertentu
  bool habis_waktu_menunggu = false;
  int id_pilihan_kusioner = 1;

  void documentListTarif(List<DriverPrice> documentListTarif) {
    listTarif = documentListTarif;
    notifyListeners();
  }

  void _modeFirstOpen(List<DriverPrice> documentListTarif) {
    //mode 99 adalah mode awal map dimana akan di cek ke internet apakah ada orderan

    listTarif = documentListTarif;
    modeMap = 0;
    penumpang = "1 PENUMPANG";
    header_category = "OJEK";
    pay_categories = "tunai";
    category_driver = 'ojek';

    //  _polylines.clear();
    // markers_order.clear();

    _fabVisible = false;
    _fabHeight = 166;
    maxHeight = 150;
    minHeight = 150;
    //minBottomMap = 137;

    _setText = 'Pencarian lokasi...';
    //mapTempat = '';
    // mapAlamat = '';
    jemputJudul = '';
    jemputAlamat = '';
    // jemputKet = '';

    tujuanJudul = '';
    tujuanAlamat = '';

    //harga
    pay_categories = 'tunai';
    totalPrices = 0;
    distanceText = '0';
    distanceValue = 0;
    // duration_text = '0';
    //  duration_value = '0';
    // _start = 30;
    // order = '';
    //  _placePredictions = [];

    visible_drag_icon = false;
    visible_order_chat_telepon = false;
    visible_order_batal = false;
    visible_driver = false;

    visible_Shimmer = true;
    visibleHeaderJemput = true;
    visibleJemput = false;
    visible_distance_text = false;
    visible_marker_jemput = false;
    visibleTujuan = false;
    visible_mode_bayar = false;
    visible_marker_tujuan = false;

    visibleTextKeterangan = false;
    visibleButtonSet = false;
    visible_divider_buttom_jemput = false;
    visible_divider_buttom_tujuan = false;
    visible_divider_buttom_keterangan = false;
    visible_button_order = false;
    visible_harga_invalid = false;
    visible_animation_waiting_order = false;
    visible_batalkan_pertama = false;
    bool_meminta_batal = true;

    habis_waktu_menunggu = false;
    notifyListeners();
  }

  void _modeLoadingAdress(
    int mode,
  ) {
    /**********
      mode loading addres seharusnya terjadi jika
      1. mode loading adress tidak boleh terjadi 
        jika sebelum mode resume atau mode first open
      2. mode ini terjadi saat map digeser atau digerakkan 
      3. yg dimana yg menampilkan loading pencarian nama lokasi center
         map atau posisi user
      #####kondisi terjadi saat########### 
      2. dalam kondisi mode jemput  
      3. dalam kondisi mode tujuan   
    **********/
    //berlaku umum ketika mencari lokasi akan hidden
    _setText = 'Pencarian lokasi...';
    _fabVisible = false;
    visibleTextKeterangan = false;
    visibleButtonSet = false;
    visible_button_order = false;
    visible_harga_invalid = false;
    visible_animation_waiting_order = false;
    visible_batalkan_pertama = false;
    visible_mode_bayar = false;
    visible_distance_text = false;
    visible_drag_icon = false;
    visible_order_batal = false;
    visible_order_chat_telepon = false;
    visible_driver = false;
    visibleHeaderJemput = true;
    visibleJemput = false;
    visibleTujuan = false;
    visible_divider_buttom_tujuan = false;
    visible_divider_buttom_keterangan = false;
    height_marker_jemput = 6.0;
    height_marker_tujuan = 6.0;

    margin_marker_jemput = 9.0;
    margin_marker_tujuan = 9.0;

    //berlaku khusus jikan mode map 0 atau 1
    visible_Shimmer = true;
    //if (mode == 0) {
    //   print("object0");
    visibleJemput = false;
    visibleTujuan = false;
    // } else if (mode == 1) {
    //  print("object1");
    // visibleJemput = false;
    //  visibleTujuan = false;
    // }
    visible_divider_buttom_jemput = false;
    maxHeight = 150;
    minHeight = 150;
    _fabHeight = 166;

    //print(visible_Shimmer);
    //visible_Shimmer = visible_Shimmer ? false : true;
    notifyListeners();
  }

  void _modeJemput() {
    //berlaku umum ketika mencari lokasi akan hidden
    modeMap = 0;
    _setText = 'Set lokasi jemput';
    _fabVisible = true;
    visible_drag_icon = false;
    visibleTextKeterangan = true;
    visibleButtonSet = true;
    visible_button_order = false;
    visible_harga_invalid = false;
    visible_animation_waiting_order = false;
    visible_batalkan_pertama = false;
    visible_mode_bayar = false;
    visible_distance_text = false;

    visible_order_batal = false;
    visible_order_chat_telepon = false;
    visible_driver = false;
    visibleHeaderJemput = true;
    visibleTujuan = false;
    visibleJemput = true;
    visible_divider_buttom_tujuan = false;
    visible_divider_buttom_keterangan = false;

    //berlaku khusus jikan mode map 0 atau 1
    visible_Shimmer = false;

    visible_divider_buttom_jemput = false;
    maxHeight = 190;
    minHeight = 190;
    _fabHeight = 206;
    //print(visible_Shimmer);
    //visible_Shimmer = visible_Shimmer ? false : true;

    visible_marker_jemput = true;
    visible_marker_tujuan = false;
    height_marker_jemput = 15.0;
    margin_marker_jemput = 0.0;

    notifyListeners();
  }

  void _modeTujuan() {
    modeMap = 1;

    Future.delayed(Duration(milliseconds: 100)).asStream().listen((_) {});

    // markers_order.clear();
    // _polylines.clear();
    // _pc.panelPosition = 0.5;
    maxHeight = 150;
    minHeight = 150;
    _fabHeight = 166.0;

    _setText = 'Set lokasi tujuan';
    _fabVisible = true;
    visible_Shimmer = false;
    visibleHeaderJemput = true;
    visibleTextKeterangan = false;
    visibleJemput = false;
    visibleTujuan = true;
    visible_divider_buttom_jemput = false;
    visible_divider_buttom_tujuan = false;
    visible_distance_text = false;

    visibleButtonSet = true;
    visible_mode_bayar = false;
    visible_harga_invalid = false;

    visible_marker_jemput = false;
    visible_marker_tujuan = true;
    height_marker_tujuan = 15.0;
    margin_marker_tujuan = 0.0;
    notifyListeners();
    // jemputKet = controllerKeterangan.text;
  }

  void _modeLoadPrice(bool tanpa_harga_baru) {
    // order = '';
    print('ModeLoadPrice');
    modeMap = 2;
    if (tanpa_harga_baru) {
      // _polylines.clear();
    }
    _setText = 'Mendapatkan harga';
    //  _pc.panelPosition = 0.2;
    _fabVisible = false;

    visibleHeaderJemput = true;
    visible_distance_text = false;
    visible_mode_bayar = false;
    visibleTextKeterangan = false;
    visibleButtonSet = false;
    visible_button_order = false;
    visible_harga_invalid = false;
    visible_animation_waiting_order = false;
    visible_batalkan_pertama = false;
    visibleJemput = false;
    visibleTujuan = false;
    visible_divider_buttom_tujuan = false;
    visible_divider_buttom_jemput = false;
    visible_Shimmer = true;
    maxHeight = 150;
    minHeight = 150;
    //minBottomMap  = 90;
    _fabHeight = 166;

    visible_marker_jemput = false;
    visible_marker_tujuan = false;

    // _markers.clear();
    //_markers.clear();

    if (tanpa_harga_baru) {
      //   getJsonDirectionGoogle();
    }
    notifyListeners();
  }

  void _hitungHargaTotal(String distance_text, int distance_value,
      String duration_text, int duration_value) {
    /***************
    0=motor awal price ditampilakan
    1=ganti mode bayar tunai atau saldo
    2= ganti jenis orderan

    1.mode hitung adalah dari mana asal perintah dihitung
    2.apakah dari select metode bayar 
    3.atau select jenis orderan motor atau car4 dan car6
    4.atau ada diskon dan lain lain
    ***********/
    //order = '';

    totalPrices = 0;
    distanceText = distance_text;
    distanceValue = distance_value;
    durationText = duration_text;
    durationValue = duration_value;

    //mulai menghitung semu jenis harga
    //meter ke kilo meter bisa jadi terdapat koma
    //pembulatan meter ke km
    var kilo_dari_meter = ((distance_value + 1) ~/ 1000).round();
    var prices_rumus = 0;
    listTarif.forEach((element) {
      // print(distanceValue);
      if (element.category_driver == category_driver) {
        //konversi ke integr
        //var distance_value_int = int.parse(distance_value);

        prices_rumus = 0;

        if (kilo_dari_meter <= element.distance_looping_km) {
          //dibawah jarak looping atau dibawah jarak standar yg ditetapkan pemerintah
          //atau dengan kata lain harga sesuai kondisi lokasi pasar atau pemukiman
          prices_rumus = element.price_per_km * kilo_dari_meter;
        } else {
          //bulatkan ke bawah km berapa kali looping
          var berapa_kali_looping =
              (kilo_dari_meter ~/ element.distance_looping_km).floor();

          //harga hasil looping tergantung looping dan harga looping
          var harga_hasil_looping =
              element.price_looping_km * berapa_kali_looping;

          //mengambil sisa km
          var sisa_kilometer = (kilo_dari_meter / element.distance_looping_km) -
              berapa_kali_looping;

          //bulatakan ketas sisa km looping dikali harga per kilo
          var harga_sisa_kilometer =
              (sisa_kilometer).ceil() * element.price_per_km;

          prices_rumus = harga_hasil_looping + harga_sisa_kilometer;
        }
        /*_hitungHargaTotal("", 0);
      if (pay_categories == 'saldo') {
        if (saldoCustomer >= totalPrices) {
        } else {
          //  setState(() {
          pay_categories = 'tunai';
          // });
          _hitungHargaTotal("", 0);
        }
      }*/
        if (pay_categories == 'tunai') {
          totalPrices = (prices_rumus + element.charge + element.price_cash);
        }
        if (pay_categories == 'saldo') {
          totalPrices = (prices_rumus + element.charge + element.price_deposit);
        }
      }
    });
    _modeReadyToOrder(true, distance_text, totalPrices);
    notifyListeners();
  }

  void _modeReadyToOrder(bool load_ahrga, disText, total_prices) {
    order = "";
    modeMap = 3;
    visible_drag_icon = false;
    visible_driver = false;
    visible_order_batal = false;
    visible_order_chat_telepon = false;
    visible_marker_jemput = false;
    visible_marker_tujuan = false;
    visible_Shimmer = false;
    maxHeight = 280;
    minHeight = 280;

    _fabHeight = 296;
    _fabVisible = false;

    distanceText = disText;
    totalPrices = total_prices;

    if (load_ahrga) {
      print('load harga true');
      visible_button_order = true;
      visible_harga_invalid = false;
      visible_distance_text = true;
    } else {
      print('load harga false');

      visible_button_order = false;
      visible_harga_invalid = true;
      visible_distance_text = false;
    }

    visible_mode_bayar = true;
    visibleHeaderJemput = false;
    visibleJemput = true;
    visibleTujuan = true;

    visibleButtonSet = false;

    visible_divider_buttom_jemput = true;
    visible_divider_buttom_tujuan = true;
    visible_divider_buttom_keterangan = false;
    visible_animation_waiting_order = false;
    visible_batalkan_pertama = false;

    // markers_order.clear();
    var _markerjemput = Marker(
      markerId: MarkerId(jemputPosition.toString()),
      position: jemputPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: 'jemput', snippet: '$jemputAlamat'),
    );

    var _marker_tujuan = Marker(
      markerId: MarkerId(tujuanPosition.toString()),
      position: tujuanPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(title: 'tujuan', snippet: '$tujuanAlamat'),
    );

    //  markers_order[MarkerId(jemputPosition.toString())] = _markerjemput;
    // markers_order[MarkerId(tujuanPosition.toString())] = _marker_tujuan;
    notifyListeners();
  }

  void _modeRequestOrder() {
    order = "";
    modeMap = 4;
    _start = 30; //30;5
    _setText = 'Memanggil driver terdekat...!';
    // minBottomMap  = 137;

    _fabVisible = false;
    visible_Shimmer = false;
    visibleJemput = false;
    visibleTujuan = false;
    visible_distance_text = false;
    visible_divider_buttom_jemput = false;
    visible_divider_buttom_keterangan = false;
    visible_divider_buttom_tujuan = false;
    visibleTextKeterangan = false;
    visibleButtonSet = false;
    visible_button_order = false;
    visible_harga_invalid = false;
    visible_mode_bayar = false;

    visibleHeaderJemput = true;
    visible_animation_waiting_order = true;
    visible_batalkan_pertama = true;
    bool_meminta_batal = true;

    // _pc.show();
    // _pc.open();
    maxHeight = 150;
    minHeight = 150;
    _fabHeight = 166;
    notifyListeners();
  }

  void _modeReseiveTrue() {
    /* 
       mode ini dimana orderan telah diterima 
       oleh driver dari balasan gcm driver atau 
       mengambil langsung data orderan di server
       
      => maka navigasi dari ModeRequestOrder
      => menuju navigasi tampilan order diterima
    */
    print('mode order diterima');

    modeMap = 5;
    _start = 0;

    visible_drag_icon = true;
    visible_driver = true;
    visible_order_batal = true;
    visible_order_chat_telepon = true;
    _fabVisible = false;
    visible_distance_text = false;

    visibleHeaderJemput = false;
    visibleJemput = false;
    visibleTujuan = false;
    visibleTextKeterangan = false;
    visibleButtonSet = false;
    visible_button_order = false;
    visible_harga_invalid = false;
    visible_animation_waiting_order = false;
    visible_batalkan_pertama = false;
    visible_mode_bayar = false;
    visible_Shimmer = false;
    visible_divider_buttom_jemput = false;
    visible_divider_buttom_keterangan = false;
    visible_divider_buttom_tujuan = false;

    //tampilan mam saat order dirima oleh driver
    visible_marker_jemput = false;
    visible_marker_tujuan = false;

    maxHeight = 220;
    minHeight = 145;

    notifyListeners();
  }

  /* pembatalan ketika masih
  menunggu drive menerima orderan
  bisa jadi sementara diterima sama driver tapi gcm belum masuk dan oder sudah dibatalkan
   */
  void _modeBatalOrderPertama() {
    bool_meminta_batal = false;
    _start = 0;
    notifyListeners();
  }

  void _modeKendaraan(String kendaraan) {
    print('mode order diterima $distanceText $distanceValue');

    if (category_driver != kendaraan &&
        distanceValue >= 300 &&
        distanceValue <= 100000) {
      category_driver = kendaraan;
      if (kendaraan == 'ojek') {
        penumpang = '1 PENUMPANG';
        header_category = 'OJEK';
      }
      if (kendaraan == 'car4') {
        penumpang = '4 PENUMPANG';
        header_category = 'MOBIL';
      }
      if (kendaraan == 'car6') {
        penumpang = '6 PENUMPANG';
        header_category = 'MOBIL';
      }

      _hitungHargaTotal(
          distanceText, distanceValue, durationText, durationValue);
      //notifyListeners();
    }
  }

  void _modeBayar(String modeBayar) {
    if (pay_categories != modeBayar &&
        distanceValue >= 300 &&
        distanceValue <= 100000) {
      /*if (modeBayar == 'saldo') {
       
          pay_categories = modeBayar;
        
        if (saldoCustomer >= totalPrices) {
          
            pay_categories = modeBayar; 
        } else { 
            pay_categories = 'tunai'; 
        }
      } else { 
          pay_categories = modeBayar;  
      }*/
      pay_categories = modeBayar;
      _hitungHargaTotal(
          distanceText, distanceValue, durationText, durationValue);
    }
  }

  void _setAdressLocation(int mode, judul, alamat, pos, prov) {
    if (mode == 0) {
      //variable untuk jemput dan tujuan
      jemputJudul = judul;
      jemputAlamat = alamat;
      jemputPosition = pos;
      prov_1 = prov.replaceAll(RegExp(r'\s+\b|\b\s'), '');
      _modeJemput();
    } else if (mode == 1) {
      //tujuan
      tujuanJudul = judul;
      tujuanAlamat = alamat;
      tujuanPosition = pos;
      prov_2 = prov.replaceAll(RegExp(r'\s+\b|\b\s'), '');
      _modeTujuan();
    }
    notifyListeners();
  }

  void _setModeMap(int mode) {
    modeMap = mode;
    notifyListeners();
  }

  void _setTime() {
    _start = _start - 1;
    notifyListeners();
  }

  void _setOrder(String order1, int id) {
    order = order1;
    order_id = id;
    notifyListeners();
  }

  void _setKusioner(int id_pilihan) {
    id_pilihan_kusioner = id_pilihan;
    notifyListeners();
  }
}
