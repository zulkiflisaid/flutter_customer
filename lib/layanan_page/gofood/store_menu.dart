import 'package:cloud_firestore/cloud_firestore.dart';
 
 
//flutter_inbox/inbox_customer
class StoreMenu {
  //final DateTime _now = DateTime.now();
  
 
  Future<List<DocumentSnapshot>> fetchFirstList(String idResto) async {
      print('idResto $idResto}');
    
    return (await Firestore.instance
            .collection('flutter_food')
            .where('id_resto',isEqualTo:   idResto)
            //.where('posisi',isLessThan: greaterGeopoint) 
           // .where('ket_resto', isLessThanOrEqualTo:  'ayam')
            //.where('time', isGreaterThan: lastDayOfMonth)
           // .orderBy('hrg'  )
            .limit(10) 
            .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchNextList(  String idResto, 
     List<DocumentSnapshot> documentList) async { 
   
    return   (await Firestore.instance
            .collection('flutter_food')
             .where('id_resto',isEqualTo: idResto)
            // .where('posisi',isLessThan: greaterGeopoint) 
             //.where('ket_resto', isLessThan:  'ayam')
            //.where('time', isGreaterThan:  lastDayOfMonth)//isLessThan  isGreaterThan
             .orderBy('hrg'  )
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .getDocuments())
        .documents ;
   
  }
}