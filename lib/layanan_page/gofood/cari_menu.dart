
import 'package:sqflite/sqflite.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pelanggan/api/dbhelper.dart'; 
 
import 'package:pelanggan/model/history_cari.dart';

import '../../constans.dart';

class CariMenu extends StatefulWidget {
  CariMenu({Key key, this.dataP }) : super(key: key);
  final Map<String, dynamic> dataP; 
  
  @override
  _CariMenuState createState() => _CariMenuState();
}

class _CariMenuState extends State<CariMenu> {
  // CrudMedthods crudObj =   CrudMedthods();
 // Future<List<Map<dynamic, dynamic>>> documentList  ; 
 var uang =   NumberFormat.currency(locale: 'ID', symbol: '',decimalDigits:0); 
  final cariController = TextEditingController(); 
 var items1 = List<String>();
  List<Map<dynamic, dynamic>> items = new List();
 var focusNode = new FocusNode();
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<HistoryCari> historyList =List();  
   
    // String selectedChoice = "";
  List<String> selectedChoices = List();
   
   

  
 @override
  void initState(){ 
     updateListView();
    super.initState();  
   
        
  } 
  Future<void> filterSearchResults(String query) async { 
      // items=list;
    if(query=='') { 
       setState(() {
         items.clear(); 
      });
    } else {
     // dynamic isLessThan,
      // dynamic isLessThanOrEqualTo,
      // dynamic isGreaterThan,
      // dynamic isGreaterThanOrEqualTo,

      List<DocumentSnapshot> templist; 
      List<Map<dynamic, dynamic>> lists = new List();
      CollectionReference collectionRef = 
      Firestore.instance.collection("flutter_food")  ;  
     
      //cari 1
      QuerySnapshot collectionSnapshot = await collectionRef
        .where("nm_menu", isGreaterThanOrEqualTo: query) 
      .limit(1) 
      .getDocuments(); 
      templist = collectionSnapshot.documents;   
      lists = templist.map((DocumentSnapshot docSnapshot){  
        final Map<String, dynamic> someMap =  docSnapshot.data;
            someMap['id_menu']= docSnapshot.documentID;
            return someMap;
      }).toList(); 

 
      //cari 2
       collectionSnapshot = await collectionRef 
       .where("nm_menu", isLessThanOrEqualTo: query)
      .limit(1) 
      .getDocuments(); 
      templist = collectionSnapshot.documents;   
      lists .addAll(  templist.map((DocumentSnapshot docSnapshot){ 
          final Map<String, dynamic> someMap =  docSnapshot.data;
            someMap['id_menu']= docSnapshot.documentID;
            return someMap;
      }).toList()); 

      setState(() { 
          items = lists; 
      });

      if(items.length>=1){
         bool cekAda=true ;
         historyList.forEach((element) {
           if( element.name==query) {
              cekAda=false;
           }  
         });
         print('cekAda');
         if(cekAda){
           DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
          await dbHelper.insert(HistoryCari(query, formattedDate )); 
          deleteUp10() ;
         }
         
      }
     
    }
 
  }
   
  void deleteUp10() {
    final Future<Database> dbFuture = dbHelper.initDb(); 
     int banyaknya=0;
     dbFuture.then((database) {
      Future<List<HistoryCari>> contactListFuture = dbHelper.getContactList();
      contactListFuture.then((contactList) { 
         banyaknya=0;
         contactList.forEach((element) {
            banyaknya++;
            if(banyaknya>7){
                   dbHelper.delete(element.id);
            } 
         }); 
      });
    }); 

  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb(); 
     
     dbFuture.then((database) {
      Future<List<HistoryCari>> contactListFuture = dbHelper.getContactList();
      contactListFuture.then((contactList) { 
         
        setState(() {
          this.historyList = contactList;
          this.count = contactList.length;
        });
            
      });
    }); 

  }
   
  _buildChoiceList() {
    List<Widget> choices = List();
    //final Future<Database> dbFuture = dbHelper.initDb(); 
      historyList.forEach((element) {
            choices.add(Container( color: Colors.white,
               // margin: const EdgeInsets.all(2.0),
                 padding: const EdgeInsets.all(2.0),
                child: ChoiceChip( 
                  padding: EdgeInsets.all(0.0),
                  backgroundColor: Colors.white,
                   shape: RoundedRectangleBorder( 
                          borderRadius:   BorderRadius.circular(16.0),
                          side: BorderSide(color: Colors.green,width: 0.5), 
                   ),
                  label: Text(element.name),
                  selected: selectedChoices.contains(element.name),
                  onSelected: (selected) { 
                     // FocusScope.of(context).requestFocus(focusNode);
                      //or 
                      focusNode.requestFocus(); 
                       cariController.text=element.name; 
                       cariController.selection = TextSelection.fromPosition(TextPosition(offset: cariController.text.length));
                  },
                ),
              ));

        }); 
    return choices;
  }
  
