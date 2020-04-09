import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:kudabin/Utils/side_drawer.dart';

import 'ScopedModels/main_model.dart';

class CollectionPoints extends StatefulWidget {
  final MainModel model;

  CollectionPoints(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CollectionPointsState();
  }
}

class _CollectionPointsState extends State<CollectionPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Collection Centers', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: null,
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: null,
            color: Colors.white,
          )
        ],
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: CollectionCenterMap(),
      drawer: SideDrawer(widget.model),
    );
  }
}

class CollectionCenterMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionCenterMapState();
  }
}

class _CollectionCenterMapState extends State<CollectionCenterMap> {
  List<Marker> allMarkers = [];
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
        markerId: MarkerId('Patna'),
        draggable: false,
        position: LatLng(25.5941, 85.1376)));
    allMarkers.add(Marker(
        markerId: MarkerId('Delhi'),
        draggable: false,
        position: LatLng(28.7041, 77.1025)));
    allMarkers.add(Marker(
        markerId: MarkerId('Lucknow'),
        draggable: false,
        position: LatLng(26.8467, 80.9462)));
    allMarkers.add(Marker(
        markerId: MarkerId('Darbhanga'),
        draggable: false,
        position: LatLng(26.1542, 85.8918)));
    allMarkers.add(Marker(
        markerId: MarkerId('Kanpur'),
        draggable: false,
        position: LatLng(26.4499, 80.3319)));
    allMarkers.add(Marker(
        markerId: MarkerId('Ahemdabad'),
        draggable: false,
        position: LatLng(23.0225, 72.5714)));
    allMarkers.add(Marker(
        markerId: MarkerId('Rachi'),
        draggable: false,
        position: LatLng(23.3441, 85.3096)));
    allMarkers.add(Marker(
        markerId: MarkerId('Indore'),
        draggable: false,
        position: LatLng(22.7196, 75.8577)));
    allMarkers.add(Marker(
        markerId: MarkerId('Gaya'),
        draggable: false,
        position: LatLng(24.7914, 85.0002)));
  }

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.7914, 85.0002),
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.from(allMarkers),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getToCurrentLocation,
        child: Icon(Icons.location_searching),
      ),
    );
  }

  Future<void> _getToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      allMarkers.add(
        Marker(
          markerId: MarkerId('current location'),
          draggable: false,
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(25),
        ),
      );
      print(allMarkers);
    });
    final CameraPosition _currentLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(position.latitude, position.longitude),
        zoom: 19.151926040649414);
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentLocation));
  }
}
