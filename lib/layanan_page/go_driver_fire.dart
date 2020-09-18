import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constans.dart';
import 'package:pelanggan/librariku/shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoDriverPage1 extends StatelessWidget {
  GoDriverPage1({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoDriver1(
        dataP: dataP,
      ),
    );
  }
}

class GoDriver1 extends StatefulWidget {
  GoDriver1({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  GoDriverState createState() => GoDriverState();
}

class GoDriverState extends State<GoDriver1> {
  //GoDriverState({Key key,  this.data_p });
  GoDriverState() {
    platform1.setMethodCallHandler((call) {
      print(call.method);
      if (call.method == 'gcm_masuk') {
        //print('aaaaaaaaaaaaaaaaaa ${call.arguments.cast<String, dynamic>()}');
        setAcceptOrder(call.arguments);
        //accept_order
      }
      return;
    });
  }

  static const platform1 = MethodChannel('ada_pesan_masuk');
  var uang = NumberFormat.currency(locale: 'ID', symbol: '', decimalDigits: 0);

  // Init firestore and geoFlutterFire
  Geoflutterfire geo;
  Stream<List<DocumentSnapshot>> stream;
  var radius = 50;
  final databaseRef = Firestore.instance;

  DateTime now = DateTime.now();
  BitmapDescriptor customIcon;
  String documentIDNYA = '';
  String namaCustomer = '';
  String uidCustomer = '';
  int saldoCustomer = 0;
  int pointCustomer = 0;
  int radiusCustomer = 60;
  String hpCustomer = '';
  String tripCustomer = '0';
  String bintangCustomer = '0';
  String avatarCustomer = '0';
  FirebaseUser currentUser;

  String bearToken = '';
  String gcmToken = '';
  //pesan driver
  String order = '';
  String mapTempat = '';
  String mapAlamat = '';
  String jemputJudul = '';
  String jemputAlamat = '';
  String jemputKet = '';
  bool visibleJemput = true;
  static LatLng jemputPosition = _initialPosition;
  String tujuanJudul = '';
  String tujuanAlamat = '';
  static LatLng tujuanPosition = _initialPosition;
  bool visibleTujuan = false;
  bool provAktif1 = false;
  bool provAktif2 = false;
  // var  Orderan = Orderan_Json.fromJson(  jsonDecode('{'category_driver':'','total_prices':'','pay_categories':'','driver':'','driver_uid':'','driver_avatar':'','driver_hp':'','driver_bintang':'','driver_trip':'','jemput_judul':'','jemput_alamat':'','jemput_ket':'','tujuan_judul':'','tujuan_alamat':''}')  );
  var orderan = OrderanJson.fromJson(jsonDecode(
      '{"category_driver":"","total_prices":"","pay_categories":"","driver":"","driver_uid":"","driver_avatar":"","driver_hp":"","driver_bintang":"","driver_trip":"","driver_gcm":"","jemput_judul":"","jemput_alamat":"","jemput_ket":"","tujuan_judul":"","tujuan_alamat":""}'));
  //0= jemput, 1=tujuan, 99=awal, 88 = ada order diambil dari server
  static int modeMap = 99;

  static int modeCari = 0;
  bool _fabVisible = false;
  //var button
  String _setText = 'jemput';
  bool visibleHeaderJemput = false;
  bool visibleButtonSet = false;
  //var text keterangan
  bool visibleTextKeterangan = true;
  final controllerKeterangan = TextEditingController();
  //var button mode bayar
  bool visible_mode_bayar = false;
  //cari alamat pakai text
  final cariController = TextEditingController();

  //var harga
  String resultdocumentID = '';
  int totalPrices = 0;
  String distanceText = '0';
  String distanceValue = '0';
  String duration_text = '0';
  String duration_value = '0';
  String category_driver = 'ojek';
  String pay_categories = 'tunai';
  int point_transaction = 0;
  String penumpang = '1 PENUMPANG';
  String header_category = 'OJEK';
  List<String> drivers_gcm = [];
  String polyline_order = '';
  int charge = 0;

  HashMap data_order_filter = HashMap<dynamic, dynamic>();
  //var divider
  bool visible_divider_buttom_jemput = false;
  bool visible_divider_buttom_tujuan = false;
  bool visible_divider_buttom_keterangan = false;
  //visible_Shimmer
  bool visible_Shimmer = false;
  //marker jemput
  double iconSize = 40.0;
  bool visible_marker_jemput = false;
  bool visible_distance_text = false;
  //marker tujuan
  bool visible_marker_tujuan = false;
  //tombol harga pesan
  bool visible_harga_invalid = false;
  bool visible_button_order = false;
  bool visible_animation_waiting_order = false;
  bool visible_batalkan_pertama = false;
  bool bool_meminta_batal = true;
  Timer _timer;
  int _start = 30;
  bool visible_driver = false;
  bool visible_order_chat_telepon = false;
  bool visible_order_batal = false;
  bool visible_drag_icon = false;

  //SlidingUpPanel
  double _fabHeight;
  //double _panelHeightOpen;
  //double _panelHeightClosed = 195; //95.0;
  //bool _fabHidden= true;
  double maxHeight = 150.0;
  double minHeight = 150;
  double minBottomMap = 137;
  final PanelController _pc = PanelController();
  //map
  //String  keyApi= 'AIzaSyA706610W0aD4w2ueNR6seGrlHj5SpYOyM';
  /* StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;*/
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  static LatLng _initialPosition = LatLng(-3.47764787218, 119.141805461);
  static LatLng _lastMapPosition = LatLng(-3.47764787218, 119.141805461);
  Position _currentPosition;
  Position Posisi_hasil_cari;
  //map direction
  //int _polylineCount = 1;
  final Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  //final Set<Marker> _markers = {};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> markers_order = <MarkerId, Marker>{};
  //GoogleMapPolyline _googleMapPolyline =  GoogleMapPolyline(apiKey: 'AIzaSyBTokiA2EScfsUgZeuTcsTdpcrV11qAw8E');
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //membuat respon google
  // Response _responseGoogle;
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
  //Place _selectedPlace;
  double heightOfModalBottomSheet = 110;
  bool checkingFlight = false;
  bool success = false;
  bool habis_waktu_menunggu = false;
  String prov_1 = '';
  String prov_2 = '';

  //daftar harga
  List<DocumentSnapshot> documentListTarif;
  //variabel data kusioner
  // Default Radio Button Item kusioner
  String radioItem = 'Saya telah menunggu terlalu lama';
  int id_pilihan_kusioner = 1;
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

  /* @override
  void dispose() { 
    super.dispose(); 
   // _timer.cancel();
  }  */

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _createMarkerImageFromAsset('assets/motor.png');
    //cek internet
    _cekInternet();
    //_connectivity.initialise();
    // _connectivity.myStream.listen((source) {
    //   setState(() => _source = source);
    // });
    // _hasNetworkConnection = false;
    // _fallbackViewOn = false;
    // ConnectionStatusSingleton connectionStatus =   ConnectionStatusSingleton.getInstance();
    // connectionStatus.connectionChange.listen(_updateConnectivity);

    //regiter chanel resume app
    _initChanel();
    //mendapatkan gcm dilocal
    getGCM();

    //tampilan mode pertama dibuka
    ModeFirstOpen();
    selectDaftarHarga();
    getDriverPosisi();
  }

  void getCurrentUser() async {
    //currentUser = await FirebaseAuth.instance.currentUser();
    //print(widget.data_p['uid']);
    /* uidCustomer=widget.data_p['uid'];
      namaCustomer=widget.data_p['name'];
      saldoCustomer=widget.data_p['saldo'];
      pointCustomer=widget.data_p['point'];
      radiusCustomer=60;
      hpCustomer=widget.data_p['hp'];
      tripCustomer=widget.data_p['trip'];
      bintangCustomer= widget.data_p['bintang'];
      avatarCustomer=widget.data_p['avatar'] ;*/
    await databaseRef
        .collection('flutter_customer')
        .document(widget.dataP['uid'])
        .snapshots()
        .forEach((element) {
      //print(element['saldo']);
      setState(() {
        uidCustomer = element['uid'];
        namaCustomer = element['name'];
        saldoCustomer = element['saldo'];
        pointCustomer = element['point'];
        radiusCustomer = element['radius'];
        hpCustomer = '${element['hp']}';
        tripCustomer = '${element['trip']}';
        avatarCustomer = '${element['avatar']}';

        if (element['counter_reputation'] != 0 &&
            element['divide_reputation'] != 0) {
          //bintangCustomer = element['counter_reputation'] ~/ element['divide_reputation']  ;
        } else {
          //  bintangCustomer= '0';
        }
      });
    }).catchError((err) {
      print(err);
      if (mounted) {
        setState(() {
          uidCustomer = widget.dataP['uid'];
          namaCustomer = widget.dataP['name'];
          saldoCustomer = widget.dataP['saldo'];
          pointCustomer = widget.dataP['point'];
          radiusCustomer = 60;
          hpCustomer = widget.dataP['hp'];
          tripCustomer = widget.dataP['trip'];
          bintangCustomer = widget.dataP['bintang'];
          avatarCustomer = widget.dataP['avatar'];
        });
      }
    });

    /*await Firestore.instance
      .collection('flutter_customer')
      .document(currentUser.uid)
      .get()
      .then((DocumentSnapshot result)  {
         setState(() {
            namaCustomer=result['name'];
            saldoCustomer=result['saldo'] ;
            pointCustomer=result['point'] ;
         }); 
        }) 
      .catchError((err) {
         print(err);
         setState(() {
            namaCustomer='';
            saldoCustomer=0;
             pointCustomer=0;
         });  

      });*/
  }

  //mengabil data semua daftar harga tarif
  void selectDaftarHarga() async {
    try {
      documentListTarif =
          (await databaseRef.collection('flutter_tarif').getDocuments())
              .documents;
      //print(documentList);
      print(documentListTarif[0].data['harga']);
      //  movieController.sink.add(documentList);
      try {
        print('cccccccccccccccccccc ');
        if (documentListTarif.isEmpty) {
          //movieController.sink.addError('No Data Available');
          print('No Data Available');
        } else {
          print('mmmmmmmmmmmmmmmmmm ');
        }
      } catch (e) {
        print('dddddddddddddd ');
      }
    } on SocketException {
      print('eeeeeeeeeeeeeeeee ');
      print('No Internet Connection');
      // movieController.sink.addError(SocketException('No Internet Connection'));
    } catch (e) {
      print('fffffffffffffffff ');
      print(e.toString());
      // movieController.sink.addError(e);
    }
  }

  void _cekInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  //inisialisasi chanel resume
  Future<String> _initChanel() async {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      print('SystemChannels $msg');
      if (msg.contains('resumed')) {
        if (modeMap == 3) {
        } else {}
        // _getUserLocation();
        ModeFirstOpen();
        return '';
      }
      return '';
    });

