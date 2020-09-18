import 'dart:ui'; 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';
 
 
  
 
class KodePromo extends StatefulWidget {
  
  KodePromo({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP; 
  @override
  _KodePromoState createState() => _KodePromoState();
   
}


class _KodePromoState extends State<KodePromo> {
  
  @override
  void dispose() { 
    super.dispose();
  } 

  @override
  void initState(){ 
        super.initState(); 
       
      
  }
 

  @override
  Widget build(BuildContext context){ 
   
    return  Scaffold(
      appBar: AppBar(  
        backgroundColor: Colors.white, 
        brightness : Brightness.light,
        title: Text('Kode Promo Saya',style: TextStyle(color: Colors.black ),), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () { 
            Navigator.pop(context);
          },
        ),   
      ), 
      body:  Container(
          child:   Text('', ),
      ),   
    );
  }
   
 

 
} 


