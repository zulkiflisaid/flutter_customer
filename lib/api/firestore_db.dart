import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMedthods {
   //umum
   getTarif(String by) async { 
    return  (await Firestore.instance
        .collection("flutter_tarif") 
        .where("category_driver", isEqualTo: by) 
        .limit(1)
        .getDocuments())
        .documents;
  } 
   
   //food
  getFoodPesanan(String uid) async {
    return   Firestore.instance.collection('flutter_keranjang') 
                         .document( uid )
                         .collection('food')
                         //.where('id_resto',isEqualTo: widget.dataResto['id_resto']) 
                          .orderBy('nm_menu'  )
                           .limit(300)
                       .snapshots();
  }

  getMenu(String idResto) async {
    return      Firestore.instance.collection('flutter_food')   
              .where('id_resto',isEqualTo:idResto) 
              .orderBy('kategori'  )
              .limit(300)
              .getDocuments();
  }

  //get resto by id
  Future<dynamic> getRestoById(String idResto) async { 
       return Firestore.instance.collection('flutter_resto').document(idResto); 
  }

  Future <List<Map<dynamic, dynamic>>> searchMenuByName(String query) async{
      List<DocumentSnapshot> templist;
      List<Map<dynamic, dynamic>> list = new List();
      CollectionReference collectionRef = 
      Firestore.instance.collection("flutter_food")  
      .where("nm_menu", isGreaterThanOrEqualTo: "nm_menu")
        .limit(2);
      QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

      templist = collectionSnapshot.documents; // <--- ERROR

      list = templist.map((DocumentSnapshot docSnapshot){ 
        return docSnapshot.data;
      }).toList();

      return list;
  }  
  
 
  
  //ojek

  //pulsa

  //pln

  //sembako

}
 