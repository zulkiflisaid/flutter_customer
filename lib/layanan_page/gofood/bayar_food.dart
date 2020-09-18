 
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:intl/intl.dart';
import 'package:pelanggan/layanan_page/gofood/map_lokasi.dart';
import 'package:pelanggan/layanan_page/gofood/restoran.dart'; 
 
 
import 'package:pelanggan/librariku/bintang.dart';

import '../../constans.dart'; 
import 'package:pelanggan/api/firestore_db.dart'; 
 

class BayarFood extends StatefulWidget {
  BayarFood({Key key, this.dataP , this.restoPesanan }) : super(key: key);
  final Map<String, dynamic> dataP; 
 final Map<String, dynamic> restoPesanan;  
  
  @override
  _BayarFoodState createState() =>   _BayarFoodState();
}

class _BayarFoodState extends State<BayarFood> {

  var uang =   NumberFormat.currency(locale: 'ID', symbol: '',decimalDigits:0); 
  int awal=0;
  var  header='';
  final databaseRef = Firestore.instance;
  final controllerKeterangan = TextEditingController(); 
  bool visibilityitemBayar=false;
  var idResoran='';
  var itemPesanan=0;
  var hargaPesanan=0; 
  ZulLib  zulLib= ZulLib();
  Stream<dynamic> querySnapshot  ;
  int hrgPengiriman=0; 
  var menus; 
  CrudMedthods crudObj =   CrudMedthods();
   Map<String,dynamic> restoPesanan  ={};
  var payCategories='0';  

  @override
  void initState(){ 

   crudObj.getFoodPesanan(widget.dataP['uid']).then((results) { 
       
      if (mounted){ 
          setState(() {  
              querySnapshot=  results;
              menus = results;
          }); 
      } 
    }); 
    super.initState();  
   
    controllerKeterangan.text=  widget.dataP['ket_antar'];  
    restoPesanan['id_resto']=''; 
    if (menus != null && mounted && restoPesanan['id_resto']=='') { 
         querySnapshot.listen((snapshot) {
           
        var  total =0;   var  idnyaResto='';
        var  items =0;  var   visibilityitem =false; 
        snapshot.documents.forEach((element) { 
          total =  total + (element.data['hrg']*element.data['qity']);
          items=items+element.data['qity'];
           visibilityitem =true; 
            idnyaResto=element.data['id_resto'];
        });
          //.fold(0, (tot, doc) => tot + (doc.data['hrg']*doc.data['qity']));
          if (mounted){
            setState(() { 
                idResoran=idnyaResto;
                visibilityitemBayar= visibilityitem;
                hargaPesanan=total  ; 
                itemPesanan=items  ; 
            });
            if(restoPesanan['id_resto']=='' && idResoran!='' && idResoran!=null){
                
                _getRestoPesanan(  idResoran);
            }  
           
          }  
         // debugPrint(totalHarga.toString());
      });
    }
    
  } 
   
  Future<void> _getRestoPesanan(String idResto)  async {
    crudObj.getRestoById(idResto).then((results) {  
            DocumentReference aa =results; 
            aa.get().then((value)   {
               var  bukaOrtutup  = zulLib.bukaOrtutup( value.data['buka']) ; 
             // print(widget.dataResto['img']);
             //  print(widget.dataResto['img']);
                setState(() {   
                  restoPesanan['id_resto']= value.documentID;
                    restoPesanan['nm_resto']  = value.data['nm_resto'];
                   restoPesanan['ket_resto']= value.data['ket_resto']; 
                     restoPesanan['img']= value.data['img']; 
                    restoPesanan['jarak']  =  zulLib.calculateDistance(value.data['posisi'],LatLng(widget.dataP['lat_antar'], widget.dataP['long_antar'])); 
                    restoPesanan['bintang']   =zulLib.bintang(value.data['counter_reputation'], value.data['divide_reputation']);   
                    restoPesanan['divide_reputation']  =value.data['divide_reputation'];  
                    restoPesanan['min_hrg']  =value.data['min_hrg']; 
                    restoPesanan['status']  =bukaOrtutup['status']; 
                  restoPesanan['buka']   =bukaOrtutup['tutup']; 
                    restoPesanan['tutup']  =bukaOrtutup['tutup']; 
                    
              });   
            }); 
    });  
   /* await  Firestore.instance
    .collection('flutter_resto')
    .document(restoPesanan['id_resto'])
    .get()
    .then((DocumentSnapshot dt) {
      //  print(dt.data['nm_resto'].toString()); 
        var bintang   = zulLib.bintang(dt.data['counter_reputation'],dt.data['divide_reputation']) ;
        var  bukaOrtutup  = zulLib.bukaOrtutup( dt.data['buka']) ;
        LatLng   _initialPosition = LatLng(restoPesanan['lat'],restoPesanan['long']);    
              
        restoPesanan['id_resto']= dt.documentID;
        restoPesanan['nm_resto']= dt.data['nm_resto'];
        restoPesanan['ket_resto']= dt.data['ket_resto'];
        restoPesanan['img']= dt.data['img'];
        restoPesanan['jarak']= zulLib.calculateDistance(dt.data['posisi'],_initialPosition); 
        restoPesanan['bintang']=bintang;   
        restoPesanan['divide_reputation']=dt.data['divide_reputation'];   
        restoPesanan['min_hrg']=dt.data['min_hrg']; 
        restoPesanan['status']=bukaOrtutup['status']; 
        restoPesanan['buka']=bukaOrtutup['tutup']; 
        restoPesanan['tutup']=bukaOrtutup['tutup']; 
    });*/
     
  }
  
