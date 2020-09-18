//import 'dart:io';
import 'dart:ui'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
 
  
 
class DetailOrder extends StatefulWidget {
  
  DetailOrder({
    Key key,
    this.dataP,
    this.uid,
    this.created, 
    this.kdTransaksi,
    this.totalPrices, 
    this.categoryOrder,
    this.payCategories, 
    this.statusOrder, 
    this.jemputAlamat,  
    this.tujuanAlamat, 
    this.distanceText,   
  }) : super(key: key);

  final Map<String, dynamic> dataP; 
   final String uid;  
  final String created;  
  final String kdTransaksi; 
   final int totalPrices;  
  final String categoryOrder;
  final String payCategories;  
  final String statusOrder; 
final String jemputAlamat;  
  final String tujuanAlamat; 
 final String distanceText;  
  
  @override
  _DetailOrderState createState() => _DetailOrderState();
   
}


class _DetailOrderState extends State<DetailOrder> {
   
  final _scaffoldKey = GlobalKey<ScaffoldState>(); 
  var uang =   NumberFormat.currency(locale: 'ID', symbol: '',decimalDigits:0);  
  final dbRef = Firestore.instance;
  
  //File _image;    
  final databaseRef = Firestore.instance; 
  String radioItem = 'Saya telah menunggu terlalu lama'; 
  int idPilihanKusioner = 1;
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
 

  @override
  void dispose() { 
    super.dispose();
  } 

  @override
  void initState(){ 
    super.initState();   
  }
 
 // Future<File> _getLocalFile( ) async { 
  //  return _image;
  //}
  
  @override
  Widget build(BuildContext context){ 
   
    return  Scaffold(
       key: _scaffoldKey,    
       appBar: AppBar(  
        backgroundColor: Colors.white, 
        brightness : Brightness.light,
        title: Text('Detail Order',style: TextStyle(color: Colors.black ),), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () { 
            Navigator.pop(context);
          },
        ),   
      ), 
      body:  SingleChildScrollView( 
         physics: ScrollPhysics(),
        child:  Container( color: Colors.white ,
          padding: const EdgeInsets.all(10.0),
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: <Widget>[ 
                //////////kode dan tanggal//////////////
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[ 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[ 
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[ 
                            Text('${widget.kdTransaksi} ',style: TextStyle(fontSize: 16,color: Colors.blue),), 
                            InkWell(
                              child:  Icon(Icons.content_copy ,size: 16, color: Colors.green,),
                              onTap:  () {
                                  Clipboard.setData( ClipboardData(text: widget.kdTransaksi));
                                  _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content:  Text('ID telah dicopy'),));
                              }, 
                              onLongPress: () {
                              //  Clipboard.setData( ClipboardData(text: document['kd_transfer']));
                                // _scaffoldKey.currentState.showSnackBar(
                              //  SnackBar(content:  Text('Kode Top Up telah dicopy'),));
                              },
                            ) 
                          ]
                        ) ,
                          
                        Text(widget.created  ,style: TextStyle( color: Colors.grey),),    
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[ 
                          Text(  widget.categoryOrder=='ojek' ? 'OJEK' : 
                          widget.categoryOrder=='car4' ? 'MOBIL 4' :
                          widget.categoryOrder=='car5' ? 'MOBIL 6' :
                          widget.categoryOrder=='food' ? 'KULINER' :
                          widget.categoryOrder=='semabko' ? 'SEMBAKO' : 'OJEK',
                          style: TextStyle(fontSize: 14,),),
                          Container(
                            padding:   EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                            decoration: BoxDecoration(
                                color:  Colors.white ,
                                border: Border.all(
                                  color: widget.statusOrder=='selesai' ? Colors.blue : 
                                  widget.statusOrder=='batal' ? Colors.red : Colors.green ,
                                  width: 1,
                                ), 
                                borderRadius: BorderRadius.circular(6.0),
                            ), 
                            child: Text(
                              widget.statusOrder=='selesai' ? 'selesai' : 
                              widget.statusOrder=='batal' ? 'dibatalkan' : 'dalam proses',
                              style: TextStyle( color: Colors.black),),
                          ),
                      ],
                    ),  
                  ],
                ),
                Divider(  color: Colors.grey,  height:16, ),
               
