import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelanggan/api/api.dart';
import 'package:pelanggan/model/class_model.dart';

//flutter_inbox/inbox_customer
class StoreFoodDepan {
  //final DateTime _now = DateTime.now();
  Future<List<Promosi>> fetchFirstList(
    GeoPoint lesserGeopoint,
    GeoPoint greaterGeopoint,
  ) async {
    var response = await CallApi().getData('selet_restoran.php');
    // print(response.body);
    if (response.statusCode == 200) {
      // print(response.body);
      Iterable list = json.decode(response.body);
      var promos = list.map((season) => Promosi.fromJson(season)).toList();
      return promos;
    }
  }

  Future<List<Promosi>> fetchNextList(GeoPoint lesserGeopoint,
      GeoPoint greaterGeopoint, List<Promosi> documentList) async {
    var response = await CallApi().getData('selet_restoran.php');
    // print(response.body);
    if (response.statusCode == 200) {
      // print(response.body);
      Iterable list = json.decode(response.body);
      var promos = list.map((season) => Promosi.fromJson(season)).toList();
      return promos;
    }
  }
}
