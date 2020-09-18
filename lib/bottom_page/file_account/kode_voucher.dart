import 'dart:ui'; 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';
 
 
  
 
class KodeVoucher extends StatefulWidget {
  
  KodeVoucher({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP; 

  @override
  _KodeVoucherState createState() => _KodeVoucherState();
   
}


class _KodeVoucherState extends State<KodeVoucher> {
  
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
    //_panelHeightOpen = MediaQuery.of(context).size.height ;
   
    return  Scaffold(
      appBar: AppBar(  
        backgroundColor: Colors.white, 
        brightness : Brightness.light,
        title: Text('Voucher',style: TextStyle(color: Colors.black ),), 
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