                /////////jemput dan tujuan///////////////
                Row(
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
                            Text('Jemput : ${widget.distanceText}' , maxLines: 1,
                              style: TextStyle( 
                                    fontFamily: 'NeoSans',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0,
                              ), 
                            ),
                            Text(widget.jemputAlamat , maxLines: 3, softWrap: true,
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
                    ],
                ), 
                Divider(  color: Colors.grey,  height:16, ), 
                Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ 
                      Padding(
                        padding: const EdgeInsets.only( right: 6),
                        child: 
                          Icon(  Icons.adjust ,  size: 32.0, color: Colors.orange ), 
                      ),  
                      Expanded(
                      child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tujuan  ' , maxLines: 1,
                              style: TextStyle( 
                                    fontFamily: 'NeoSans',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0,
                              ), 
                            ),
                            Text(widget.tujuanAlamat , maxLines: 3, softWrap: true,
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
                    ],
                ), 
                Divider(  color: Colors.grey,  height:16, ),
                
                ///////// detail food dan sembako///////////////
               
                widget.categoryOrder=='food' ?  StreamBuilder<QuerySnapshot>(
                  
                  stream: Firestore.instance
                      .collection('flutter_order') 
                      //  .where('pelanggan_uid', isEqualTo: widget.data_p['uid'])
                        //  .where('created', isGreaterThan: mundur_satuhari)
                      //.document(widget.data_p['uid'])
                    //.collection('order')
                      .orderBy('created') 
                      .snapshots(),
                  builder: (BuildContext context,  AsyncSnapshot<QuerySnapshot> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:  return   CircularProgressIndicator() ;
                      
                      default:
                        return ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                        //  scrollDirection: Axis.vertical,
                        
                          children: snapshot.data.documents  .map((DocumentSnapshot document) {
                            return   InkWell(
                              child: Card(  
                                margin:  const EdgeInsets.all(  10.0, ),
                                child: Text('m'),
                              ), 
                            );
                          }).toList(),
                        );
                    } 
                  } 
                ): SizedBox(  )  ,
                
                 ///////// Pembayaran///////////////
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[ 
                    Text('Pembayaran',maxLines: 2,
                    style: TextStyle(  fontFamily: 'NeoSans',
                        color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0,),),  
                    Text(  widget.payCategories=='tunai' ? 'TUNAI' :'SALDO'  ,
                    style: TextStyle( ),),
                    
                  ],
                ), 
                Divider(  color: Colors.grey,  height:10, ), 

                ///////// harga///////////////
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[ 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[ 
                        Text('Total Harga',style: TextStyle( color: Colors.grey),), 
                        
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[  
                        Text('Rp ${uang.format(widget.totalPrices)}',style: TextStyle(fontSize: 18),),   
                      ],
                    ),  
                  ],
                ),
                Divider(  color: Colors.grey,  height:16, ),
                
               
               
                ////BATAL/////////////////// 
                Align(
                  alignment: Alignment.topCenter,
                  child: widget.statusOrder=='selesai' ?   SizedBox(  ) : 
                    widget.statusOrder=='batal' ? SizedBox(  ) :  
                    FlatButton(color: Colors.red[400],
                      child: Text('BATAL',style: TextStyle(fontSize: 14, color: Colors.white),),
                      onPressed: () {   
                            _showKusionerGagal();
                      }
                  )
                ),  
              ],
            )
          )
         )
    );
  }
   
   
  Future<void> _batalkanOrder(   String pilihankusioner ) async{  
      await databaseRef.collection('flutter_order')
      .where('id',isEqualTo: widget.uid ) 
      .getDocuments()
      .then((QuerySnapshot snapshot) { 
         snapshot.documents.forEach((resultOrder) async { 
           
            if(resultOrder.data['pay_categories'] =='saldo' &&  resultOrder.data['status_order'] !='batal'){ 
               await databaseRef.collection('flutter_customer')
              .where('uid',isEqualTo:widget.dataP['uid'] )
              .getDocuments()
              .then((QuerySnapshot snapsh) { 
                 snapsh.documents.forEach((resultCustomer) async { 

                      await databaseRef .collection('flutter_order') 
                      .document(widget.uid )
                      .updateData({ 
                            'status_order': 'batal',  
                            'cancel_id': pilihankusioner,    
                      }).then((res){ 
                           databaseRef 
                          .collection('flutter_customer') 
                          .document(widget.dataP['uid'])
                          .updateData({ 
                                'saldo':   resultOrder.data['total_prices']  +  resultCustomer.data['saldo']   
                          }).whenComplete((){ 
                                _pesanGagal('Pesanan berhasil dibatalkan');
                                
                          }).catchError( (err){ 
                             
                          });  
                         
                      }).catchError((err){ 
                          _pesanGagal('Gagal mengubah data');
                      });  
                 }); 
                }) .catchError( (err){ 
                  _pesanGagal('Gagal mengubah data, data pengguna tidak ditemukan');
                 
                }); 
            } else{
                await databaseRef .collection('flutter_order') 
                .document(widget.uid )
                .updateData({ 
                      'status_order': 'batal',  
                      'cancel_id': pilihankusioner,    
                }).then((res){ 
                     _pesanGagal('Pesanan berhasil dibatalkan'); 
                      
                }).catchError((err){ 
                    _pesanGagal('Gagal mengubah data');
                });  
            }
            
             
      });
    });

       
  } 
 
  //dialog batal kusioner
  void _showKusionerGagal(){

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      //elevation:500,
      isDismissible: true,  
      //useRootNavigator: useRootNavigator, 
      isScrollControlled: true, // set this to true when using DraggableScrollableSheet as child
      builder: (BuildContext context) {
        return DraggableScrollableSheet( 
            expand: false,
            initialChildSize: 0.95,
            minChildSize: 0.0,
            maxChildSize: 0.95,
        builder: (_, controller) { 
            return StatefulBuilder( 
              builder: (BuildContext context, StateSetter state) {  
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return ClipRRect(
                        //borderRadius: borderRadius.evaluate(CurvedAnimation(parent: _controller, curve: Curves.ease)),
                        borderRadius:   BorderRadius.only(
                          topLeft: const Radius.circular(16.0),
                          topRight: const Radius.circular(16.0),
                        ),child: Container(
                          color: Colors.white,
                          child: CustomScrollView(
                            controller: controller, 
                            slivers: <Widget>[
                              SliverAppBar(
                                title: Text('Alasan Order dibatalkan?',
                                  style:   TextStyle(fontSize: 18.0, color: Colors.black),
                                ),
                                backgroundColor: Colors.white,
                                automaticallyImplyLeading: false,
                                primary: false,
                                floating: true,
                                pinned: true,
                              ),  
                              SliverList(
                                  delegate: SliverChildListDelegate(
                                    [ 
                                      Container(
                                        height: 280.0,
                                        child: Column(
                                          children: 
                                            fList.map((data) => RadioListTile(
                                              title: Text('${data.name}'),
                                              groupValue: idPilihanKusioner,
                                              value: data.index,
                                              onChanged: (val) {
                                                state(() {
                                                  radioItem = data.name ;
                                                  idPilihanKusioner = data.index;
                                                });
                                              },
                                            )).toList(),
                                        ),
                                      ), 
                                      Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child:  RaisedButton( 
                                               shape:   RoundedRectangleBorder(
                                                  borderRadius:   BorderRadius.circular(5.0),
                                                ), 
                                                color: Colors.green,elevation: 0,  
                                                onPressed: () { 
                                                    Navigator.pop(context); 
                                                    //kirim kusioner tidak usah menunggu resopon dan kembalikan ke mode ModeFirstOpen()
                                                    _batalkanOrder(idPilihanKusioner.toString()); 
                                                     
                                                   
                                                },
                                                child: Text('Kirim', style:   TextStyle(color: Colors.white)),
                                              ), 
                                      ),
                                      Container(
                                        color: Colors.white, 
                                        height:  50.0,  width: 100.0,
                                         
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
          } 
        );
      }
    ); 
  }

  void _pesanGagal(String pesan){ 
      Fluttertoast.showToast(
              msg: pesan,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
      ); 
      Navigator.pop(context); 
  }

} 
 
class KusionersList { 
  KusionersList({this.name, this.index});
  String name;
  int index;
}