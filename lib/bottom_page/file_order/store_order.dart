import 'package:cloud_firestore/cloud_firestore.dart'; 
//flutter_inbox/inbox_customer
class StoreOrder {
  final DateTime _now = DateTime.now();
  

  Future<List<DocumentSnapshot>> fetchFirstList( ) async {
   var lastDayOfMonth =   DateTime(_now.year, _now.month , _now.day-1 );
    return (await Firestore.instance
            .collection('flutter_order')  
            .where('created', isGreaterThan: lastDayOfMonth)
            .orderBy('created')
            .limit(10) 
            .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchNextList( 
      List<DocumentSnapshot> documentList) async {
         var lastDayOfMonth =   DateTime(_now.year, _now.month , _now.day-1 );
    return (await Firestore.instance
            .collection('flutter_order') 
            .where('created', isGreaterThan:  lastDayOfMonth)//isLessThan  isGreaterThan
            .orderBy('created')
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .getDocuments())
        .documents;
  }
}