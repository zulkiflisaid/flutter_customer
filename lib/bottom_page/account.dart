
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart'; 
import 'file_account/bukaweb.dart';
import 'file_account/package_info.dart';
import 'file_account/kode_promo.dart';
import 'file_account/kode_voucher.dart';
import 'file_account/pilih_bahasa.dart'; 
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';


class Accounts extends StatefulWidget {
  
  Accounts({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP; 
  @override
  _AccountsState createState() => _AccountsState();
}
  
class _AccountsState extends State<Accounts> {
 PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
   //buildNumber: 'Unknown',
  );


   @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

 Future<void> _initPackageInfo() async {
    var info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
 }

  @override
  Widget build(BuildContext context) {
     final RenderBox box = context.findRenderObject();
    return Scaffold(
      appBar: AppBar( 
           backgroundColor: Colors.white,
          brightness : Brightness.light,
          title: Text('Profil Saya',style: TextStyle(color: Colors.black ),), 
      ),
      body:Container( color: Colors.grey[50],
        child:ListView.builder(
          itemCount: AkunModel.dummyData.length, 
          itemBuilder: (context, index) { 
             var _model = AkunModel.dummyData[index];

            if(index==0){ 
              return Column( 
                children: <Widget>[
                  //Divider(
                  //  height: 12.0,
                 // ),
                  Container( 
                    padding: const EdgeInsets.all( 6 ),
                    //margin: const EdgeInsets.all(  6  ),
                    decoration: BoxDecoration(  color: Colors.white,
                         borderRadius: BorderRadius.circular(5.5)
                     ),
                    child:ListTile( 
                      // leading: CircleAvatar(
                      //   radius: 24.0,
                      //   backgroundImage: NetworkImage('https://scontent-sin6-2.xx.fbcdn.net/v/t1.0-9/540362_460651340627589_841780362_n.jpg?_nc_cat=105&_nc_sid=7aed08&_nc_oc=AQl2gKdqxeT0Y4Qh2dxBSRTOdGNjGPO2iZsR627veWYjxb94wpoMAY4T1XLEfewEAXM&_nc_ht=scontent-sin6-2.xx&oh=349871afc37b675510d6424f27777508&oe=5EBA8CB3'),
                      // ),
                      /*leading: CircleAvatar(  
                          backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.blue
                              : Colors.green,
                          child:Center(child:Text('${widget.data_p['name'][0]}' ,style: TextStyle(fontSize: 17.0),) 
                          ),
                        ),*/
                      leading: CircleAvatar(   
                          child: Icon(    Icons.account_box,   size: 24.0,  ), 
                        ),
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 16.0,height: 10,
                          ),
                          Text('${widget.dataP['name']}',     ), 
                          Text('${widget.dataP['email']}'  ), 
                          Text('${widget.dataP['hp']}'),
                        ],
                      ), 
                    // trailing: Icon(
                    //   Icons.mode_edit,
                    //   size: 24.0,
                    // ),
                    ),
                  ), 
                  

                  //tombol verfikasi
                  Visibility( visible: false,
                    child:  Padding(
                      padding: const EdgeInsets.all(  16),
                      child:  Container(
                        decoration: BoxDecoration(
                            color:  widget.dataP['aktivasi'] == '1'  ?  Colors.green  : Color(0xfff43f24),
                            border: Border.all(
                              color:Color(0xfff43f24),
                              width: 0.3,
                            ), 
                            borderRadius: BorderRadius.circular(23.0),
                        ), 
                         child:  Row(
                         //crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [  
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                                child: Container(
                                    child:  widget.dataP['aktivasi'] == '1'  ? 
                                     Text('Akun Terverifikasi',style: TextStyle( 
                                          fontFamily: 'NeoSans',
                                          fontSize: 14,color: Colors.white ,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                      )) : Text('Akun Belum Terverifikasi',style: TextStyle( 
                                          fontFamily: 'NeoSans',
                                          fontSize: 14,color: Colors.white ,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                      )), 
                                       
                                  ) , 
                            ) ,  
                              Padding(
                              padding: const EdgeInsets.only(right:  5),
                                child: Container(
                                    child: RaisedButton(
                                    textColor: Colors.red, 
                                    color: Colors.white ,
                                    child:  widget.dataP['aktivasi'] == '1'  ?  Text( 'Ubah')  : Text( 'Verifikasi') ,
                                    onPressed: () {   
                                      
                                    },
                                    shape:   RoundedRectangleBorder(
                                      borderRadius:   BorderRadius.circular(30.0),
                                    ),
                                  ),
                                )   , 
                            ) , 
                          
                        ]
                      ), 
                    ),
                  ), 
                  
                  ),
                 


                ],
              );
            }else if(index==1){
              //title akun
              return   ListTile(
                     title:  Text(_model.name),  
                 );
               
            }else if(index==7){ 
                //title lainnyya
              return   ListTile(
                     title:  Text(_model.name),   
                 );
               
            }else if(index==11){ 

               return Padding(
                      padding: const EdgeInsets.all(  16),
                      child:  RaisedButton(
                          textColor: Colors.red, 
                          color: Colors.white ,
                          child: Text( 'Keluar  '),
                          onPressed: () {  
                             FirebaseAuth.instance
                            .signOut()
                            .then((result) { 
                                Navigator.pushReplacementNamed(context, '/login');
                                // Navigator.of(context).pushReplacement(  MaterialPageRoute(builder: (_) {
                                //    return LogIn()  ;
                                //  }));
                              });
                           // .catchError((err) => print(err));
                            // logout();
                          },
                          shape:   RoundedRectangleBorder(
                            borderRadius:   BorderRadius.circular(30.0),
                          ),
                        ),
                       
                    );  
               
            }else{ 
              return  RaisedButton(color: Colors.white ,elevation: 0,
              onPressed: () {
                if(index==2){
                  //kode promo
                  Navigator.push( context,MaterialPageRoute(builder: (context) => KodePromo(dataP: widget.dataP,)),  ); 
                }else if(index==3){
                    //voucher
                   Navigator.push( context,MaterialPageRoute(builder: (context) => KodeVoucher(dataP: widget.dataP,)),  ); 
                }else if(index==4){
                     //bagikan aplikasi
                              Share.share('Ayo pakai aplikasi ini.',
                                  subject: 'https://play.google.com/store/apps/details?id=${_packageInfo.packageName}',
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) &
                                          box.size);
                }else if(index==5){
                   //bahasa
                   Navigator.push( context,MaterialPageRoute(builder: (context) => PilihBahasa()),  ); 
                }else if(index==6){
                     //bantuan
                    Navigator.push( context,MaterialPageRoute(builder: (context) => WebViewExample(title:'Bantuan', dataUrl: 'https://pribumisoftware.com/bantuan',)),  );
                }else if(index==8){
                     //kebijakan privasi
                     Navigator.push( context,MaterialPageRoute(builder: (context) => WebViewExample(title:'Kebijakan Privasi', dataUrl: 'https://pribumisoftware.com/kebijakanprivasi',)),  );
                }else if(index==9){
                      //ketentuan layanan
                     Navigator.push( context,MaterialPageRoute(builder: (context) => WebViewExample(title:'Ketentuan Layanan', dataUrl: 'https://pribumisoftware.com/ketentuanlayanan',)),  );
                }else if(index==10){
                    //beri nilai buka playstore
                     LaunchReview.launch(
                            androidAppId: '${_packageInfo.packageName}',
                            iOSAppId: '585027354',
                          );
                } 
                print(index);
                 
              }, // handle your onTap here
              child:      Column(
                children: <Widget>[
                  Divider(
                    height: 1.0,
                  ),
                  ListTile(
                    leading:  _model.avatarUrl,
                    title: Row( 
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[ 
                        Expanded(
                          child: Text(  _model.name,    ),
                        ),
                         Text( index==10 ?  _packageInfo.version : _model.versi , style: TextStyle(fontSize: 12.0),),
                      ],
                    ),
                   // subtitle: Text(_model.message),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.0,
                    ),
                  ),
                ],
                ),
              );
            }
            
          },
        ),   
      ),  
    );
  }

  void logout() async{
      // logout from the server ... 
      //var res = await CallApi().getData('logout');
      //var body = json.decode(res.body);
       
        var localStorage = await SharedPreferences.getInstance();
        //localStorage.remove('user');
        //localStorage.remove('token');  
        await localStorage.setString('is_login', ''); 

        //Navigator.push(  context,  MaterialPageRoute(   builder: (context) => LogIn()));
        
        await Navigator.of(context).pushReplacement(  MaterialPageRoute(builder: (_) {
          return LoginPage()  ;
        }));
     
  }
}
 
 

