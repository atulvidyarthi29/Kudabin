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

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
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
          icon: BitmapDescriptor.defaultMarker,
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
