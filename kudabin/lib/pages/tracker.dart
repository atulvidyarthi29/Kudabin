import 'dart:async';

import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudabin/Utils/custom_appbar.dart';
import 'package:kudabin/Utils/side_drawer.dart';

class TrackMap extends StatefulWidget {
  @override
  _TrackMapState createState() => _TrackMapState();
}

class _TrackMapState extends State<TrackMap> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _allMarkers = [];

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<void> _getToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _allMarkers.add(
        Marker(
          markerId: MarkerId('current location'),
          draggable: false,
          position: LatLng(position.latitude, position.longitude),
        ),
      );
      print(_allMarkers);
    });
    final CameraPosition _currentLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(position.latitude, position.longitude),
        zoom: 9);
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentLocation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: CustomAppBar("Requests"),
        body: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.grey[300])),
          child: GoogleMap(
            initialCameraPosition: _kGooglePlex,
            markers: Set.from(_allMarkers),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        drawer: SideDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: _getToCurrentLocation,
          child: Icon(Icons.location_searching),
        ));
  }
}