  void setQity(int numQity , String idItem ){

       if(numQity>0){
          databaseRef .collection('flutter_keranjang') 
          .document(widget.dataP['uid'])
          .collection('food')
          //.where('field',isEqualTo: '');
          .document(idItem) 
          .updateData({ 
                'qity':numQity,  
            }).whenComplete(( ) {  
             
              //  _hitungHarga();
          }).catchError( (err) { 
              print('catchError'); 
          }); 
       }else{
          databaseRef .collection('flutter_keranjang') 
          .document(widget.dataP['uid'])
          .collection('food')
          //.where('field',isEqualTo: '');
          .document(idItem) 
          .delete( ).whenComplete(( ) {  
             if(itemPesanan==0 && mounted){  
                    Navigator.pop(context);
              }  
             //_hitungHarga();
          }).catchError( (err) { 
              print('catchError'); 
          }); 
       } 
      
  } 
   
  void _hitungHarga(){
      querySnapshot.listen((snapshot) {
           
        var  total =0;   var  idnyaResto='';
        var  items =0;  var   visibilityitem =false; 
        snapshot.documents.forEach((element) { 
          total =  total + (element.data['hrg']*element.data['qity']);
          items=items+element.data['qity'];
           visibilityitem =true; 
            idnyaResto=element.data['id_resto'];
        });
          //.fold(0, (tot, doc) => tot + (doc.data['hrg']*doc.data['qity']));
          if (mounted){
            setState(() { 
                idResoran=idnyaResto;
                visibilityitemBayar= visibilityitem;
                hargaPesanan=total  ; 
                itemPesanan=items  ; 
            });
            if(restoPesanan['id_resto']=='' && idResoran!='' && idResoran!=null){
                  
                _getRestoPesanan(  idResoran);
            }  
           
          }  
         // debugPrint(totalHarga.toString());
      });
       
  }

