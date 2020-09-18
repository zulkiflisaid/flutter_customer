import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelanggan/bottom_page/file_inbox/FirebaseProvider.dart';
import 'package:rxdart/rxdart.dart';

class MovieListBloc {
 

  MovieListBloc() {
    movieController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    firebaseProvider = FirebaseProvider();
  }
  FirebaseProvider firebaseProvider; 
  bool showIndicator = false;
  List<DocumentSnapshot> documentList; 
  BehaviorSubject<List<DocumentSnapshot>> movieController; 
  BehaviorSubject<bool> showIndicatorController;
  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get movieStream => movieController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList() async {
    try {
      documentList = await firebaseProvider.fetchFirstList();
      print(documentList);
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
  void fetchNextMovies() async {
    try {
      updateIndicator(true);
      var newDocumentList =
          await firebaseProvider.fetchNextList(documentList);
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