    return '';
  }

  //mendapatkan gcm dilocal
  void getGCM() async {
    var localStorage = await SharedPreferences.getInstance();
    bearToken = localStorage.getString('token');
    gcmToken = localStorage.getString('gcm');
  }

  //mendapatkan lattitude posisi user
  //mengambil varibel posisi
  void _getUserLocation() {
    print(' _getUserLocation()');

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _lastMapPosition = _initialPosition;
        _currentPosition = position;
        Posisi_hasil_cari = position;
        _moveToPosition(position);
      });
    }).catchError((e) {
      ModeLoadingAdress();
      print(e);
    });
  }

  //perintah mengarahkan camera maps ke posisi tertentu
  Future<void> _moveToPosition(Position pos) async {
    mapController = await _controller.future;
    if (mapController == null) return;
    print('moving to position ${pos.latitude}, ${pos.longitude}');
    await mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 16.0,
      bearing: -20,
    )));
  }

  //digunakan untuk mendapatkan alama center map atau center marker
  //dan mengambil data variabel alamat
  //kemudian dikonversi ke alamat jemput atau tujuan
  void _getAdressLocation() async {
    print(' _getAdressLocation()');
    /*
    pengambilan data alamat pada server google maps
    berdasarkan posisi tengah maps atau marker yg berada di tengah
  
    1. hasil alamatnya akan dimasukkan ke variabel jemput atau tujuan
    
    */
    try {
      /*double  latitude =  _lastMapPosition.latitude ;
      double  longitude=  _lastMapPosition.longitude;
        http.Response response = await http.get(
          //Uri.encodeFull removes all the dashes or extra characters present in our Uri
          Uri.encodeFull('https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$key_api'),
          
          headers: {
            //if your api require key then pass your key here as well e.g 'key': 'my-long-key'
          'Accept': 'application/json' 
          }  
        );
       if (response.statusCode == 200) {
            String body = response.body;
            String receivedJson = '[$body]';
            List  data = json.decode(receivedJson); 
             print(  data[0]['results'][0]['formatted_address']);  
             print(data[0]['results'][0]['address_components'][0]['short_name']); 
              String short_name =data[0]['results'][0]['address_components'][0]['short_name']; 
             String formatted_address =data[0]['results'][0]['formatted_address'];
          
           setState(() {
              if (mode_map==0){
                jemput_tempat=short_name;
                jemput_alamat=formatted_address;
                jemputPosition = _lastMapPosition; 
              }else if (mode_map==1){
                  tujuan_tempat = short_name;
                  tujuan_alamat=formatted_address;
                  tujuanPosition = _lastMapPosition;
              } 
           });
             //LatLngBounds bound = LatLngBounds(southwest:tujuanPosition , northeast: jemputPosition  ); 
              
      }*/
      var placemark = await Geolocator().placemarkFromCoordinates(
          _lastMapPosition.latitude, _lastMapPosition.longitude);
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

        if (modeMap == 0) {
          jemputJudul = name;
          jemputAlamat = address;
          jemputPosition = _lastMapPosition;
          // prov_1 = '$administrativeArea $postalCode';
          prov_1 = '$administrativeArea';
          prov_1 = prov_1.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          ModeJemput();
        } else if (modeMap == 1) {
          tujuanJudul = name;
          tujuanAlamat = address;
          tujuanPosition = _lastMapPosition;
          // prov_2 = '$administrativeArea $postalCode';
          prov_2 = '$administrativeArea';
          prov_2 = prov_2.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          ModeTujuan();
        }
      });
    } catch (e) {
      print('ERRORku>>$_lastMapPosition:$e');
      ModeLoadingAdress();
      //visible_button_set=false;
      // _initialPosition = null;
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
      //_polylineCount++;
    });

    var latMin = 0.0;
    var latMax = 0.0;
    var longMin = 0.0;
    var longMax = 0.0;

    if (jemputPosition.latitude >= tujuanPosition.latitude) {
      latMin = tujuanPosition.latitude;
      latMax = jemputPosition.latitude;
      longMin = tujuanPosition.longitude;
      longMax = jemputPosition.longitude;

      if (longMin >= longMax) {
        longMin = jemputPosition.longitude;
        longMax = tujuanPosition.longitude;
      }
    } else {
      latMin = jemputPosition.latitude;
      latMax = tujuanPosition.latitude;

      longMin = tujuanPosition.longitude;
      longMax = jemputPosition.longitude;

      if (longMin >= longMax) {
        longMin = jemputPosition.longitude;
        longMax = tujuanPosition.longitude;
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
      var origin = '${jemputPosition.latitude},${jemputPosition.longitude}';
      var destination =
          '${tujuanPosition.latitude},${tujuanPosition.longitude}';

      var data_post = {
        'mode': 'driving',
        'key': CallApi.keyApi,
        'origin': origin,
        'destination': destination,
      };
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
          .timeout(const Duration(seconds: 10))
          .then((onResponse) {
        // print(onResponse.body);
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

            setState(() {
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
              _polylines.clear();
            });

            // List  data_steps =  data[0]['routes'][0]['legs'][0]['steps'];
            // data_steps.forEach((element) {
            //   print (element['polyline']['points']) ;
            //    _addPolyline(decodeEncodedPolyline( element['polyline']['points']));
            // });

            _addPolyline(decodeEncodedPolyline(
                data[0]['routes'][0]['overview_polyline']['points']));

            //menyesuaikan lokasi  yg terjangkau
            var arr_prov = [
              '91353',
              '90222',
              'SulawesiBarat91353',
              'SulawesiSelatan90222',
              'SulawesiBarat',
              'SulawesiSelatan',
              'SouthSulawesi',
              'WestSulawesi',
            ];
            arr_prov.forEach((element) {
              if (element == prov_1) {
                setState(() {
                  provAktif1 = true;
                });
              }
              if (element == prov_2) {
                setState(() {
                  provAktif2 = true;
                });
              }
            });

            //terlalu dekat dibawah 500 meter
            if (data[0]['routes'][0]['legs'][0]['distance']['value'] <= 300) {
              ModeReadyToOrder(false,
                  'Harga tidak dapat ditampilkan, jarak terlalu dekat :) ');
            } else if (data[0]['routes'][0]['legs'][0]['distance']['value'] >=
                100000) {
              ModeReadyToOrder(false,
                  'Harga tidak dapat ditampilkan, jarak terlalu jauh, batas maksimal 100 km :) ');
            } else if (provAktif1 == false && provAktif2 == false) {
              //diluar kententuan lokasi
              ModeReadyToOrder(
                  false, 'Harga untuk di kota ini belum dapat ditampilkan :) ');
            } else if (documentListTarif.isEmpty) {
              ModeReadyToOrder(false,
                  'Harga tidak dapat ditampilkan, silahkan ulangi order :) ');
            } else {
              print('object1');
              //hitung Harga sebelum ke mode ready order
              _hitungHargaTotal();
            }
          }
        } else {
          print('object2');
          ModeReadyToOrder(false,
              'Harga tidak dapat ditampilkan, silahkan ulangi order :) ');
        }
      }).catchError((onerror) {
        print(onerror.toString());
        print('object3');
        ModeReadyToOrder(
            false, 'Harga tidak dapat ditampilkan, silahkan ulangi order :) ');
      });
    } catch (e) {
      print('object4');
      ModeReadyToOrder(
          false, 'Harga tidak dapat ditampilkan, silahkan ulangi order :) ');
      print('error!!!! $e');
    }
  }

  //penyiman data order ke server
  //apakah suskes atau tidak
  //jika ya maka silahkan tunggu driver
  //jika gagal maka silahkan tombol order di ulangi
  Future<void> getJsonPostOrder() async {
    try {
      var dataPost1 = {
        'order': order,
      };
      await http
          .post(
            Uri.encodeFull(GojekGlobal.domainUrl + 'gojekorder'),
            headers: {
              'Accept': 'application/json',
              'Content-type': 'application/json',
              'Authorization': 'Bearer $bearToken'
            },
            body: json.encode(dataPost1),
          )
          .timeout(const Duration(seconds: 10))
          .then((onResponse) {
        // print(json.encode(data_post1) );
        //print(onResponse.body);
        //onResponse.request.finalize();
        if (onResponse.statusCode == 200) {
          // String body = onResponse.body;
          // String receivedJson = '[$body]';
          // List  data = json.decode(receivedJson);
          print(
              'pertahankan mode sampai timer habis dan sampai dibalas oleh driver');
        } else {
          print('object2');
          setState(() {
            habis_waktu_menunggu = false;
          });
          ModeReseiveFalse(
              'Koneksi internet mungkin lagi lelet, Silah ulangi order');
        }
      }).catchError((onerror) {
        print(onerror.toString());
        print('object3');
        setState(() {
          habis_waktu_menunggu = false;
        });
        ModeReseiveFalse(
            'Koneksi internet mungkin lagi lelet, Silah ulangi order');
      });
    } catch (e) {
      print('object4');
      setState(() {
        habis_waktu_menunggu = false;
      });
      ModeReseiveFalse(
          'Koneksi internet mungkin lagi lelet, Silah ulangi order');
      print('error!!!! $e');
    }
  }

  //mengambil posisi driver untuk untuk map
  //sekalgus menjadikan variabel tersebut sebagai broadcast untuk gcm permintaan order
  void getDriverPosisi() {
    geo = Geoflutterfire();
    var center = geo.point(
        latitude: _initialPosition.latitude,
        longitude: _initialPosition.longitude);
    var collectionReference = databaseRef
        .collection('flutter_driver')
        .where('status_driver', isEqualTo: 'siap')
        .where('blok', isEqualTo: false)
        //.orderBy('trip')
        .limit(20);

    stream = geo.collection(collectionRef: collectionReference).within(
        center: center,
        radius: radiusCustomer.toDouble(),
        field: 'position',
        strictMode: true);

    setState(() {
      stream.listen((List<DocumentSnapshot> documentListDriver) {
        print('blokblokblokblokblokblokblokblokblokblokblokblok');
        _updateMarkers(documentListDriver);
      });
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentListDriver) {
    drivers_gcm.clear();
    markers.clear();

    documentListDriver.forEach((DocumentSnapshot document) {
      GeoPoint point = document.data['position']['geopoint'];
      drivers_gcm.add(document.data['gcm']);
      // print( document.data['gcm']);
      _addMarker(point.latitude, point.longitude);
    });
  }

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

  void _checkKodeTambahOrder() {
    //kd_transfer 10 digit
    var rnd = Random();
    var min = 10000000, max = 99999999;
    var kd_rnd = min + rnd.nextInt(max - min);

    var rnd1 = Random();
    var min1 = 1000, max1 = 9999;
    var kd_rnd1 = min1 + rnd1.nextInt(max1 - min1);

    // if(order==''){
    order = '$kd_rnd1$kd_rnd';
    print(order);

    /// }else{
    //   order=order;
    // }
    //cek apakah kode belum terpakai
    databaseRef
        .collection('flutter_order')
        .where('category_driver', isEqualTo: category_driver)
        .where('kd_transaksi', isEqualTo: '$order')
        .getDocuments()
        .then((event) {
      if (event.documents.isEmpty) {
        documentIDNYA = '';
        var documentReference =
            databaseRef.collection('flutter_order').document();
        documentReference.setData({
          'kd_transaksi': '$order',
          'driver_id': '',
          'status_driver': '',
          'status_order': '',
          'charge': charge,
          'pay_categories': pay_categories,
          'point_transaction': point_transaction,
          'category_driver': category_driver,
          'category_order': category_driver,
          'polyline': polyline_order,
          'distance_text': distanceText,
          'total_prices': totalPrices,
          'distance_value': distanceValue,
          'duration_text': duration_text,
          'duration_value': duration_value,
          'jemput_alamat': jemputAlamat,
          'jemput_judul': jemputJudul,
          'jemput_ket': jemputKet,
          'tujuan_alamat': tujuanAlamat,
          'tujuan_judul': tujuanJudul,

          //'pelanggan': namaCustomer,
          'pelanggan_uid': uidCustomer,
          //'pelanggan_avatar':avatarCustomer,
          //'pelanggan_hp': hpCustomer,
          //'pelanggan_bintang': bintangCustomer,
          //'pelanggan_trip': tripCustomer,
          'created': FieldValue.serverTimestamp(),
          'cancel_id': '',
          'id': documentReference.documentID
          /*  
                    'price': int.tryParse(priceController.text), 
                    'created': DateTime.fromMillisecondsSinceEpoch(created.creationTimeMillis, isUtc: true).toString(),
                    'modified': DateTime.fromMillisecondsSinceEpoch(created.updatedTimeMillis, isUtc: true).toString(), 
                   */
        }).whenComplete(() async {
          if (documentIDNYA == '') {
            // print('documentReference.documentIDmmmmmmmmm' );
            setState(() {
              habis_waktu_menunggu = false;
            });
            ModeReseiveFalse(
                'Koneksi internet mungkin lagi lelet, Silah ulangi order');
          } else {
            //kurangi saldo jika bayar pakai saldo
            if (pay_categories == 'saldo') {
              await databaseRef
                  .collection('flutter_customer')
                  .getDocuments()
                  .then((querySnapshot) {
                querySnapshot.documents.forEach((result) {
                  databaseRef
                      .collection('flutter_customer')
                      .document(uidCustomer)
                      .updateData({
                    'saldo': (result.data['saldo']) - totalPrices
                  }).whenComplete(() {
                    _kirimOrderGcm();
                  }).catchError((err) {
                    // databaseRef.collection('flutter_order')
                    // .document(documentIDNYA).delete().then((_) {
                    //      print('!success delete');
                    // });
                    _batalkanOrderPertama(documentIDNYA, '');
                    setState(() {
                      habis_waktu_menunggu = false;
                    });
                    ModeReseiveFalse(
                        'Koneksi internet mungkin lagi lelet, Silah ulangi order');
                  });
                });
              });
            } else {
              _kirimOrderGcm();
            }
            visible_batalkan_pertama = true;
          }
        }).catchError((err) {
          setState(() {
            habis_waktu_menunggu = false;
          });
          ModeReseiveFalse(
              'Koneksi internet mungkin lagi lelet, Silah ulangi order');
        });
        documentIDNYA = documentReference.documentID;
      } else {
        setState(() {
          habis_waktu_menunggu = false;
        });
        ModeReseiveFalse(
            'Koneksi internet mungkin lagi lelet, Silah ulangi order');
      }
    }).catchError((e) {
      setState(() {
        habis_waktu_menunggu = false;
      });
      ModeReseiveFalse(
          'Koneksi internet mungkin lagi lelet, Silah ulangi order');
    });
  }

  void _kirimOrderGcm() async {
    // print(order);
    data_order_filter.clear();
    data_order_filter['kd_transaksi'] = '$order';
    data_order_filter['driver_id'] = '';
    data_order_filter['status_driver'] = '';
    data_order_filter['status_order'] = '';
    data_order_filter['charge'] = charge;
    data_order_filter['distance_text'] = distanceText;
    //data_order_filter['distance_value']=distance_value;
    //data_order_filter['duration_text']=duration_text;
    //data_order_filter['duration_value']=duration_value;
    data_order_filter['pay_categories'] = pay_categories;
    data_order_filter['category_driver'] = category_driver;
    data_order_filter['category_order'] = category_driver;
    data_order_filter['point_transaction'] = point_transaction;
    data_order_filter['polyline'] = polyline_order;
    data_order_filter['total_prices'] = totalPrices;
    data_order_filter['tujuan_alamat'] = tujuanAlamat;
    data_order_filter['tujuan_judul'] = tujuanJudul;
    data_order_filter['jemput_alamat'] = jemputAlamat;
    data_order_filter['jemput_judul'] = jemputJudul;
    data_order_filter['jemput_ket'] = jemputKet;

    data_order_filter['pelanggan_uid'] = uidCustomer;
    data_order_filter['pelanggan'] = namaCustomer;
    data_order_filter['pelanggan_hp'] = hpCustomer;
    data_order_filter['pelanggan_bintang'] = tripCustomer;
    data_order_filter['pelanggan_trip'] = bintangCustomer;
    data_order_filter['pelanggan_gcm'] = gcmToken;
    data_order_filter['pelanggan_avatar'] = avatarCustomer;

    var data = {
      'registration_ids': drivers_gcm,
      'priority': 'high',
      'time_to_live': 60,
      'data': {
        'body': 'body',
        'title': 'title',
        'message': 'message',
        'timing': DateTime.now().millisecondsSinceEpoch.toInt(),
        'order': '$order',
        'category_order': 'godriver', //'ojek_motor',
        'data_json': data_order_filter,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      }
    };
    var res = await CallApi().postData(data, 'gcm');
    if (res.statusCode == 200) {
      var receivedJson = '[${res.body}]';

      List data = json.decode(receivedJson);
      // print(data[0]['success']);
      if (data[0]['success'] == '0') {
        await _batalkanOrderPertama(documentIDNYA, '');
        setState(() {
          habis_waktu_menunggu = false;
        });
        ModeReseiveFalse(
            'Koneksi internet mungkin lagi lelet, Silah ulangi order');
      } else {
        print(
            'pertahankan mode sampai timer habis dan sampai dibalas oleh driver');
      }
      /*await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sukses'),
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
        });*/

    } else {
      await _batalkanOrderPertama(documentIDNYA, '');
      setState(() {
        habis_waktu_menunggu = false;
      });
      ModeReseiveFalse(
          'Koneksi internet mungkin lagi lelet, Silah ulangi order');
    }
  }

  Future<void> _batalkanOrderPertama(
      String id_order, String pilihan_kusioner) async {
    await databaseRef
        .collection('flutter_order')
        .where('id', isEqualTo: id_order)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((result_order) async {
        if (result_order.data['pay_categories'] == 'saldo' &&
            result_order.data['status_order'] != 'batal') {
          await databaseRef
              .collection('flutter_customer')
              .where('uid', isEqualTo: uidCustomer)
              .getDocuments()
              .then((QuerySnapshot snapsh) {
                snapsh.documents.forEach((result_customer) async {
                  await databaseRef
                      .collection('flutter_order')
                      .document(documentIDNYA)
                      .updateData({
                    'status_order': 'batal',
                    'cancel_id': pilihan_kusioner,
                  }).then((res) {
                    databaseRef
                        .collection('flutter_customer')
                        .document(uidCustomer)
                        .updateData({
                      'saldo': result_order.data['total_prices'] +
                          result_customer.data['saldo']
                    }).whenComplete(() {
                      if (bool_meminta_batal == false) {
                        setState(() {
                          bool_meminta_batal = true;
                        });
                        ModeFirstOpen();
                      }
                    }).catchError((err) {
                      //_batalkanOrderPertama(documentIDNYA);
                    });
                  }).catchError((err) {});
                });
              })
              .whenComplete(() {})
              .catchError((err) {});
        } else {
          await databaseRef
              .collection('flutter_order')
              .document(documentIDNYA)
              .updateData({
            'status_order': 'batal',
            'cancel_id': pilihan_kusioner,
          }).then((res) {
            if (bool_meminta_batal == false) {
              setState(() {
                bool_meminta_batal = true;
              });
              ModeFirstOpen();
            }
          }).catchError((err) {});
        }
      });
    });
  }

  //mengirim survei kusioner batal ke server
  Future<void> _sendKusionerDanBatal(String no_order) async {
    await _batalkanOrderPertama(documentIDNYA, id_pilihan_kusioner.toString());
  }

  //notifikasi untuk data order di terima oleh driver
  void setAcceptOrder(Map<dynamic, dynamic> dataMasuk) async {
    try {
      //cek jika order sama dengan yg masuk dengan yg barusan dikirim
      print(' ${dataMasuk['order']} ------------  $order  ');
      if (dataMasuk['order'] == order &&
          dataMasuk['category_message'] == 'accept_order') {
        //set data json orderan
        setState(() {
          orderan = OrderanJson.fromJson(jsonDecode(dataMasuk['data_json']));
        });
        //mode permintaan order diterima driver
        ModeReseiveTrue();
      } else if (dataMasuk['order'] == order &&
          dataMasuk['category_message'] == 'cancel_order') {
        //mode dimana kembalikan ke default karena orederan dibatalkan driver
        //jika mode masih dalam keadaan order diterima atau no order sama yg datang dengan yg dihalaman
        //_getUserLocation();
        ModeFirstOpen();
      }
    } catch (e) {
      print('print err, from service: $e');
      throw (e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //_panelHeightOpen = MediaQuery.of(context).size.height ;
    //double fullSizeHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      /*onWillPop: () async {
            setState((){  
                     _start=0;  
                      if(_timer  ==null){
                        
                      } else{
                          _timer.cancel();
                      } 
            });
          await Future.delayed(Duration(seconds:5)); 
           await Fluttertoast.showToast(
              msg: 'Some text',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
          ); 
  
          return true;
      },*/
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Informasi'),
          content: Text('Anda yakin ingin keluar?'),
          actions: [
            FlatButton(
              child: Text('Ya'),
              onPressed: () {
                setState(() {
                  // _start=0;
                  if (_timer == null) {
                  } else {
                    _timer.cancel();
                  }
                });
                Navigator.pop(c, true);
              },
            ),
            FlatButton(
              child: Text('Tidak'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme:   ThemeData(
        //primarySwatch: Colors.teal,
        // canvasColor: Colors.transparent,
        // ),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // transparent status bar
            systemNavigationBarColor: Colors.black, // navigation bar color
            statusBarIconBrightness: Brightness.dark, // status bar icons' color
            systemNavigationBarIconBrightness:
                Brightness.dark, //navigation bar icons' color
          ),
          child: //SizedBox.expand(
              //jika loadng map jika tidak ingin pakai loading map silahkan ganti
              _initialPosition == null
                  ? Container(
                      child: Center(
                        child: Text(
                          'loading map..',
                          style: TextStyle(
                              fontFamily: 'Avenir-Medium',
                              color: Colors.grey[400]),
                        ),
                      ),
                    )
                  : Container(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height -
                                minBottomMap,
                            alignment: Alignment.topCenter,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[InkWell(child: _body())],
                            ),
                          ),
                          /* Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: <Widget>[ 
                      Container(
                        height: MediaQuery.of(context).size.height- (minBottomMap+5) ,
                          alignment: Alignment.topCenter,
                          child:    Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                    
                                InkWell( 
                                  child:  _body()
                                )
                              ],
                            ),
                      )  
                ],
             ), */

                          /*
              SlidingUpPanel(  
                maxHeight:100  ,//  _panelHeightOpen,
                minHeight:60  ,//   _panelHeightClosed,
                controller: _pc1,
                parallaxOffset: .0,
                defaultPanelState: PanelState.CLOSED,   
                parallaxEnabled: false, 
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                panel: Center(
                  child:  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.cyan,
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Camera moving: $_fabHeight',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ) 
                ),
                
              ),  
               */

                          /* 
               Positioned(
            top: 60,
            left: MediaQuery.of(context).size.width * 0.05,
            // width: MediaQuery.of(context).size.width * 0.9,
            child: SearchMapPlaceWidget(
              apiKey: key_api,
              location: _lastMapPosition,
              radius: 30000,
              onSelected: (place) async {
                
                
                 final geolocation = await place.geolocation;

                final GoogleMapController controller_ = await _controller.future;

                 await controller_.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                 await controller_.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
              },
            ),
          ),
                  */

                          // the fab
                          Positioned(
                            right: 15.0,
                            bottom: _fabHeight,
                            child: Visibility(
                              visible: _fabVisible,
                              //  maintainAnimation: true,
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
                                    //createRecord();
                                  },
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          //the  jarak
                          Visibility(
                            visible: visible_distance_text,
                            child: Positioned(
                              top: 52.0,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 5.0, 5.0),
                                child: Text(
                                  '$distanceText',
                                  style: TextStyle(
                                    fontFamily: 'NeoSans',
                                    fontSize: 12,
                                    color: Colors.blue,
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
                          ),

                          //marker jemput
                          Visibility(
                            visible: visible_marker_jemput,
                            child: Positioned(
                                top: ((MediaQuery.of(context).size.height -
                                            iconSize) -
                                        (minBottomMap + 80)) /
                                    2,
                                right: (MediaQuery.of(context).size.width -
                                        iconSize) /
                                    2,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      margin: EdgeInsets.all(1.0),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle),
                                      child: Icon(Icons.gps_fixed,
                                          size: 24, color: Colors.white),
                                    ),
                                    Container(
                                      height: 18.0,
                                      width: 2.5,
                                      color: Colors.blue,
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                    ),
                                  ],
                                )),
                          ),

                          //marker tujuan
                          Visibility(
                            visible: visible_marker_tujuan,
                            child: Positioned(
                                top: ((MediaQuery.of(context).size.height -
                                            iconSize) -
                                        (minBottomMap + 80)) /
                                    2,
                                right: (MediaQuery.of(context).size.width -
                                        iconSize) /
                                    2,
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
                                      height: 18.0,
                                      width: 2.5,
                                      color: Colors.orange,
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                    ),
                                  ],
                                )),
                          ),

                          SlidingUpPanel(
                            backdropEnabled: false,
                            maxHeight: maxHeight, //_panelHeightOpen,
                            minHeight: minHeight, //_panelHeightClosed,
                            parallaxEnabled: true,
                            parallaxOffset: .5,
                            controller: _pc,
                            // body:    _body(),
                            panelBuilder: (sc) => _panel(sc),
                            // panel:  _panel(sc),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0)),
                            onPanelSlide: (double pos) => setState(() {
                              // _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
                              if (_fabHeight >= 230) {
                                //_fabHidden=false;
                              } else {
                                //_fabHidden= true ;
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  //tempat google maps atau peta dan marker
  Widget _body() {
    return GoogleMap(
      polylines: Set<Polyline>.of(_polylines.values),
      //markers: _markers,
      markers: modeMap == 3
          ? Set<Marker>.of(markers_order.values)
          : Set<Marker>.of(markers.values),
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: false,
      myLocationEnabled: false,
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
        target: _initialPosition ?? LatLng(-3.47764787218, 119.141805461),
        zoom: 16.0,
        bearing: 20, //berputar
      ),
      //markers: _markers.values.toSet(),
      onCameraMoveStarted: () {
        //print('onCameraMoveStarted');
      },
      onCameraMove: (CameraPosition cameraPosition) {
        _lastMapPosition = cameraPosition.target;
        if (modeMap == 0 || modeMap == 1) {
          ModeLoadingAdress();
        }
      },
      onCameraIdle: () {
        if (modeMap == 0 || modeMap == 1) {
          if (_currentPosition != null) {
            _getAdressLocation();
          } else {
            _getUserLocation();
          }
        }
        setState(() {
          //mengendalikan tomobol harga jika kamera berhrnti bergerak
          //  if ( suskes_load_ahrga && mode_map==2 ){

          //   visible_button_order= true;
          //   visible_harga_invalid = false;
          // }
          // if ( suskes_load_ahrga==false && mode_map==2 ){ {
          //    visible_button_order= false;
          //  visible_harga_invalid = true;

          //  }
        });
      },
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          //maxHeight   = 0;
          //minHeight   = 0 ;
          // minBottomMap  = -10;
          if (mapController == null) {
            mapController = controller;
            _controller.complete(controller);
          }
        });
      },
    );
  }

  //tempat bottom sheet dan data harga,order dan lain
  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: ListView(
          controller: sc,
          children: <Widget>[
            //icon drag
            Visibility(
              visible: visible_drag_icon,
              child: Icon(Icons.drag_handle, size: 16.0, color: Colors.grey),
            ),

            //order diterima oleh driver
            Visibility(
              visible: visible_driver,
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: CircleAvatar(
                      radius: 24.0,
                      backgroundImage: NetworkImage(orderan.driver_avatar),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Text('${orderan.driver}',
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
                                  size: 16.0, color: Colors.orange),
                              Text(
                                '${orderan.driver_bintang}',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'NeoSans',
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Icon(Icons.directions_bike,
                                  size: 16.0, color: Colors.orange),
                              Text('${orderan.driver_trip}',
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontFamily: 'NeoSans',
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal,
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
              visible: visibleHeaderJemput,
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$_setText',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 0,
                      fontSize: 18, color: Colors.black,
                      fontFamily: 'NeoSansBold',
                      decoration: TextDecoration.none,
                      //  decorationStyle: TextDecorationStyle.dashed,
                    ),
                  ),
                  /*Align( 
                    child: Container(  
                       margin:   EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                      width: 70,
                      height: 26,
                      child: OutlineButton(  
                        child: Text(
                            'UBAH',
                            style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'NeoSans',
                                  fontSize: 11, 
                                  letterSpacing: 0,
                            ), 
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:   BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)
                        ),
                        onPressed: () {}, //callback when button is clicked
                        borderSide: BorderSide(
                          color: Colors.green, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: 0.8, //width of the border
                        ), 
                      ),
                    ),
                  ) */
                ],
              ),
            ),

            //2 header pilihan kategori kedaraan
            Visibility(
              visible: visible_mode_bayar,
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$header_category',
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
                      margin:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                      child: OutlineButton(
                        child: Text(
                          '$penumpang',
                          style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'NeoSans',
                            fontSize: 11,
                            letterSpacing: 0,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(color: Colors.green)),

                        onPressed: () {
                          _showModePesanan();
                        }, //callback when button is clicked
                        borderSide: BorderSide(
                          color: Colors.green, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: 0.8, //width of the border
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
              visible: visibleJemput,
              child: RaisedButton(
                onPressed: () {
                  modeCari = 0;
                  _showCari();
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
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child:
                          Icon(Icons.gps_fixed, size: 32.0, color: Colors.blue),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jemput : $jemputJudul',
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'NeoSans',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(
                            jemputAlamat,
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
                    Icon(Icons.search, size: 16.0, color: Colors.grey),
                  ],
                ),
              ),
            ),

            //4
            Visibility(
              visible: visible_divider_buttom_jemput,
              maintainSize: false,
              child: Divider(
                color: Colors.grey,
                height: 5,
              ),
            ),

            //5 Shimmer
            Visibility(
              visible: visible_Shimmer,
              child: SizedBox(
                width: 200.0,
                height: 50.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: GojekPalette.grey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6, top: 3),
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              color: Color(0xffcacaca),
                              borderRadius: BorderRadius.circular(16.5)),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 11,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Color(0xffcacaca),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 11,
                              width: 230,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 11,
                              width: 230,
                              decoration: BoxDecoration(
                                  color: Color(0xffcacaca),
                                  borderRadius: BorderRadius.circular(5)),
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
              visible: visibleTujuan,
              child: RaisedButton(
                onPressed: () {
                  modeCari = 1;
                  _showCari();
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
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child:
                          Icon(Icons.adjust, size: 32.0, color: Colors.orange),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tujuan : $tujuanJudul',
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'NeoSans',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(tujuanAlamat,
                              maxLines: 3,
                              style: TextStyle(
                                fontFamily: 'NeoSans',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0,
                              )),
                        ],
                      ),
                    ),
                    Icon(Icons.search, size: 16.0, color: Colors.grey),
                  ],
                ),
              ),
            ),

            //7
            Visibility(
              visible: visible_divider_buttom_tujuan,
              maintainSize: false,
              child: Divider(
                color: Colors.grey,
                height: 5,
              ),
            ),

            //8 keterangan jemput
            Visibility(
              maintainSize: false,
              visible: visibleTextKeterangan,
              child: Container(
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
                      padding: const EdgeInsets.only(left: 5, right: 0),
                      child:
                          Icon(Icons.message, size: 24.0, color: Colors.green),
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
                            hintText: 'Rincian alamat...'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //9
            Visibility(
              visible: visible_divider_buttom_keterangan,
              maintainSize: false,
              child: Divider(
                color: Colors.grey,
                height: 5,
              ),
            ),

            //10 button set
            Visibility(
              maintainSize: false,
              visible: visibleButtonSet,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.green,
                child: Text('Set $_setText'),
                onPressed: () {
                  if (modeMap == 0) {
                    ModeTujuan();
                    _moveToPosition(_currentPosition);
                  } else if (modeMap == 1) {
                    ModeLoadPrice(true);
                  } else if (modeMap == 2) {}
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),

            // mode bayar tunai dan lain lain
            Visibility(
              maintainSize: false,
              visible: visible_mode_bayar,
              child: RaisedButton(
                onPressed: () {
                  _showModeBayar();
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
                            pay_categories == 'tunai'
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
                    Icon(Icons.more_vert, size: 24.0, color: Colors.grey),
                  ],
                ),
              ),
            ),

            //11 button order
            Visibility(
                visible: visible_button_order,
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
                        'Rp ${uang.format(totalPrices)}',
                        style: TextStyle(
                          fontFamily: 'NeoSans',
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, bottom: 2),
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: Colors.orange,
                          child: Icon(Icons.send,
                              size: 16.0, color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (drivers_gcm.isNotEmpty) {
                      ModeRequestOrder();
                    } else {
                      _errorDriverNotFount();
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                )),

            //12 harga tidak muncul
            Visibility(
              visible: visible_harga_invalid,
              child: RaisedButton(
                color: Colors.green,
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.orange,
                  child: Text(
                    'UPSS, HARGA TIDAK MUNCUL',
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
                  borderRadius: BorderRadius.circular(16.0),
                ),
                onPressed: () {
                  ModeLoadPrice(true);
                },
              ),
            ),

            //13 animation mode waiting reseive order respon
            //dan batal sebelum terima
            Visibility(
                visible: visible_animation_waiting_order,
                child: Container(
                    height: 100,
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          bool_meminta_batal == true
                              ? 'Sabar yaa....  $_start '
                              : 'Order akan dibatlkan',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'NeoSans',
                            fontSize: 20.0,
                            letterSpacing: 0,
                            color: Colors.blue,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Visibility(
                              visible: visible_batalkan_pertama,
                              child: MaterialButton(
                                elevation: 1.0,
                                minWidth: double.infinity,
                                height: 43.0,
                                color: Colors.blue,
                                child: bool_meminta_batal == true
                                    ? Text(
                                        'Batalkan',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'NeoSans',
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                        ),
                                      )
                                    : CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                onPressed: () async {
                                  //batal biasa langsung matikan timer dan kembalikan mode ready order
                                  //kembalikan ke mode load price tapi bukan minta harga ke server akan tetapi harga sebelumnya diambil
                                  if (bool_meminta_batal == true) {
                                    setState(() {
                                      bool_meminta_batal = false;
                                    });
                                    _start = 0;
                                    _timer.cancel();
                                    await _batalkanOrderPertama(
                                        documentIDNYA, '');
                                    //await Future.delayed(Duration(seconds:3));
                                    // bool_meminta_batal=true;
                                    //ModeLoadPrice(false);
                                    // await Future.delayed(Duration(seconds:1));
                                    // ModeReadyToOrder(true,'');
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              )),
                        )
                      ],
                    ))),

            //order chat dan telepon
            Visibility(
              visible: visible_order_chat_telepon,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 45,
                    child: RaisedButton(
                      onPressed: () {
                        launch('tel://${orderan.driver_hp}');
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.call, size: 24.0, color: Colors.grey),
                          Text(
                            ' Telepon',
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
                  Container(
                    height: 45,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chat(
                                      dataP: widget.dataP,
                                      peerId: '${orderan.driver_uid}',
                                      peerAvatar: '${orderan.driver_avatar}',
                                    )));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.message, size: 24.0, color: Colors.grey),
                          Text(
                            ' Chat',
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
                  )
                ],
              ),
            ),

            //tombol batal order yg telah diterima driver
            Visibility(
                visible: visible_order_batal,
                child: Center(
                  child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          id_pilihan_kusioner = 1;
                        });
                        _showKusionerGagal();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
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
      ),
    );
  }

  void _hitungHargaTotal() {
    /***************
    0=motor awal price ditampilakan
    1=ganti mode bayar tunai atau saldo
    2= ganti jenis orderan

    1.mode hitung adalah dari mana asal perintah dihitung
    2.apakah dari select metode bayar 
    3.atau select jenis orderan motor atau car4 dan car6
    4.atau ada diskon dan lain lain
    ***********/
    order = '';
    if (documentListTarif.isNotEmpty) {
      //  print(documentListTarif.length) ;

      documentListTarif.forEach((element) {
        print(distanceValue);
        if (element.data['category_driver'] == category_driver) {
          //konversi ke integr
          var distance_value_int = int.parse(distanceValue);

          //mulai menghitung semu jenis harga
          //meter ke kilo meter bisa jadi terdapat koma
          //pembulatan meter ke km
          var kilo_dari_meter = ((distance_value_int + 1) ~/ 1000).round();

          var prices_rumus = 0;
          var total_rumus = 0;

          if (kilo_dari_meter <= element.data['distance_looping_km']) {
            //dibawah jarak looping atau dibawah jarak standar yg ditetapkan pemerintah
            //atau dengan kata lain harga sesuai kondisi lokasi pasar atau pemukiman
            prices_rumus = element.data['price_per_km'] * kilo_dari_meter;
          } else {
            //bulatkan ke bawah km berapa kali looping
            var berapa_kali_looping =
                (kilo_dari_meter ~/ element.data['distance_looping_km'])
                    .floor();

            //harga hasil looping tergantung looping dan harga looping
            var harga_hasil_looping =
                element.data['price_looping_km'] * berapa_kali_looping;

            //mengambil sisa km
            var sisa_kilometer =
                (kilo_dari_meter / element.data['distance_looping_km']) -
                    berapa_kali_looping;

            //bulatakan ketas sisa km looping dikali harga per kilo
            var harga_sisa_kilometer =
                (sisa_kilometer).ceil() * element.data['price_per_km'];

            prices_rumus = harga_hasil_looping + harga_sisa_kilometer;
          }

          if (pay_categories == 'tunai') {
            total_rumus = (prices_rumus +
                    element.data['charge'] +
                    element.data['basic_price']) -
                element.data['discon_tunai'];
          }
          if (pay_categories == 'saldo') {
            total_rumus = (prices_rumus +
                    element.data['charge'] +
                    element.data['basic_price']) -
                element.data['discon_saldo'];
          }

          point_transaction = element.data['point_transaction'];
          charge = element.data['charge'];

          totalPrices = total_rumus;
        }
      });

      ModeReadyToOrder(true, '');
    } else {
      ModeReadyToOrder(false, '');
    }
  }

  void setModeKendaraan(String kendaraan) {
    if (category_driver != kendaraan &&
        int.parse(distanceValue) >= 300 &&
        int.parse(distanceValue) <= 100000) {
      setState(() {
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
      });
      _hitungHargaTotal();
      if (pay_categories == 'saldo') {
        if (saldoCustomer >= totalPrices) {
        } else {
          setState(() {
            pay_categories = 'tunai';
          });
          _hitungHargaTotal();
        }
      }
    }
  }

  void setModeBayar(String modeBayar) {
    if (pay_categories != modeBayar &&
        int.parse(distanceValue) >= 300 &&
        int.parse(distanceValue) <= 100000) {
      if (modeBayar == 'saldo') {
        setState(() {
          pay_categories = modeBayar;
        });
        _hitungHargaTotal();
        if (saldoCustomer >= totalPrices) {
          setState(() {
            pay_categories = modeBayar;
          });
          _hitungHargaTotal();
        } else {
          setState(() {
            pay_categories = 'tunai';
          });
          _hitungHargaTotal();
        }
      } else {
        setState(() {
          pay_categories = modeBayar;
        });
        _hitungHargaTotal();
      }
    }
  }

  void ModeFirstOpen() {
    print('ModeFirstOpen');
    _getUserLocation();
    modeMap =
        99; //mode 99 adalah mode awal map dimana akan di cek ke internet apakah ada orderan
    _polylines.clear();
    markers_order.clear();

    _fabVisible = false;
    _fabHeight = 166;
    maxHeight = 150;
    minHeight = 150;
    minBottomMap = 137;

    _setText = 'Pencarian lokasi...';
    mapTempat = '';
    mapAlamat = '';
    jemputJudul = '';
    jemputAlamat = '';
    jemputKet = '';

    tujuanJudul = '';
    tujuanAlamat = '';

    //harga
    pay_categories = 'tunai';
    totalPrices = 0;
    distanceText = '0';
    distanceValue = '0';
    duration_text = '0';
    duration_value = '0';
    _start = 30;
    order = '';
    _placePredictions = [];

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

    habis_waktu_menunggu = false;

    modeMap = 0;
  }

  void ModeLoadingAdress() {
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

    _fabVisible = false;
    visibleTextKeterangan = false;
    visibleButtonSet = false;
    visible_button_order = false;
    visible_harga_invalid = false;
    visible_animation_waiting_order = false;
    visible_batalkan_pertama = false;
    visible_mode_bayar = false;
    visible_distance_text = false;
    // print('ModeLoadingAdress $mode_map');

    setState(() {
      if (modeMap == 0) {
        _pc.panelPosition = 0.2;
        visible_Shimmer = true;
        visibleJemput = false;
        visible_divider_buttom_jemput = false;
        maxHeight = 150;
        minHeight = 150;
        //minBottomMap = 135;
        _fabHeight = 166;
      } else if (modeMap == 1) {
        _pc.panelPosition = 0.2;
        visible_Shimmer = true;
        visibleTujuan = false;
        visible_divider_buttom_tujuan = false;
        maxHeight = 150;
        minHeight = 150;
        //minBottomMap  = 135;
        _fabHeight = 166;
      } else if (modeMap == 2) {
        // maxHeight = 280;  minHeight   = 280 ; minBottomMap  = 270;
        // _fabHeight=  280   ;
      }
    });
  }

  void ModeJemput() {
    setState(() {
      markers_order.clear();
      _polylines.clear();
      _pc.panelPosition = 0.5;
      maxHeight = 190;
      minHeight = 190;
      //minBottomMap  = 140;
      _fabHeight = 206;
    });
    order = '';
    _setText = 'Set lokasi jemput';
    _fabVisible = true;
    visible_Shimmer = false;
    visibleHeaderJemput = true;
    visibleTextKeterangan = true;
    visibleJemput = true;
    visibleTujuan = false;
    visible_divider_buttom_jemput = false;
    visible_divider_buttom_tujuan = false;
    visible_distance_text = false;
    visibleButtonSet = true;
    visible_mode_bayar = false;
    visible_harga_invalid = false;

    visible_marker_jemput = true;
    visible_marker_tujuan = false;
  }

  void ModeTujuan() {
    order = '';
    modeMap = 1;

    Future.delayed(Duration(milliseconds: 100)).asStream().listen((_) {});
    setState(() {
      markers_order.clear();
      _polylines.clear();
      _pc.panelPosition = 0.5;
      maxHeight = 150;
      minHeight = 150;
      //minBottomMap  = 90;
      _fabHeight = 166.0;
    });
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
    jemputKet = controllerKeterangan.text;
  }

  void ModeLoadPrice(bool tanpa_harga_baru) {
    order = '';
    print('ModeLoadPrice');
    setState(() {
      if (tanpa_harga_baru) {
        _polylines.clear();
      }

      modeMap = 2;
      _setText = 'Mendapatkan harga';
      _pc.panelPosition = 0.2;
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

      // _markers.clear();
      //_markers.clear();
    });

    //getJsonDirectionServer();
    if (tanpa_harga_baru) {
      getJsonDirectionGoogle();
    }
  }

  void ModeReadyToOrder(bool load_ahrga, String respon_gagal_direction) {
    _pc.show();
    _pc.open();

    setState(() {
      modeMap = 3;
      visible_Shimmer = false;

      // minBottomMap  = 220;

      maxHeight = 280;
      minHeight = 280;

      _fabHeight = 296;
      _fabVisible = false;

      if (load_ahrga) {
        print('true');
        visible_button_order = true;
        visible_harga_invalid = false;
        visible_distance_text = true;
      } else {
        //distance_text='0';
        distanceValue = '0';
        duration_text = '0';
        duration_value = '0';
        visible_button_order = false;
        visible_harga_invalid = true;
        visible_distance_text = true;

        print('false');

        if (respon_gagal_direction == '') {
          respon_gagal_direction = 'Tidak dapat menampilkan harga..!';
        }
        _showGagalOrder('Opps apa yang salah.?', 'assets/images/promo_1.jpg',
            respon_gagal_direction);
      }
      visible_mode_bayar = true;
      visibleHeaderJemput = false;
      visibleJemput = true;
      visibleTujuan = true;

      visibleButtonSet = false;
      visible_marker_tujuan = false;

      visible_divider_buttom_jemput = true;
      visible_divider_buttom_tujuan = true;
      visible_divider_buttom_keterangan = false;
      visible_animation_waiting_order = false;
      visible_batalkan_pertama = false;
    });

    setState(() {
      /*_markers.clear(); 
        _markers.clear();
 
        _markers.add(Marker( 
          markerId: MarkerId(jemputPosition.toString()),
          position: jemputPosition, 
          icon: BitmapDescriptor.defaultMarker,
        ));

        _markers.add(Marker( 
          markerId: MarkerId(tujuanPosition.toString()),
          position: tujuanPosition, 
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        )); */

      markers_order.clear();
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

      markers_order[MarkerId(jemputPosition.toString())] = _markerjemput;
      markers_order[MarkerId(tujuanPosition.toString())] = _marker_tujuan;
      // markers_order.addAll(markers);
    });
  }

  void ModeRequestOrder() {
    setState(() {
      modeMap == 4;
      _pc.hide();
      _pc.close();
      _start = 15; //30;5
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
      visible_batalkan_pertama = false;
    });

    // await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _pc.show();
      _pc.open();
      maxHeight = 150;
      minHeight = 150;
      _fabHeight = 166;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (time) {
      //print('menungguuuuuuuuuu driver ModeRequestOrder');

      if (_start < 1 || _start == 0) {
        setState(() {
          _start = 0;
          _timer.cancel();
          time.cancel();

          if (habis_waktu_menunggu) {
            _batalkanOrderPertama(documentIDNYA, '');

            // Future.delayed(Duration(seconds:1));
            _showGagalOrder(
                'Opss gagal order...!',
                'assets/images/para_ojek.png',
                'Pasukan driver pada sibuk nihhh, silahkan ulangi order ya...!');
            // Future.delayed(Duration(seconds:3));
            ModeReadyToOrder(true, '');
            visible_button_order = true;
            visible_harga_invalid = false;
            visible_animation_waiting_order = false;
            setModeBayar(pay_categories);
          }
        });
      } else {
        setState(() {
          _start = _start - 1;
          habis_waktu_menunggu = true;
        });
      }
    });

    //getJsonPostOrder();
    _checkKodeTambahOrder();
  }

  void ModeReseiveFalse(String judul_gagal_order) async {
    /*
    mode ini dimana orderan telah 

    */

    setState(() async {
      _start = 0;
      await _timer.cancel();
      await Future.delayed(Duration(seconds: 1));

      _showGagalOrder('Opss gagal order...!', 'assets/images/promo_1.jpg',
          judul_gagal_order);
      await Future.delayed(Duration(seconds: 1));
      ModeReadyToOrder(true, '');

      visible_button_order = true;
      visible_harga_invalid = false;
      visible_animation_waiting_order = false;
      visible_batalkan_pertama = false;
    });
  }

  void ModeReseiveTrue() {
    /* 
       mode ini dimana orderan telah diterima 
       oleh driver dari balasan gcm driver atau 
       mengambil langsung data orderan di server
       
      => maka navigasi dari ModeRequestOrder
      => menuju navigasi tampilan order diterima
    */
    print('mode order diterima');
    setState(() {
      modeMap == 5;
      _pc.hide();
      _pc.close();
      _timer.cancel();
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
    });
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
                  setModeKendaraan('ojek');
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
                  setModeKendaraan('car4');
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
                  setModeKendaraan('car6');
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
                  '$_Titlenya',
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
                                      Container(
                                        height: 280.0,
                                        child: Column(
                                          children: fList
                                              .map((data) => RadioListTile(
                                                    title: Text('${data.name}'),
                                                    groupValue:
                                                        id_pilihan_kusioner,
                                                    value: data.index,
                                                    onChanged: (val) {
                                                      state(() {
                                                        radioItem = data.name;
                                                        id_pilihan_kusioner =
                                                            data.index;
                                                      });
                                                    },
                                                  ))
                                              .toList(),
                                        ),
                                      ),
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
                                            _sendKusionerDanBatal(order);
                                            //_getUserLocation();
                                            ModeFirstOpen();
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
  Future<dynamic> _makeRequestKeyWord(input) async {
    var location = '${_currentPosition.latitude},${_currentPosition.longitude}';
    var radius = '3000';
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${CallApi.keyApi}i&language=id&location=$location&radius=$radius';
    //  print(url);
    /*if (widget.location != null && widget.radius != null) {
      url += '&location=${widget.location.latitude},${widget.location.longitude}&radius=${widget.radius}';
      if (widget.strictBounds) {
        url += '&strictbounds';
      }
      if (widget.placeTypes.length > 0) {
        url += '&types=';
        for (var place in widget.placeTypes) {
          url += '$place';
        }
      }
    }*/

    final response = await http.get(url);
    final _json = json.decode(response.body);

    if (_json['error_message'] != null) {
      var error = _json['error_message'];
      if (error == 'This API project is not authorized to use this API.') {
        error +=
            ' Make sure the Places API is activated on your Google Cloud Platform';
      }
      throw Exception(error);
    } else {
      final predictions = _json['predictions'];

      return predictions;
    }
  }

  void _getAdress(alamatnya_) async {
    try {
      var placemark = await Geolocator().placemarkFromAddress(alamatnya_);
      setState(() {
        var placeMark = placemark[0];
        _moveToPosition(placeMark.position);
      });
    } catch (e) {
      print('ERRORku>>$_lastMapPosition:$e');
      visibleButtonSet = false;
      // _initialPosition = null;
    }
  }

  void _showCari() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        elevation: 10,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
                child: Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              // height: heightOfModalBottomSheet,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.white),
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
                  onPressed: () {
                    modeMap = modeCari;
                    if (modeCari == 0) {
                      ModeJemput();
                    } else if (modeCari == 1) {
                      ModeTujuan();
                    } else {}
                    //_moveToPosition(_currentPosition);
                    _getUserLocation();
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
                  child: DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 1,
                      minChildSize: 0.9,
                      maxChildSize: 1,
                      builder: (_, scrollcontroller) {
                        //print(_placePredictions.length);
                        if (_placePredictions.isNotEmpty) {
                          //String place = _placePredictions[index].description;
                          //print(_placePredictions[0]['description']);
                          return ListView.builder(
                            controller: scrollcontroller,
                            itemCount: _placePredictions.length,
                            itemBuilder: (BuildContext context, int index) {
                              String place =
                                  _placePredictions[index]['description'];

                              return MaterialButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                onPressed: () {
                                  modeMap = modeCari;

                                  if (modeCari == 0) {
                                    ModeJemput();
                                  } else if (modeCari == 1) {
                                    ModeTujuan();
                                  } else {}

                                  //print(place);
                                  _getAdress(place);
                                  Navigator.pop(context);
                                },
                                child: ListTile(
                                  title: Text(
                                    place,
                                    //place.length < 45 ? '$place' : '${place.replaceRange(45, place.length, '')} ...',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      color: Colors.grey[850],
                                    ),
                                    maxLines: 1,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 0,
                                  ),
                                ),
                              );
                              /* return ListTile(
                          title: Text(_placePredictions[index]['description']),
                          onTap:   () {
                            print(_placePredictions[index]['description']);
                            _getAdress(_placePredictions[index]['description']); 
                              Navigator.pop(context); 

                          }, 
                        );*/
                            },
                          );
                        } else {
                          return ListView.builder(
                            controller: scrollcontroller,
                            itemCount: 0,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text('Item $index'),
                                onTap: () {
                                  print('Item $index');
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        }
                      }),
                )
              ]),
            ));
          });
        });
  }

  void _errorDriverNotFount() async {
    final snackBar1 = SnackBar(
      content: Text('Opps driver tidak ditemukan disekitar anda. radius 60 Km'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          //Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(
        snackBar1); //       _scaffoldKey.currentState.showSnackBar(snackBar1);
  }
} //end class