  @override
  Widget build(BuildContext context) {
    if (menus != null && mounted && restoPesanan['id_resto']=='') { 
         _hitungHarga(); 
    }
     
   
    return Scaffold( 
      appBar: AppBar(   
            elevation:1,
            backgroundColor: Colors.white, 
            brightness : Brightness.light, 
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () { 
                Navigator.pop(context);
              },
            ),  
            title:  Text('Selesaikan Pesanan',style: TextStyle(color: Colors.black ),), 
       ), 
        body:   Container( 
        color: Colors.white,
        height: double.maxFinite,
        child:   Stack( 
          children: <Widget>[
            ListView(   
               shrinkWrap: true,  
              children: <Widget>[
                //lokasi
                Container( 
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0), 
                  child:Text('Antar ke' , maxLines: 1,
                    style: TextStyle( 
                          fontFamily: 'NeoSans', 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                    ), 
                   ),
                ),  
                Container( 
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0), 
                  child:Text('${widget.dataP['adress_antar']}' ,  softWrap: true,
                    style: TextStyle(  
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
                       Text('Rincian : ' , 
                          style: TextStyle(  
                            color:  Colors.blue,  
                            letterSpacing: 0,
                          ),
                        ),
                        Expanded(
                          child:   Text('${widget.dataP['ket_antar']} vvvvvvvvvvv vvvvvvvvvvv vvvvvvvvvvvvvv vvvvvvvvvvv vvvvvvvvvvvvvvvvvvvvvv',maxLines: 3),
                        )
                       
                    ],
                  )
                ),   
                Divider(height: 16, color: Colors.grey[100],thickness: 12.0,), 
               

                //mode bayar
                Container( 
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0), 
                  child:Text('Metode Pembayaran' , maxLines: 1,
                    style: TextStyle( 
                          fontFamily: 'NeoSans', 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                    ), 
                   ),
                ), 
                RaisedButton(
                onPressed: () { 
                  _showModeBayar ();  
                },
                shape:   RoundedRectangleBorder(
                  borderRadius:   BorderRadius.circular(5.0),
                ), 
                color: Colors.white,elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(  Icons.monetization_on ,  size: 30.0, color: Colors.green ),  
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all( 6.0), 
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(payCategories=='tunai' ? 'BAYAR TUNAI KE DRIVER ' :'BAYAR PAKAI SALDO',
                                softWrap: true,
                                style: TextStyle(     letterSpacing: 0,   ), 
                              ),
                            ), 
                        ),
                    
                    ),
                    Icon(  Icons.more_vert ,  size: 24.0, color: Colors.grey ),  
                  ],
                  ),
                ), 
                Divider(height: 16, color: Colors.grey[100],thickness: 12.0,), 

               

                //Restoran dan daftar belenja
                Container( 
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0), 
                  child:Text('Daftar Pesanan' , maxLines: 1,
                    style: TextStyle( 
                          fontFamily: 'NeoSans', 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                    ), 
                  ),
                ),  
                // nama restoran 
                Container( 
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0), 
                  child:Text('${restoPesanan['nm_resto']}' , maxLines: 3, softWrap: true,
                    style: TextStyle( 
                      fontFamily: 'NeoSans', 
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0,
                    ),
                  ), 
                ),  
                /*Container( 
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0), 
                  child:Text('${restoPesanan['alamat_resto']}' , maxLines: 3, softWrap: true,
                    style: TextStyle( 
                      fontFamily: 'NeoSans',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0,
                    ),
                  ), 
                ),  */
                  Divider(height:10) ,   
                //item 
                Container( 
                   //padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 0.0),
                  color: Colors.white,
                  child: _keranjangList()  
                ) ,  
                 Divider(height: 16, color: Colors.grey[100],thickness: 12.0,), 

                //Rincian Harga
                Container( 
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0), 
                  child:Text('Rincian Harga' , maxLines: 1,
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
                       Text('Total harga kuliner  ' ,   ),
                       Text('${widget.dataP['ket_antar']}   ' ),  
                    ],
                  )
                ),     
                Container( 
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0), 
                  child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('Ongkos antar  ' ,   ),
                       Text('${widget.dataP['ket_antar']}   ' ),  
                    ],
                  )
                ),   
                Container( 
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0), 
                  child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('Diskon  ' ,   ),
                       Text('${widget.dataP['ket_antar']}   ' ),  
                    ],
                  )
                ),   
               // Divider(height:10) ,    
                /*Text('${restoPesanan['nm_resto']}'),
                Text('${restoPesanan['ket_resto']}'), 
                Text('${widget.dataP['adress_antar']}' ),
                Text('${widget.dataP['lat_antar']}'),
                Text('${widget.dataP['long_antar']}'),
                Text('${widget.dataP['ket_antar']}'),*/
                    
                  Divider(height: 16, color: Colors.grey[100],thickness: 12.0,),     
                SizedBox(    height: 110,   ),
             
              ],
            ),  
            //tempat tombol bayar dan harga total belajaan
          Visibility(
            visible: visibilityitemBayar,
            child:  Positioned(
              child:   Align(
                alignment: FractionalOffset.bottomCenter, 
                child: Container(
                  padding: const EdgeInsets.all(  6 ),
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
                  height: 60,
                  width: MediaQuery.of(context).size.width, 
                  margin: EdgeInsets.only(top: 16.0),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,  
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: <Widget>[ 
                      Container(    
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,  
                          children: <Widget>[  
                            Text('Total Harga', style: TextStyle(
                                  letterSpacing: 0,   fontSize: 14, 
                                decoration: TextDecoration.none,  
                                )
                              ),   
                                
                              Text('Rp${uang.format(hargaPesanan)}', style: TextStyle(
                                  letterSpacing: 0,
                                color: Colors.orange[800],  
                                decoration: TextDecoration.none,  fontSize: 16,  
                                )
                              ),  
                          ],
                        ),
                      ) , 
                      RaisedButton( 
                          onPressed:(){  
                            
                                  if(restoPesanan ['status']=='Buka'){ 
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => Restoran( dataP: widget.dataP, dataResto: dataResto,)),  );
                                  }else{
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                        content: Text("Oupss... Restorannya tutup, Cari restoran lain aja ya :)"),
                                      ));
                                    
                                  }  
                          },
                          shape:   RoundedRectangleBorder(
                            borderRadius:   BorderRadius.circular(16.0),
                          ), 
                          color:Colors.orange[800],elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0),
                          child:   Text(itemPesanan==0 ? 'Bayar':'Bayar ($itemPesanan)' ,  style: TextStyle( 
                            color: Colors.white,   decoration: TextDecoration.none,  
                            )), 
                      ), 
                    ]
                  ),  
                ),  
              ),
            )
          ),
          ],
        ),
      ), 
    ); 
  }      

  Future<Map<String, dynamic>> navigateToEntryForm(BuildContext context, String panggilPage) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) { 
            return SetLokasiPage( ); 
        }
      ) 
    );
    return result;
  }
    
  Widget _keranjangList() {
    if (menus != null) {
        
      return StreamBuilder(
        stream: menus,
        builder: ( context, snapshot) {
          if (!snapshot.hasData){
                   return (Center(child: CircularProgressIndicator()));
          } else    {
               
              return  ListView.separated( 
                 separatorBuilder: (BuildContext context, int index) {  
                  return   Divider(height: 1 );
              },  
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.documents.length,
             // padding: EdgeInsets.all(5.0),
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
  
  Widget _rowKerangjang( DocumentSnapshot queueDoc  ) { 
      
    return   Padding( 
      padding: const EdgeInsets.only(   top: 6,bottom: 6 ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /* ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            child:CachedNetworkImage(
                  imageUrl:queueDoc['img_menu'],
                  fit: BoxFit.cover,
                  height: 80,
                  // height: 172.0,
                  width: 100,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
              )  
          ), */
          Expanded(
            //width: 250,
            child: Padding(
              padding: const EdgeInsets.only(  left: 5),
              child:      Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(queueDoc.data['nm_menu'],   
                        style: TextStyle( 
                        fontWeight: FontWeight.bold, letterSpacing: 0,
                        color: Colors.black, fontFamily: 'NeoSans',    fontSize: 16,
                        )
                  ),   
                  Text('Rp${uang.format(queueDoc.data['hrg'])}  X  ${queueDoc.data['qity']}', style: TextStyle(
                            letterSpacing: 0,
                          color: Colors.orange[800], fontFamily: 'NeoSans',fontSize: 14, 
                          decoration: TextDecoration.none,  
                          )
                  ), 
                  Container(  
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          Text('catatan:' ,  style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 0,    decoration: TextDecoration.underline,  
                          )),
                          Text('${widget.dataP['ket_antar']}' ,maxLines: 3,),  
                        ],
                      )
                    ),    
                ],
              ),
            ),
           )  
        ],
      ),  
    );
  }  
   
  //dialog pilih metodebayar
  void _showModeBayar() {
    showModalBottomSheet( 
      context: context,
      backgroundColor: Colors.transparent,
      elevation:4,
      isDismissible: true,  
      //useRootNavigator: useRootNavigator, 
      isScrollControlled: true, 
      builder: (_) {
         return Container(height: 200,
           padding:EdgeInsets.symmetric(
            horizontal: 15,vertical:10 
          ) ,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight:  Radius.circular(16.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
              )]  
          ),
            child:   ListView( 
              children: <Widget>[  
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                //SizedBox( height: 10.0, ), 
                Divider(  color: Colors.grey, height:5,   ), 
                RaisedButton(
                  onPressed: () { 
                      //  setModeBayar('tunai');
                      Navigator.pop(context);
                  },
                  shape:   RoundedRectangleBorder(
                    borderRadius:   BorderRadius.circular(5.0),
                  ), 
                  color: Colors.white,elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(  Icons.monetization_on ,  size: 30.0, color: Colors.green ),  
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all( 6.0), 
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text('TUNAI',
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
                Divider(  color: Colors.grey, height:5,   ), 
                RaisedButton(
                  onPressed: () { 
                     //  setModeBayar('saldo');
                      Navigator.pop(context);
                  },
                  shape:   RoundedRectangleBorder(
                    borderRadius:   BorderRadius.circular(5.0),
                  ), 
                  color: Colors.white,elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(  Icons.local_atm ,  size: 30.0, color: Colors.green ),  
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all( 6.0), 
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text('SALDO',
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
                      //Text('Rp $saldoCustomer ')// ${uang.format(saldoCustomer)} 
                    ],
                  ),
                ),
                  
              ],

            ),
         );
      },
    );
  }
   
}
  
  
