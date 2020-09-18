import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  // Orders() : super(); 
  //Orders({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor
 // final String title;
  //final String uid; //include this
 

  Orders({Key key, this.dataP}) : super(key: key);
   final Map<String, dynamic> dataP;
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final DateTime _now = DateTime.now();
   var lastDayOfMonth  ;
  @override
  void initState() {
    
    super.initState();
      lastDayOfMonth =   DateTime(_now.year, _now.month , _now.day-1 );
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness : Brightness.light,
        title: Text('Pesanan',style: TextStyle(color: Colors.black ),), 
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history,color: Colors.black),
            onPressed: () {
              
            },
          ), 
        ], 
      ),
      body: Container(
      // padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('flutter_order') 
                    .where('pelanggan_uid', isEqualTo: widget.dataP['uid'])
                  //.document(widget.data_p['uid'])
                 //.collection('order')
                  .where('created', isGreaterThan: lastDayOfMonth)
                  .snapshots(),
              builder: (BuildContext context,  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return   Text('Error: ${snapshot.error}');
                } else if (snapshot.data != null) { 
                  switch (snapshot.connectionState) {
                  case ConnectionState.waiting:  return   Text('Loading...');
                  default:
                    return ListView(
                      children: snapshot.data.documents  .map((DocumentSnapshot document) {
                        return Card(
                          child: Container(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(document['category_driver']),
                                  FlatButton(
                                      child: Text('See More'),
                                      onPressed: () {   
                                        
                                      }),
                                ],
                              )
                            )
                          );
                       // return   CustomCard(
                          //title: document['jenis_order'],
                          //description: document['description'],
                       // );
                      }).toList(),
                    );
                  } 
                } else {
                  return Center(
                      child: CircularProgressIndicator() 
                    );  
                }
                
              },
            )
        /* child: ListView.builder(
          itemCount: OrderModel.dummyData.length,
          itemBuilder: (context, index) {
            OrderModel _model = OrderModel.dummyData[index];
            return Column(
              children: <Widget>[
                Divider(
                  height: 12.0,
                ),
                ListTile(
                  //leading:Icon(  Icons.bookmark_border,  size: 32.0,  ),
                  title: Row(
                    children: <Widget>[
                      Text(_model.name),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        _model.datetime,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                  subtitle: Text(_model.message),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14.0,
                  ),
                ),
              ],
            );
          },
        ),*/
      ), 
    );
  }
}

 