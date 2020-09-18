import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io'; 
import 'dart:ui'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:flutter/material.dart';
 
import 'package:geoflutterfire/geoflutterfire.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart';
 
import 'package:http/http.dart' as http;
 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:sliding_up_panel/sliding_up_panel.dart'; 
 
import 'package:pelanggan/librariku/shimmer/shimmer.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constans.dart';
 
  

 class SetLokasiPage extends StatelessWidget {
      
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: LokasiPage( ),
    );
  }
} 

class LokasiPage extends StatefulWidget {
   LokasiPage({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP; 
  @override
  LokasiPageState createState() => LokasiPageState();
}

class LokasiPageState extends State<LokasiPage>  with AutomaticKeepAliveClientMixin {
   
 
  GoogleMap _map;
  String documentIDNYA='';
  String namaCustomer='';
  String uidCustomer='';
  int saldoCustomer=0;
  int pointCustomer=0;
  int radiusCustomer=60;
	String hpCustomer='';
	String tripCustomer='0';
	String bintangCustomer= '0';
  String avatarCustomer= '0';
  

  String bearToken  ='';
  String gcmToken  = '';
  //pesan driver
 
  String mapTempat =  '';
  String mapAlamat=''; 
  String jemputJudul =  '';
  String jemputAlamat='';
  String jemputKet=''; 
  bool visibleJemput= true;  
  static  LatLng jemputPosition = _initialPosition; 
 
  static int modeMap = 99;  
  static int modeCari = 0;
  bool  _fabVisible= false; 
  //var button
 
  bool visibleHeaderJemput= false; 
  bool visibleButtonSet= false;  
  //var text keterangan
  bool visibleTextKeterangan= true; 
  final controllerKeterangan = TextEditingController();
  
  //cari alamat pakai text
  final cariController = TextEditingController(); 

  //var harga
  String resultdocumentID=''; 

  //var divider
  bool visible_divider_buttom_jemput= false;  
  bool visible_divider_buttom_keterangan= false;  
  //visible_Shimmer
  bool visible_Shimmer= false;  
  //marker jemput
  double iconSize = 40.0;  
  bool visible_marker_jemput= false; 
   
  //SlidingUpPanel
  double _fabHeight;
   
  double    maxHeight  = 150.0;
  double    minHeight  = 150;  
  double   minBottomMap  = 137;  
  final PanelController _pc    =   PanelController(); 
  //map
  String  keyApi= 'AIzaSyA706610W0aD4w2ueNR6seGrlHj5SpYOyM';
 
   final Completer<GoogleMapController> _controller = Completer(); 
  GoogleMapController mapController;
  Future _mapFuture = Future.delayed(Duration(milliseconds: 250), () => true);

  static  LatLng _initialPosition= LatLng(-3.47764787218,119.141805461); 
  static LatLng _lastMapPosition = LatLng(-3.47764787218,119.141805461)   ;
  Position _currentPosition;
  Position posisiHasilCari; 
  
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  
  //pencarian tempat
  List<dynamic> _placePredictions = []; 
  double  heightOfModalBottomSheet =110;
  bool checkingFlight = false;
  bool success = false; 
  String  prov_1= '';
  String  prov_2= '';

   @override
  bool get wantKeepAlive => true;
  
  @override
  void initState(){   
    super.initState();   
    modeFirstOpen(); 
  }

  @override
  void dispose() { 
    super.dispose();
    controllerKeterangan.dispose();
    cariController.dispose(); 
 
  }
 
  //mendapatkan lattitude posisi user 
  //mengambil varibel posisi
  void  _getUserLocation() { 
    print(' _getUserLocation()');
    
    geolocator .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)  .then((Position position) {
      setState(() {
           _initialPosition = LatLng(position.latitude, position.longitude);
           _lastMapPosition = _initialPosition;
           _currentPosition = position;
            posisiHasilCari = position;
          _moveToPosition(position);
      }); 
    }).catchError((e) {
      modeLoadingAdress();
      print(e);
    });

  }

  //perintah mengarahkan camera maps ke posisi tertentu
  Future<void> _moveToPosition(Position pos) async {
    
      mapController = await _controller.future;
    if(mapController == null) return;
    print('moving to position ${pos.latitude}, ${pos.longitude}');
    await mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 16.0, bearing: -20,
        )
      )
    );

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
       
        var placemark = await Geolocator().placemarkFromCoordinates(_lastMapPosition.latitude, _lastMapPosition.longitude);
        setState(() {  
          var placeMark  = placemark[0]; 
          var name = placeMark.name;
          var subLocality = placeMark.subLocality;
          var locality = placeMark.locality;
          var administrativeArea = placeMark.administrativeArea;
          var postalCode = placeMark.postalCode;
          var country = placeMark.country;
          var address = '$name, $subLocality, $locality, $administrativeArea $postalCode, $country';
          
           print(address); 
          
          if (modeMap==0){
               
             jemputJudul=name;
             jemputAlamat=address;
             jemputPosition = _lastMapPosition; 
            // prov_1 = '$administrativeArea $postalCode'; 
             prov_1 = '$administrativeArea'; 
             prov_1 =prov_1.replaceAll(  RegExp(r'\s+\b|\b\s'), '');
             modeJemput();
          } 
        });

    } catch (e) {
     print('ERRORku>>$_lastMapPosition:$e');
     modeLoadingAdress() ;
     //visible_button_set=false; 
     // _initialPosition = null;
    }  
  }
  
   
  @override
  Widget build(BuildContext context){
    //_panelHeightOpen = MediaQuery.of(context).size.height ;
   //double fullSizeHeight = MediaQuery.of(context).size.height;
    if (_map == null){
        _map =  _body();
      }

    return    WillPopScope(  

       onWillPop: () async {
          // You can await in the calling widget for my_value and handle when complete.
           // dispose();
           //_keluarWindow(  null);   
           // return Future.value(true);
           _keluarWindow(  null);
           return false;
        },
     /*onWillPop: () => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text('Informasi'),
            content: Text('Anda yakin ingin keluar?'),
            actions: [
              FlatButton(
                child: Text('Ya'), 
                onPressed: () { 
                  Navigator.pop(context, null);
                     return true;
                  //Navigator.pop(c, true);
                },
              ),
              FlatButton(
                child: Text('Tidak'),
                onPressed: () {
                   Navigator.pop(c, null);
                    return false;
                }
              ),
            ],
          ),
      ), */
      child: MaterialApp(
      //debugShowCheckedModeBanner: false, 
     // theme:   ThemeData(
        //primarySwatch: Colors.teal,
       // canvasColor: Colors.transparent,
     // ),
      home: 
     // AnnotatedRegion<SystemUiOverlayStyle>(
      //  value: SystemUiOverlayStyle(
       //   statusBarColor: Colors.transparent, // transparent status bar
       //   systemNavigationBarColor: Colors.black, // navigation bar color
       //   statusBarIconBrightness: Brightness.dark, // status bar icons' color
       //   systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icons' color
       // ),
      //  child:  //SizedBox.expand(
          //jika loadng map jika tidak ingin pakai loading map silahkan ganti
           _initialPosition == null ? Container(child: Center(child:Text('loading map..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) : Container(
             child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[  
                Container(
                  height: MediaQuery.of(context).size.height- minBottomMap ,
                    alignment: Alignment.topCenter,
                    child:    Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          InkWell( 
                            child: _map// _body()
                          )
                        ],
                      ),
                ),
                

              // the fab
              Positioned(
                right: 15.0,
                bottom: _fabHeight,
                child: Visibility(
                  visible: _fabVisible,
                //  maintainAnimation: true,
                  child:  Container(
                      width: 48.0,
                      height: 48.0,
                      child: FloatingActionButton( 
                        child: Icon(
                          Icons.gps_fixed,
                          color: Colors.blue, 
                        ),
                      onPressed: (){   
                        _getUserLocation();
                          //createRecord();
                      },
                      backgroundColor: Colors.white, 
                    ), 
                  ), 
                  
                ),
              ),
                
              //marker jemput
              Visibility(
                visible: visible_marker_jemput,
                child: Positioned(
                top: ( (  MediaQuery.of(context).size.height - iconSize) -(minBottomMap+80)   )/ 2,
                right: (  MediaQuery.of(context).size.width - iconSize )/ 2,
                child: Column(
                  children: [
                    Container(
                      width: 38,height: 38,
                      margin: EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle
                      ),
                      child:   Icon(Icons.gps_fixed, size: 24,    color: Colors.white  ),
                    ),
                    Container(
                      height: 18.0, width: 2.5,
                      color: Colors.blue,
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                     
                  ],
                )  
              ),  
             ),
              
               
              SlidingUpPanel(
                  backdropEnabled: false,
                  maxHeight: maxHeight,//_panelHeightOpen,
                  minHeight: minHeight,//_panelHeightClosed,
                  parallaxEnabled: true,
                  parallaxOffset: .5,
                  controller: _pc, 
                  // body:    _body(), 
                  panelBuilder: (sc) => _panel(sc),
                  // panel:  _panel(sc),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                  onPanelSlide: (double pos) => setState((){ 
                  // _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
                    if (_fabHeight>=230){
                      //_fabHidden=false;
                    }else{
                      //_fabHidden= true ;
                    }
                  }),
              ), 
              
            ], 
          ),
        ),
      // ), 
      ) ,
    );
  }
 
  //tempat google maps atau peta dan marker
  Widget _body(){
   //LatLng currentLocation = LocationMonitor.of(context).currentLocation;

   /* return FutureBuilder(
      future: _mapFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print("empty");
          return Text('');
        }*/

        return GoogleMap( 
         buildingsEnabled: false, gestureRecognizers:null ,
         indoorViewEnabled: false, 
          //polylines: Set<Polyline>.of(_polylines.values),
          //markers: _markers,
          //markers:  modeMap==3 ? Set<Marker>.of(markers_order.values) : Set<Marker>.of(markers.values),
          mapToolbarEnabled: false,  
          zoomControlsEnabled: false,     
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled:false , 
          zoomGesturesEnabled: true,
          trafficEnabled: true,
          //  showUserLocation: true,
          // mapViewType: MapViewType.normal,
          //trackCameraPosition: true,
          mapType: MapType.normal,
          //markers: Set.of((marker != null) ? [marker] : []),
          //circles: Set.of((circle != null) ? [circle] : []),
          initialCameraPosition:CameraPosition(
            target:  _initialPosition  ?? LatLng(-3.47764787218,119.141805461),
            zoom: 16.0, 
            bearing: 20,//berputar
          ),
          //markers: _markers.values.toSet(),
          onCameraMoveStarted: () {
            //print('onCameraMoveStarted');
          },
          onCameraMove: (CameraPosition cameraPosition) { 
            _lastMapPosition = cameraPosition.target; 
            if(modeMap==0 || modeMap==1  ){
                modeLoadingAdress();
            } 
          },
          onCameraIdle:(){  
            if ( modeMap==0 || modeMap==1 ){

              if(_currentPosition!=null){
                _getAdressLocation();  
              }else{
                _getUserLocation();
              }

            }  
            setState((){ 
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
          onMapCreated: (GoogleMapController controller)   { 
            
            setState(() {
              //maxHeight   = 0;
              //minHeight   = 0 ;
            // minBottomMap  = -10; 
              if(mapController == null ){  
                mapController=controller;  
                _controller.complete(controller); 
              }
            });  

          },  
        );

     // },
   // );
    
    /*return  GoogleMap( 
      //polylines: Set<Polyline>.of(_polylines.values),
      //markers: _markers,
    //  markers:  modeMap==3 ? Set<Marker>.of(markers_order.values) : Set<Marker>.of(markers.values),
	   	mapToolbarEnabled: false,  
		  zoomControlsEnabled: false,     
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: false,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled:false , 
      zoomGesturesEnabled: true,
      trafficEnabled: true,
      //  showUserLocation: true,
      // mapViewType: MapViewType.normal,
      //trackCameraPosition: true,
      mapType: MapType.normal,
      //markers: Set.of((marker != null) ? [marker] : []),
      //circles: Set.of((circle != null) ? [circle] : []),
      initialCameraPosition:CameraPosition(
        target:  _initialPosition  ?? LatLng(-3.47764787218,119.141805461),
        zoom: 16.0, 
        bearing: 20,//berputar
      ),
      //markers: _markers.values.toSet(),
      onCameraMoveStarted: () {
        //print('onCameraMoveStarted');
      },
      onCameraMove: (CameraPosition cameraPosition) { 
        _lastMapPosition = cameraPosition.target; 
        if(modeMap==0 || modeMap==1  ){
            modeLoadingAdress();
        } 
      },
      onCameraIdle:(){  
        if ( modeMap==0 || modeMap==1 ){

          if(_currentPosition!=null){
            _getAdressLocation();  
          }else{
            _getUserLocation();
          }

        }  
        setState((){ 
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
      onMapCreated: (GoogleMapController controller)   { 
        
        setState(() {
          //maxHeight   = 0;
          //minHeight   = 0 ;
         // minBottomMap  = -10; 
          if(mapController == null ){  
            mapController=controller;  
            _controller.complete(controller); 
          }
        });  

      },  
    ); */

  }

  //tempat bottom sheet dan data harga,order dan lain
  Widget _panel(ScrollController sc){
    return   MediaQuery.removePadding(
      context: context, 
      removeTop: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 10),
        child: ListView(
          controller: sc,
          children: <Widget>[  

            
            //1 header jemput
            Visibility(  
              visible: visibleHeaderJemput,
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,  
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[ 
                  Text(
                    'Set lokasi kamu' , 
                    style: TextStyle( 
                      fontWeight: FontWeight.bold, letterSpacing: 0,
                      fontSize: 18, color: Colors.black, fontFamily: 'NeoSansBold',
                       decoration: TextDecoration.none, 
                       //  decorationStyle: TextDecorationStyle.dashed,
                    ),
                  ),  
                   
                ],
              ),
            ),
            
            
            Divider(  color: Colors.grey,  height:5, ),
 
            //3 alamat jemput  
            Visibility(
              visible: visibleJemput,
              child: RaisedButton(
                onPressed:(){  
                    modeCari=0;
                    _showCari ( ); 
                },
                shape:   RoundedRectangleBorder(
                  borderRadius:   BorderRadius.circular(5.0),
                ), 
                color: Colors.white,elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  Padding(
                    padding: const EdgeInsets.only( right: 6),
                    child: 
                       Icon(  Icons.gps_fixed ,  size: 32.0, color: Colors.blue ), 
                  ),  
                  Expanded(
                  child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Jemput : $jemputJudul' , maxLines: 1,
                          style: TextStyle( 
                                fontFamily: 'NeoSans',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                          ), 
                        ),
                        Text(jemputAlamat , maxLines: 3, softWrap: true,
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
                   Icon(  Icons.search ,  size: 16.0, color: Colors.grey ),  
                ],
              ),
            ), 
            ),
           
            //4
            Visibility(
                visible: visible_divider_buttom_jemput,maintainSize:false,
                child:  Divider(  color: Colors.grey,  height:5,  ),
            ),

            //5 Shimmer
            Visibility(
              visible: visible_Shimmer,
              child:  SizedBox(
                  width: 200.0,
                  height: 50.0,  
                  child: Shimmer.fromColors(
                    baseColor:  Colors.grey[300]  ,
                    highlightColor: GojekPalette. grey,
                    child:   Row( 
                       crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                    children: [ 
                      Padding(
                        padding: const EdgeInsets.only( right: 6,top: 3),
                        child: 
                          Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          color:  Color(0xffcacaca),
                                          borderRadius: BorderRadius.circular(16.5)
                                        ),
                              ),   
                      ),  
                      Expanded(
                      child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              SizedBox( height: 5, ),   
                              Container(
                                        height: 11,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color:  Color(0xffcacaca),
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                              ), 
                              SizedBox( height: 5, ), 
                              Container(
                                        height: 11,
                                        width: 230,
                                        decoration: BoxDecoration(
                                          color:  Colors.grey[300],
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                              ), 
                              SizedBox( height: 5, ), 
                              Container(
                                        height: 11,
                                        width: 230,
                                        decoration: BoxDecoration(
                                          color:  Color(0xffcacaca),
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                              ), 
                          ],
                        ),
                      ), 
                    ],
                  ), 
                  ),
                ),
            ),
             
              
            //8 keterangan jemput    
            Visibility(  
              maintainSize:false,
                visible: visibleTextKeterangan,
                child:Container(  
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
                        padding: const EdgeInsets.only( left: 5,right: 0),
                        child: Icon(Icons.message, size: 24.0, color: Colors.green),
                      ), 
                      Expanded( 
                        child: TextField( maxLines: 1,
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
                              contentPadding:  EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                              hintText: 'Rincian alamat...'),
                        ),
                      ),
                      
                    ],
                  ),
                ),
             ),  
            
            //9
            Visibility(
                visible: visible_divider_buttom_keterangan,maintainSize:false,
                child:  Divider(  color: Colors.grey,  height:5,  ),
            ),   
  
            //10 button set 
            Visibility( maintainSize: false,
                visible: visibleButtonSet,
                child: RaisedButton(
                  textColor: Colors.white,
                  
                  color: Colors.green ,
                  child: Text( 'Set lokasi kamu'),
                  onPressed: () {  
                    Map<String, dynamic> lokasiAnda ={ 
                      'address':jemputAlamat,
                      'ket':controllerKeterangan.text,
                      'lat' :jemputPosition.latitude, 
                      'long' :jemputPosition.longitude,  
                      'prov_1':prov_1,
                    };
                    _keluarWindow(  lokasiAnda);
                  },
                  shape:   RoundedRectangleBorder(
                    borderRadius:   BorderRadius.circular(30.0),
                  ),
                ), 
                     

            ),  
            
           
             
          
          ],
        ),
      ),  
    );
  }

  void _keluarWindow(Map<String, dynamic> lokasiAnda) { 
     
      Navigator.pop(context, lokasiAnda);
  }   

  void modeFirstOpen() {
    print('ModeFirstOpen');
    _getUserLocation();  
    modeMap=99;//mode 99 adalah mode awal map dimana akan di cek ke internet apakah ada orderan
 
    
    _fabVisible= false; 
    _fabHeight = 166;
    maxHeight   =150;
    minHeight  =150;  
    minBottomMap  = 137;  
    
    mapTempat= '';
    mapAlamat=''; 
    jemputJudul='';
    jemputAlamat=''; 
    jemputKet=''; 
    //cari map
    _placePredictions = [];   
    visible_Shimmer= true; 
    visibleHeaderJemput= true; 
    visibleJemput= false;  
    visible_marker_jemput= false; 
    visibleTextKeterangan= false;
    visibleButtonSet= false; 
    visible_divider_buttom_jemput= false;  
    visible_divider_buttom_keterangan= false;   
    modeMap=0;
  }
  
  void modeLoadingAdress(){
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
  

    setState((){ 
            
      if(modeMap==0) {
        
        _pc.panelPosition =0.2;  
        visible_Shimmer = true;  
        visibleJemput = false; 
        visible_divider_buttom_jemput = false;
        maxHeight = 150;
        minHeight = 150 ; 
        _fabHeight =  166 ; 

      }  else if(modeMap==1){
      
        _pc.panelPosition = 0.2; 
        visible_Shimmer = true;   
        maxHeight = 150; 
        minHeight = 150; 
        _fabHeight=  166 ; 

      }else if(modeMap==2){
        // maxHeight = 280;  minHeight   = 280 ; minBottomMap  = 270; 
        // _fabHeight=  280   ; 
      }

    }); 

  }

  void modeJemput(){
      
    setState(() { 
        
        _pc.panelPosition = 0.5;
        maxHeight   = 190;  
         minHeight   = 190; 
          //minBottomMap  = 140; 
        _fabHeight=  206 ;
    });  
     
    _fabVisible =true; 
    visible_Shimmer= false;
    visibleHeaderJemput= true; 
    visibleTextKeterangan= true; 
    visibleJemput= true;    
    visible_divider_buttom_jemput= false;   
    visibleButtonSet= true;    
    visible_marker_jemput= true;
   


  }
   
  /// API request function. Returns the Predictions
  Future<dynamic> _makeRequestKeyWord(input) async {
    var  location= '${_currentPosition.latitude},${_currentPosition.longitude}';
    var  radius='3000'; 
    var url =  'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$keyApi&language=id&location=$location&radius=$radius';
  

    final response = await http.get(url);
    final _json =json.decode  (response.body);
 
    if (_json['error_message'] != null) {
      var error = _json['error_message'];
      if (error == 'This API project is not authorized to use this API.') {
        error += ' Make sure the Places API is activated on your Google Cloud Platform';
      }
      throw Exception(error);
    } else {
      
      final predictions = _json['predictions'];
       
      return predictions;
    }
  }
  
  void _getAdress(String alamatnya) async {  
    try {   
         var placemark = await Geolocator().placemarkFromAddress (alamatnya);
         setState(() {   
           var placeMark  = placemark[0];   
           _moveToPosition  (placeMark.position); 
        });

    } catch (e) {
     print('ERRORku>>$_lastMapPosition:$e');
     visibleButtonSet=false; 
     // _initialPosition = null;
    }  
  }

  void _showCari(){ 
    showModalBottomSheet( 
      context: context,
      backgroundColor: Colors.transparent,  
      isDismissible: true,  
      elevation:10, 
      isScrollControlled: true,
      builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState ) { 
          return    SafeArea(
            child:  Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            // height: heightOfModalBottomSheet,
            width: double.infinity,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(4.0), color: Colors.white
            ),
            child:  Column(
         
            children: <Widget>[  
              SizedBox( height:20, ),   
              Icon(   Icons.drag_handle,  color: Colors.grey, ), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Cari alamat',
                    style:  TextStyle(fontFamily: 'NeoSansBold', fontSize: 18.0),
                  ),
                  
                ],
              ),
            
              Padding( 
                padding: const EdgeInsets.only(top: 6),
                child: TextField( 
                  autofocus: true,
                  //focusNode: myFocusNode, 
                  onChanged: (value)  async {
                        if (value.isEmpty) { 
                          setState(() {
                            _placePredictions = [];
                          });  
                          print('kosong');
                        }else{
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
                    letterSpacing: 0,  color: Colors.black
                 ), 
                cursorColor: Colors.black, 
                
                keyboardType: TextInputType.text,
               // textInputAction: TextInputAction.go,
                controller: cariController,
                decoration: InputDecoration( 
                    //labelText: 'Search',
                    hintText: 'Search',
                    filled: true,
                    
                    fillColor:   GojekPalette.grey200,
                    prefixIcon: Icon(Icons.search,color: Colors.green,), 
                    contentPadding:  EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                     focusedBorder:  OutlineInputBorder(
                      borderSide:   BorderSide(color: Colors.grey, width: 0.3),
                    ),
                   
                    ),
              ),
            ),   
              OutlineButton(   
                child: Row( 
                    crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center, 
                  children: <Widget>[
                    Icon(Icons.map, color: Colors.green,),
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
                  borderRadius:   BorderRadius.circular(16.0),
                  side: BorderSide(color: Colors.green)  
                ),
                onPressed: () {
                  modeMap=  modeCari;
                    if(modeCari==0  ){
                        modeJemput(); 
                    }  
                    _getUserLocation();
                    Navigator.pop(context);  
                }, //callback when button is clicked
                borderSide: BorderSide(
                  color: Colors.green, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 0.3, //width of the border 
                ),  
             ),
              
              Divider(  color: Colors.grey,  height:5, ), 
              Expanded(flex: 1,
              child:   DraggableScrollableSheet( expand: false,
                initialChildSize:1 ,
                minChildSize:0.9,
                maxChildSize: 1, 
                  builder: (_, scrollcontroller) {
                      //print(_placePredictions.length);
                        if (_placePredictions.isNotEmpty){
                    //String place = _placePredictions[index].description; 
                    //print(_placePredictions[0]['description']);
                    return  ListView.builder(
                      controller: scrollcontroller, 
                      itemCount: _placePredictions.length,
                      itemBuilder: (BuildContext context, int index) {
                        
                        String place = _placePredictions[index]['description'];

                        return MaterialButton(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          onPressed: (){
                             modeMap=  modeCari;
                            
                            if(modeCari==0  ){
                                modeJemput(); 
                            } 

                             //print(place); 
                            _getAdress(place); 
                             Navigator.pop(context); 
                          },
                          child: ListTile(
                            title: Text(
                              place,
                              //place.length < 45 ? '$place' : '${place.replaceRange(45, place.length, '')} ...',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                color:   Colors.grey[850],
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
                  }else{
                      return  ListView.builder(
                        controller: scrollcontroller, 
                        itemCount: 0,
                        itemBuilder: (BuildContext context, int index) { 
                          return ListTile(
                            title: Text('Item $index'),
                            onTap:   () {
                              print('Item $index');
                              Navigator.pop(context);  
                            }, 
                          );
                        },
                    );
                  } 
                } 
              ) ,
            )   
        ]),
      )
      ); 
    }
    
    );
});

 



  }
  

}//end class  

 

 

