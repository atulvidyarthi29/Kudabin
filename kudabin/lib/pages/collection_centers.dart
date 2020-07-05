import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudabin/ScopedModels/main_model.dart';

import 'package:kudabin/Utils/side_drawer.dart';


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
      body: CollectionCenterMap(widget.model),
      drawer: SideDrawer(widget.model),
    );
  }
}

class CollectionCenterMap extends StatefulWidget {
  final MainModel model;

  CollectionCenterMap(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CollectionCenterMapState();
  }
}

class _CollectionCenterMapState extends State<CollectionCenterMap> {
  List<Marker> allMarkers = [];
  LocationResult _pickedLocation;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    widget.model.fetchCenter();
    widget.model.collectionCenters.forEach((center) {
      allMarkers.add(Marker(
          markerId: MarkerId(center.id.toString()),
          draggable: false,
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(center.description),
                    ),
                  );
                });
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(150),
          position: LatLng(center.latitude, center.longitude)));
    });
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
      floatingActionButton: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: _pickLocation,
            child: Icon(Icons.add_location),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: _getToCurrentLocation,
            child: Icon(Icons.location_searching),
          ),
        ],
      ),
    );
  }

  Future<void> _pickLocation() async {
    LocationResult result = await showLocationPicker(
      context,
      'AIzaSyCb4Hq0N7PkpdBhX-MKq4Hl16eC4x-7qfE',
      initialCenter: LatLng(31.1975844, 29.9598339),
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
    );
    setState(() {
      _pickedLocation = result;
      allMarkers.add(Marker(
        markerId: MarkerId("newId"),
        draggable: false,
        position: _pickedLocation.latLng,
        onTap: null,
      ));
    });
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
