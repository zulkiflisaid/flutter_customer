import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PulsaPage extends StatefulWidget {
  PulsaPage({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP;
  @override
  _PulsaPageState createState() => _PulsaPageState();
}

class _PulsaPageState extends State<PulsaPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('BuildContext');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text(
          'Beli Pulsa',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 30,
            height: MediaQuery.of(context).size.height * (1 / 3),
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-3.478810, 119.144617),
                zoom: 15.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
