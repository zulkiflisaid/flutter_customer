import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelanggan/api/api.dart';
import 'package:pelanggan/belajar/belajar_map.dart';
import 'package:pelanggan/belajar/bottom_sheet_guide.dart';
import 'package:pelanggan/belajar/contoh_list.dart';
import 'package:pelanggan/belajar/movie/movie_screen.dart';
import 'package:pelanggan/belajar/paging/main_paging.dart';
import 'package:pelanggan/belajar/rethinkdb/tesrethinkdb.dart';
import 'package:pelanggan/constans.dart';
import 'package:pelanggan/beranda/beranda_model.dart';
import 'package:pelanggan/belajar/jarak.dart';
import 'package:pelanggan/layanan_page/go_dapurku.dart';

import 'dart:async';
import 'package:pelanggan/layanan_page/go_driver.dart';
import 'package:pelanggan/layanan_page/go_food.dart';
import 'package:intl/intl.dart';
import 'package:pelanggan/layanan_page/go_kurir.dart';
import 'package:pelanggan/layanan_page/go_listrik.dart';
import 'package:pelanggan/layanan_page/go_pulsa.dart';
import 'package:pelanggan/layanan_page/go_shop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file_beranda/topup_saldo.dart';

/*
import 'package:helloword/servicePage/belajar_map.dart
import 'package:helloword/servicePage/drag_coba.dart';
import 'package:helloword/servicePage/drag_coba1.dart';
import 'package:helloword/servicePage/home_gojek.dart';
import 'package:helloword/servicePage/map.dart';
import 'package:helloword/servicePage/page_gojek.dart';
import 'package:helloword/servicePage/slider_up.dart';
import 'package:helloword/servicePage/tes.dart';
*/
class BerandaPage extends StatefulWidget {
  BerandaPage({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;

  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  var uang = NumberFormat.currency(locale: 'ID', symbol: '', decimalDigits: 0);
  //var uang =   NumberFormat.currency(locale: 'en_US', symbol: '');
  // final uang2 =   NumberFormat('#,##0.00', 'en_US');
  String namaCustomer = '';
  int saldoCustomer = 0;
  int pointCustomer = 0;
  FirebaseUser currentUser;
  Future<List<Promosi>> promos;
  //String token = '';
  String gcm = '';
  final controllerKeterangan = TextEditingController();

  final List<GojekService> _gojekServiceList = [];
  //List<Food> _goFoodFeaturedList = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //getCurrentUser();

    promos = fetchSeasons();
    _gojekServiceList.add(GojekService(
        image: Icons.directions_bike,
        color: GojekPalette.menuRide,
        title: 'OJEK'));
    _gojekServiceList.add(GojekService(
        image: Icons.local_car_wash,
        color: GojekPalette.menuCar,
        title: 'MOBIL'));
    // _gojekServiceList.add( GojekService(
    //     image: Icons.directions_car,   color: GojekPalette.menuBluebird,
    //     title: 'RENTAL'));
    _gojekServiceList.add(GojekService(
        image: Icons.restaurant,
        color: GojekPalette.menuFood,
        title: 'KULINER'));
    _gojekServiceList.add(GojekService(
        image: Icons.next_week, color: GojekPalette.menuSend, title: 'KURIR'));
    _gojekServiceList.add(GojekService(
        //     Icons.flash_auto
        image: Icons.power,
        color: GojekPalette.menuDeals,
        title: 'LISTRIK'));
    _gojekServiceList.add(GojekService(
        image: Icons.phonelink_ring,
        color: GojekPalette.menuPulsa,
        title: 'PULSA'));
    // _gojekServiceList.add( GojekService(
    //     image: Icons.apps, color: GojekPalette.menuOther, title: 'LAINNYA')
    //   );
    _gojekServiceList.add(GojekService(
        image: Icons.shopping_basket,
        color: GojekPalette.menuShop,
        title: 'DAPURKU'));
    _gojekServiceList.add(GojekService(
        image: Icons.shopping_cart,
        color: GojekPalette.menuMart,
        title: 'SHOPEE'));
    //_gojekServiceList.add( GojekService(
    //     image: Icons.local_play, color: GojekPalette.menuTix,
    //    title: 'GO-TIX')   );

    _getToken();
  }

  Future<void> getCurrentUser() async {
    setState(() {
      namaCustomer = "name";
      saldoCustomer = 11111;
      pointCustomer = 1;
    });
  }

  //untuk sementara saja karena selalu di unistall
  void _getToken() async {
    var localStorage = await SharedPreferences.getInstance();
    //token = localStorage.getString('token');
    gcm = localStorage.getString('gcm');
    print("gcm beranda $gcm");
    controllerKeterangan.text = gcm;
  }

  //cek internet koneksi
  Future<void> cekInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      _showToast(context);
    }
  }

  Widget setAppBar() {
    return AppBar(
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        elevation: 0.25,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        flexibleSpace: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                'assets/img_gojek_logo.png',
                height: 50.0,
                width: 100.0,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    /* Container(
                  height: 28.0,
                  width: 28.0,
                  padding: EdgeInsets.all(6.0),
                  decoration:   BoxDecoration(
                      borderRadius:
                            BorderRadius.all(  Radius.circular(100.0)),
                      color: Colors.orangeAccent),
                  alignment: Alignment.centerRight,
                  child:   Icon(
                    Icons.local_bar,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ),*/
                    Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Color(0x50FFD180)),
                      child: Text(
                        '$pointCustomer poin',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: setAppBar(), // GojekAppBar(),
        // backgroundColor: GojekPalette.grey,
        body: Container(
          child: ListView(
            //scrollDirection: Axis.vertical,
            shrinkWrap: true,
            //physics: ClampingScrollPhysics(),
            // physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      // _buildGopayMenu(),
                      _buildGojekServicesMenu(),
                    ],
                  )),
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 16.0),
                child: Column(
                  children: <Widget>[
                    // Expanded(  child: _buatPromo(),  ),

                    // _buildGoFoodFeatured(),
                    // _buildPromo(),
                    _buatPromo(),
                  ],
                ),
              ),
              TextField(
                controller: controllerKeterangan,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGopayMenu() {
    return Container(
        height: 120.0,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xff3164bd), const Color(0xff295cb5)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(3.0))),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color(0xff3164bd), const Color(0xff295cb5)],
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'SALDO',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'NeoSansBold'),
                  ),
                  Container(
                    child: Text(
                      'Rp ${uang.format(saldoCustomer)}',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontFamily: 'NeoSansBold'),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopUpSaldo(
                                  dataP: widget.dataP,
                                )),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/icon_saldo.png',
                          width: 32.0,
                          height: 32.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Text(
                          'Isi Saldo',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        )
                      ],
                    ),
                  ),

                  /*Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       Image.asset(
                        'assets/icons/icon_transfer.png',
                        width: 32.0,
                        height: 32.0,
                      ),
                       Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                       Text(
                        'Transfer',
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      )
                    ],
                  ),
                   Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       Image.asset(
                        'assets/icons/icon_scan.png',
                        width: 32.0,
                        height: 32.0,
                      ),
                       Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                       Text(
                        'Scan QR',
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      )
                    ],
                  ),
                  
                   Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       Image.asset(
                        'assets/icons/icon_menu.png',
                        width: 32.0,
                        height: 32.0,
                      ),
                       Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                       Text(
                        'Lainnya',
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      )
                    ],
                  ),*/
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildGojekServicesMenu() {
    return SizedBox(
        width: double.infinity,
        height: 220.0,
        child: Container(
            margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: GridView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: 8,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, position) {
                  return _rowGojekService(_gojekServiceList[position]);
                })));
  }

  Widget _rowGojekService(GojekService gojekService) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (gojekService.title == 'OJEK') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GoDriverPage(dataP: widget.dataP)),
                );
              } else if (gojekService.title == 'MOBIL') {
                // Navigator.push(
                //  context,
                //   MaterialPageRoute(builder: (context) => MyAppPaging()),
                // );
                // Navigator.push(
                //  context,
                //   MaterialPageRoute(builder: (context) => MyAppJarak()),
                // );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ContohList()),
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView()),
                );
              } else if (gojekService.title == 'KULINER') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GoFoodPage(dataP: widget.dataP)),
                );
              } else if (gojekService.title == 'KURIR') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KurirPage()),
                );
              } else if (gojekService.title == 'LISTRIK') {
                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListrikPage(dataP: widget.dataP)),
                );*/
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TopUpSaldo(
                            dataP: widget.dataP,
                          )),
                );
              } else if (gojekService.title == 'PULSA') {
                // Navigator.push(
                //     context,
                //    MaterialPageRoute(
                //        builder: (context) => PulsaPage(dataP: widget.dataP)),
                //  );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieScreenPage()),
                );
              } else if (gojekService.title == 'DAPURKU') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat1(
                              dataP: widget.dataP,
                              peerId: '1',
                              peerAvatar: '2',
                            )));
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DapurkuPage(dataP: widget.dataP)),
                );*/
              } else if (gojekService.title == 'SHOPEE') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapBelajar(dataP: widget.dataP)),
                );
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopeePage(dataP: widget.dataP)),
                );*/

              } else {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      return _buildMenuBottomSheet();
                    });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: GojekPalette.grey200, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              padding: EdgeInsets.all(12.0),
              child: Icon(
                gojekService.image,
                color: gojekService.color,
                size: 32.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.0),
          ),
          Text(gojekService.title, style: TextStyle(fontSize: 10.0))
        ],
      ),
    );
  }

  Widget _buildGoFoodFeatured() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'KULINER',
            style: TextStyle(fontFamily: 'NeoSansBold'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
          ),
          Text(
            'Pilihan Terlaris',
            style: TextStyle(fontFamily: 'NeoSansBold'),
          ),
          SizedBox(
            height: 172.0,
            child: FutureBuilder<List>(
                future: fetchFood(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.only(top: 12.0),
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return _rowGoFoodFeatured(snapshot.data[index]);
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
        ],
      ),
    );
  }

  Widget _rowGoFoodFeatured(Food food) {
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              food.img_menu,
              width: 132.0,
              height: 132.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
          ),
          Text(
            food.nmMmenu,
          ),
        ],
      ),
    );
  }

  Widget _buildPromo() {
    return Container(
        margin: EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: fetchPromo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                  children: snapshot.data.map<Widget>((data) {
                return _rowPromo(data);
              }).toList());
            }
            return Center(
              child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: const CircularProgressIndicator()),
            );
          },
        ));
  }

  Widget _buatPromo() {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    var itemHeight = (size.height - kToolbarHeight - 24) / 3;
    var itemWidth = size.width / 2;
    print((itemWidth / itemHeight));
    return FutureBuilder<List<Promosi>>(
      future: promos,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
              // scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(6.0),
              shrinkWrap: true,
              physics: ScrollPhysics(),
              // physics: const AlwaysScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (itemWidth / itemHeight),
                // childAspectRatio:0.8,
              ),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(6),
                  //height: 50.0,
                  //width: 100.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            offset: Offset(0, 2))
                      ]),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      splashColor: Colors.yellow,
                      highlightColor: Colors.blue,
                      onTap: () {
                        print('tapped');
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0)),
                              child: CachedNetworkImage(
                                imageUrl: '${snapshot.data[index].image}',
                                fit: BoxFit.cover,
                                height: double.infinity,
                                // height: 172.0,
                                width: double.infinity,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(strokeWidth: 1.0),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),

                              /* Image.network('${snapshot.data[index].image}', 
                                fit: BoxFit.cover,
                                height: double.infinity,
                              // height: 172.0,
                                width: double.infinity,
                            ),*/
                            ),
                            height: itemHeight - 80,
                            //borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                            // ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${snapshot.data[index].title}',
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: 'NeoSansBold', fontSize: 12.0),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 0.0, left: 8.0, right: 8.0, bottom: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Tanggal',
                                  maxLines: 1,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontFamily: 'NeoSans', fontSize: 12.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                );
              });
        } else if (snapshot.hasError) {
          return Text('Pastikan koneksi internet');
        }
        return Center(
          child: SizedBox(
              width: 40.0,
              height: 40.0,
              child: const CircularProgressIndicator()),
        );
      },
    );
  }

  List<Widget> _buildGridTiles(numberOfTiles) {
    var containers = List<Container>.generate(numberOfTiles, (int index) {
      //index = 0, 1, 2,...
      final imageName =
          index < 9 ? 'assets/images/promo_1.jpg' : 'assets/images/promo_1.jpg';
      return Container(
        child: Image.asset(imageName, fit: BoxFit.fill),
      );
    });
    return containers;
  }

  Widget _rowPromo(Promo promo) {
    return Container(
      height: 320.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            width: double.infinity,
            height: 1.0,
            color: GojekPalette.grey200,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              promo.image,
              height: 172.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          Text(
            promo.title,
            style: TextStyle(fontFamily: 'NeoSansBold', fontSize: 16.0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
          ),
          Text(
            promo.content,
            maxLines: 2,
            softWrap: true,
            style: TextStyle(color: Colors.grey, fontSize: 14.0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.0),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              color: GojekPalette.green,
              onPressed: () {},
              child: Text(
                promo.button,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'NeoSansBold',
                    fontSize: 12.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuBottomSheet() {
    return StatefulBuilder(builder: (c, s) {
      return SafeArea(
          child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0), color: Colors.white),
        child: Column(children: <Widget>[
          Icon(
            Icons.drag_handle,
            color: GojekPalette.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'GO-JEK Services',
                style: TextStyle(fontFamily: 'NeoSansBold', fontSize: 18.0),
              ),
              OutlineButton(
                color: GojekPalette.green,
                onPressed: () {},
                child: Text(
                  'EDIT FAVORITES',
                  style: TextStyle(fontSize: 12.0, color: GojekPalette.green),
                ),
              ),
            ],
          ),
          Container(
            height: 300.0,
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _gojekServiceList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, position) {
                  return _rowGojekService(_gojekServiceList[position]);
                }),
          ),
        ]),
      ));
    });
  }

  Future<List<Food>> fetchFood() async {
    var _goFoodFeaturedList = <Food>[];
    _goFoodFeaturedList.add(
        Food(nmMmenu: 'Steak Andakar', img_menu: 'assets/images/food_1.jpg'));
    _goFoodFeaturedList.add(
        Food(nmMmenu: 'Mie Ayam Tumini', img_menu: 'assets/images/food_2.jpg'));
    _goFoodFeaturedList.add(
        Food(nmMmenu: 'Tengkleng Hohah', img_menu: 'assets/images/food_3.jpg'));
    _goFoodFeaturedList.add(
        Food(nmMmenu: 'Warung Steak', img_menu: 'assets/images/food_4.jpg'));
    _goFoodFeaturedList.add(Food(
        nmMmenu: 'Kindai Warung Banjar', img_menu: 'assets/images/food_5.jpg'));

    return Future.delayed(Duration(seconds: 1), () {
      return _goFoodFeaturedList;
    });
  }

  Future<List<Promo>> fetchPromo() async {
    var _poromoList = <Promo>[];
    _poromoList.add(Promo(
        image: 'assets/images/promo_1.jpg',
        title: 'Bayar PLN dan BPJS, dapat cashback 10%',
        content:
            'Nikmatin cashback 10% untuk pembayaran PLN, BPJS, Google Voucher dan tagihan lain di GO-BILS.',
        button: 'MAU!'));
    _poromoList.add(Promo(
        image: 'assets/images/promo_2.jpg',
        title: '#CeritaGojek',
        content:
            'Berulang kali terpuruk tak menghalanginya untuk bangkit dan jadi kebanggan kami, Simak selengkapnya disini.',
        button: 'SELENGKAPNYA'));
    _poromoList.add(Promo(
        image: 'assets/images/promo_3.jpg',
        title: 'GOJEK Ultah Ke 8',
        content:
            '8 Tahun berdiri ada satu alasan kami tetap tumbuh dan berinovasi. Satu yang buat kami untuk terus berinovasi',
        button: 'CARI TAU!'));
    _poromoList.add(Promo(
        image: 'assets/images/promo_4.jpg',
        title: 'Gratis Pulsa 100rb*',
        content:
            'Aktifkan 10 Voucher GO-PULSAmu sekarang biar ngabarin yang terdekat gak pakai terhambat.',
        button: 'LAKSANAKAN'));
    _poromoList.add(Promo(
        image: 'assets/images/promo_4.jpg',
        title: 'Gratis Pulsa 100rb*',
        content:
            'Aktifkan 10 Voucher GO-PULSAmu sekarang biar ngabarin yang terdekat gak pakai terhambat.',
        button: 'LAKSANAKAN'));
    _poromoList.add(Promo(
        image: 'assets/images/promo_4.jpg',
        title: 'Gratis Pulsa 100rb*',
        content:
            'Aktifkan 10 Voucher GO-PULSAmu sekarang biar ngabarin yang terdekat gak pakai terhambat.',
        button: 'LAKSANAKAN'));

    _poromoList.add(Promo(
        image: 'assets/images/promo_4.jpg',
        title: 'Gratis Pulsa 100rb*',
        content:
            'Aktifkan 10 Voucher GO-PULSAmu sekarang biar ngabarin yang terdekat gak pakai terhambat.',
        button: 'LAKSANAKAN'));

    return Future.delayed(Duration(seconds: 3), () {
      return _poromoList;
    });
  }

  //coba promosi
  Future<List<Promosi>> fetchSeasons() async {
    var response = await CallApi().getData('getallpromotion?page=1&limit=10');
    Iterable list = json.decode('[]');

    print("token promosi  ${widget.dataP["token"]}");
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // print(response.body);
      list = body['data'];
      var promosi = list.map((season) => Promosi.fromJson(season)).toList();
      return promosi;
    }
    return list.map((season) => Promosi.fromJson(season)).toList();
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Tidak ada koneksi intenet'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
} //end class

class Promosi {
  Promosi({this.id, this.title, this.message, this.actionClick, this.image});
  final int id;
  final String title;
  final String message;
  final String actionClick;
  final String image;
  factory Promosi.fromJson(Map<String, dynamic> json) {
    return Promosi(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        actionClick: json['action_click'],
        image: json['image']);
  }
}