  @override
  Widget build(BuildContext context) {
    
    Widget titleCari =Card(
                elevation:5,
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Padding(
                    padding: EdgeInsets.only(right: 16,left: 16,top: 40,
                    bottom: 16
                        ),
                    child: Container(   
                    height: 48,
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
                        child:   IconButton(
                              icon:   Icon(Icons.arrow_back),
                              onPressed: () =>
                               Navigator.of(context).pop(null),
                            ), 
                      ), 
                      Expanded( 
                        child: TextField(
                           maxLines: 1, 
                           controller: cariController,
                           focusNode: focusNode,
                           onSubmitted: (value) {  
                          
                                filterSearchResults(value);
              
                          },
                       
                          autofocus: true,
                          style: TextStyle( 
                                 // fontFamily: 'NeoSans',
                                 // fontSize: 14,
                                 // fontWeight: FontWeight.normal,
                                 // letterSpacing: 0,
                               // decorationStyle: TextDecorationStyle.solid
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
                )
     ); 
     
    Widget tagList = Container(
      color: Colors.white,
      height: 40.0,margin: EdgeInsets.all(10.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            children: <Widget>[ 
              ActionChip(
                  backgroundColor: Colors.yellow,
                  label: Text('Tag1'),
                  onPressed: () {
                    // update board with selection
                  }), 
            ],
          )
        ],
      ), 
    );

    Widget boardView = Container(
      color: Colors.white,
      child: ListView.separated( 
        separatorBuilder: (BuildContext context, int index) { 
              return Divider(height: 1,indent: 120.1,); 
        }, 
        itemCount:  items.length, //ds.data.length,
        padding: EdgeInsets.only(top: 0.0),
        shrinkWrap: true, 
        //physics: const NeverScrollableScrollPhysics(),
        // physics:   ClampingScrollPhysics(),
        //scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {   
           
           return _rowDefault(items[index]); 
        } 
      ) 
    );
 
    return Scaffold(
       // appBar: AppBar(
        //  elevation: 1.0,
        //  title: Text('Test title'),
       // ),
      body: Container(
        
          color: Colors.white,
          child:   Column(  
            crossAxisAlignment:CrossAxisAlignment .start ,
            children: <Widget>[ 
              titleCari, 
              //tagList,
              Text('  Riwayat pencarian'),
              Container(
                margin: const EdgeInsets.only(left: 4,right: 4),
                // padding: const EdgeInsets.all(1.0),
                child:   Wrap( 
                    children: _buildChoiceList(),
                  ),   
               ),  
               Divider(  color: Colors.grey,  height:1, ),
              Expanded( 
                child: boardView,
              )
            ],
          ),
         
        )
      );
  }

  Widget _rowDefault(Map<dynamic, dynamic> food) { 
 
    return   Card(   
        child:InkWell(    
        borderRadius:   BorderRadius.circular(8.0),  
        onTap:() async {
           Navigator.pop(context, food);
           // Navigator.pop(context);
          //  Navigator.push(   context,  MaterialPageRoute(builder: (context) => Restoran(dataP: widget.dataP, dataResto: dataResto,)),  );
        }, 
        child: Padding( 
          padding: const EdgeInsets.only(left: 4,right:4, top: 6,bottom: 10 ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child:CachedNetworkImage(
                      imageUrl:food['img'],
                      fit: BoxFit.cover,
                      height: 80,
                      // height: 172.0,
                      width: 100,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                  ) 
                // Image.network(food.img,width: 100,height: 80,fit: BoxFit.cover,),
              ),
              Expanded(
                //width: 250,
                child: Padding(
                  padding: const EdgeInsets.all(  5.0),
                  child:      Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(food['nm_menu'] ,   
                           style: TextStyle( 
                            fontWeight: FontWeight.bold, letterSpacing: 0,
                            color: Colors.black, fontFamily: 'NeoSans', 
                              fontSize: 13,
                            )
                        ),   
                      Text( food['ket_menu'], style: TextStyle( 
                             letterSpacing: 0,  color: Colors.black, fontFamily: 'NeoSans', 
                              fontSize: 13,
                            ) ),  
                      Text('Rp${uang.format(food['hrg'])}', style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 0,
                              color:   Colors.orange[800], fontFamily: 'NeoSans',fontSize: 12, 
                              decoration: TextDecoration.none,  
                              )
                       ),
                        
                      
                    ],
                  ),
                ),
              )  
            ],
          ),  
        ), 
        ),  
      );

    }
    
}
  


 