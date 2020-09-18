import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelanggan/layanan_page/gofood/StoreRestoDepan.dart';
import 'package:pelanggan/model/class_model.dart';
import 'package:rxdart/rxdart.dart';

class ListResDepan {
  ListResDepan() {
    movieController = BehaviorSubject<List<Promosi>>();
    showIndicatorController = BehaviorSubject<bool>();
    firebaseProvider = StoreFoodDepan();
  }
  StoreFoodDepan firebaseProvider;
  bool showIndicator = false;
  List<Promosi> documentList;
  BehaviorSubject<List<Promosi>> movieController;
  BehaviorSubject<bool> showIndicatorController;
  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<Promosi>> get restoStream => movieController.stream;

  double calculateDistance(GeoPoint geoNya, double lat, double long) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((geoNya.latitude - lat) * p) / 2 +
        c(lat * p) *
            c(geoNya.latitude * p) *
            (1 - c((geoNya.longitude - long) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList(GeoPoint lesserGeopoint, GeoPoint greaterGeopoint,
      double lat, double long) async {
    try {
      documentList = await firebaseProvider.fetchFirstList(
        lesserGeopoint,
        greaterGeopoint,
      );
      /* documentList.sort((a, b) {
        return calculateDistance(a['posisi'], lat, long)
            .compareTo(calculateDistance(b['posisi'], lat, long));
      });*/
      movieController.sink.add(documentList);
      try {
        if (documentList.isEmpty) {
          movieController.sink.addError('No Data Available');
        }
      } catch (e) {
        print(e.toString());
      }
    } on SocketException {
      movieController.sink.addError(SocketException('No Internet Connection'));
    } catch (e) {
      print(e.toString());
      movieController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  void fetchNextMovies(GeoPoint lesserGeopoint, GeoPoint greaterGeopoint,
      double lat, double long) async {
    try {
      updateIndicator(true);
      var newDocumentList = await firebaseProvider.fetchNextList(
          lesserGeopoint, greaterGeopoint, documentList);
      /*  newDocumentList.sort((a, b) {
        return calculateDistance(a['posisi'], lat, long)
            .compareTo(calculateDistance(b['posisi'], lat, long));
      });*/
      documentList.addAll(newDocumentList);

      movieController.sink.add(documentList);
      try {
        if (documentList.isEmpty) {
          movieController.sink.addError('No Data Available');
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      movieController.sink.addError(SocketException('No Internet Connection'));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      movieController.sink.addError(e);
    }
  }

/*For updating the indicator below every list and paginate*/
  void updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    movieController.close();
    showIndicatorController.close();
  }
}