class AkunModel {
   
  AkunModel({this.avatarUrl, this.name, this.versi, this.message});

  final Icon avatarUrl;
  final String name;
  final String versi;
  final String message;
  static final List<AkunModel> dummyData = [
     AkunModel(
      avatarUrl:  Icon(Icons.edit,size: 24,) ,
      name: 'Nama',
      versi: 'hp',
      message: 'email',
    ), 
    AkunModel( 
     avatarUrl:  Icon(Icons.edit) ,
      name: 'Akun', 
      versi: '', 
     
    ),
    AkunModel(
       avatarUrl:  Icon(Icons.event,size: 24,) ,
      name: 'Kode promo Saya',
      versi: '', 
    ),  
    AkunModel(
      avatarUrl:  Icon(Icons.label_outline,size: 24,) ,
      name: 'Voucher Saya',
      versi: '', 
    ),
     AkunModel(
      avatarUrl:  Icon(Icons.share,size: 24,) ,
      name: 'Ajak teman',
      versi: '', 
    ),
    AkunModel(
       avatarUrl:  Icon(Icons.translate) ,
      name: 'Pilih bahasa',
      versi: '', 
    ),
    AkunModel(
      avatarUrl:  Icon(Icons.help_outline,size: 24,) ,
      name: 'Bantuan',
      versi: '', 
    ), 
     AkunModel( 
      name: 'Info Lainnya', 
    ),
     AkunModel(
      avatarUrl:  Icon(Icons.verified_user,size: 24,) ,
      name: 'Kebijakan Privasi',
      versi: '', 
    ),
    AkunModel(
      avatarUrl:  Icon(Icons.info,size: 24,) ,
      name: 'Ketentuan Layanan',
      versi: '', 
    ),
    AkunModel(
       avatarUrl:  Icon(Icons.star,size: 24,) ,
      name: 'Beri Kami Nilai',
      versi: '1.0.1', 
    ), 
     AkunModel( 
       avatarUrl:  Icon(Icons.edit) ,
      name: 'Keluar', 
      versi: '', 
     
    ),
  ];
}
