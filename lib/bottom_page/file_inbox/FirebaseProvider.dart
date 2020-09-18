import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core'; 
//flutter_inbox/inbox_customer
class FirebaseProvider {
  final DateTime _now = DateTime.now();
  

  Future<List<DocumentSnapshot>> fetchFirstList() async {
   var lastDayOfMonth =   DateTime(_now.year, _now.month , _now.day-1 );
    return (await Firestore.instance
            .collection('flutter_inbox')
            .document('inbox_customer')
            .collection('inbox')  
              .where('time', isGreaterThan: lastDayOfMonth)
            .orderBy('time')
            .limit(10) 
            .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchNextList(
      List<DocumentSnapshot> documentList) async {
         var lastDayOfMonth =   DateTime(_now.year, _now.month , _now.day-1 );
    return (await Firestore.instance
            .collection('flutter_inbox')
            .document('inbox_customer')
            .collection('inbox')
                .where('time', isGreaterThan:  lastDayOfMonth)//isLessThan  isGreaterThan
            .orderBy('time')
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .getDocuments())
        .documents;
  }
}