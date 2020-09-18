import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'bottomsheet_widget.dart';
/*
class ContohButtonState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: HomeView());
  }
}*/

class HomeView extends StatelessWidget {
  //final GlobalKey<ScaffoldState> dddd = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    print("object");
    return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: GoogleMap(
              // padding: MediaQuery.of(context).viewInsets,
              //markers: _markers,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: false,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              zoomGesturesEnabled: true,
              trafficEnabled: true,
              //  showUserLocation: true,
              // mapViewType: MapViewType.normal,
              //trackCameraPosition: true,
              mapType: MapType.normal,
              //markers: Set.of((marker != null) ? [marker] : []),
              //circles: Set.of((circle != null) ? [circle] : []),
              initialCameraPosition: CameraPosition(
                target: LatLng(-3.47764787218, 119.141805461),
                zoom: 16.0,
                bearing: 20, //berputar
              ),
              //markers: _markers.values.toSet(),
              onCameraMoveStarted: () {
                print("mapController");
              },
              onCameraMove: (CameraPosition cameraPosition) {
                print("mapController");
              },
              buildingsEnabled: false,
              onCameraIdle: () {
                print("mapController");
              },
              onMapCreated: (GoogleMapController controller) {
                print("mapController");
              },
            ),
          ),
          floatingActionButton: MyFloatingButton(),
        ));
    /*return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: GoogleMap(
          // padding: MediaQuery.of(context).viewInsets,
          //markers: _markers,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          zoomGesturesEnabled: true,
          trafficEnabled: true,
          //  showUserLocation: true,
          // mapViewType: MapViewType.normal,
          //trackCameraPosition: true,
          mapType: MapType.normal,
          //markers: Set.of((marker != null) ? [marker] : []),
          //circles: Set.of((circle != null) ? [circle] : []),
          initialCameraPosition: CameraPosition(
            target: LatLng(-3.47764787218, 119.141805461),
            zoom: 16.0,
            bearing: 20, //berputar
          ),
          //markers: _markers.values.toSet(),
          onCameraMoveStarted: () {
            print("mapController");
          },
          onCameraMove: (CameraPosition cameraPosition) {
            print("mapController");
          },
          buildingsEnabled: false,
          onCameraIdle: () {
            print("mapController");
          },
          onMapCreated: (GoogleMapController controller) {
            print("mapController");
          },
        ),
      ),
      floatingActionButton: MyFloatingButton(),
    );*/
  }
}

class MyFloatingButton extends StatefulWidget {
  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  bool _show = true;
  @override
  Widget build(BuildContext context) {
    print("WillPopScope");
    return _show
        ? FloatingActionButton(
         
            onPressed: () {
              var sheetController = showBottomSheet(
                  context: context, builder: (context) => BottomSheetWidget()); 
              _showButton(false); 
              sheetController.closed.then((value) {
                _showButton(true);
              });
            },
          )
        : Center(
            child: Container(
              height: 333,
              child: Text("ghghghg"),
            ),
          );
  }

  void _showButton(bool value) {
    setState(() {
      _show = value;
    });
  }
}
