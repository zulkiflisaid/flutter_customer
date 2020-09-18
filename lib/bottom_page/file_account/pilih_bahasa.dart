import 'dart:ui'; 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';
 
 
  
 
class PilihBahasa extends StatefulWidget {
 
  PilihBahasa({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP; 
  
  @override
  _PilihBahasaState createState() => _PilihBahasaState();
   
}


class _PilihBahasaState extends State<PilihBahasa> {
  int _currentIndex = 1;

 
final List<int> _texts = [
    1, 
  ];

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
        title: Text('Voucher',style: TextStyle(color: Colors.black ),), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () { 
            Navigator.pop(context);
          },
        ),   
      ), 
      body:  Container(color:Colors.white,
        child:  ListView(
          padding: EdgeInsets.all(8.0),
          children: _texts
              .map((text) => RadioListTile(
                    groupValue:_currentIndex,
                    title: Text('Indonesia'),
                    value: text,
                    onChanged: (val) {
                      // print(val);
                      setState(() { 
                        _currentIndex = val;
                      });
                    },
                  ))
              .toList(),
        ),
      ),   
    );
  }
   
 

 
} 