// clas item kusioner batal
class KusionersList {
  KusionersList({this.name, this.index});
  String name;
  int index;
}

//class untuk data orderan yg di terima oleh driver
class OrderanJson {
  OrderanJson(
      this.category_driver,
      this.total_prices,
      this.pay_categories,
      this.driver,
      this.driver_uid,
      this.driver_avatar,
      this.driver_hp,
      this.driver_bintang,
      this.driver_trip,
      this.driver_gcm,
      this.jemput_judul,
      this.jemput_alamat,
      this.jemput_ket,
      this.tujuan_judul,
      this.tujuan_alamat);

  OrderanJson.fromJson(Map<dynamic, dynamic> json)
      : category_driver = json['category_driver'],
        total_prices = json['total_prices'],
        pay_categories = json['pay_categories'],
        driver = json['driver'],
        driver_uid = json['driver_uid'],
        driver_avatar = json['driver_avatar'],
        driver_hp = json['driver_hp'],
        driver_bintang = json['driver_bintang'],
        driver_trip = json['driver_trip'],
        driver_gcm = json['driver_gcm'],
        jemput_judul = json['jemput_judul'],
        jemput_alamat = json['jemput_alamat'],
        jemput_ket = json['jemput_ket'],
        tujuan_judul = json['tujuan_judul'],
        tujuan_alamat = json['tujuan_alamat'];

  final String category_driver;
  final String total_prices;
  final String pay_categories;
  final String driver;
  final String driver_uid;
  final String driver_avatar;
  final String driver_hp;
  final String driver_bintang;
  final String driver_trip;
  final String driver_gcm;
  final String jemput_judul;
  final String jemput_alamat;
  final String jemput_ket;
  final String tujuan_judul;
  final String tujuan_alamat;
  Map<dynamic, dynamic> toJson() => {
        'category_driver': category_driver,
        'total_prices': total_prices,
        'pay_categories': pay_categories,
        'driver': driver,
        'driver_md5': driver_uid,
        'driver_avatar': driver_avatar,
        'driver_hp': driver_hp,
        'driver_bintang': driver_bintang,
        'driver_trip': driver_trip,
        'driver_gcm': driver_gcm,
        'jemput_judul': jemput_judul,
        'jemput_alamat': jemput_alamat,
        'jemput_ket': jemput_ket,
        'tujuan_judul': tujuan_judul,
        'tujuan_alamat': tujuan_alamat,
      };
}
