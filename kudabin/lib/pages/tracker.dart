import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/custom_appbar.dart';
import 'package:kudabin/Utils/side_drawer.dart';

class TrackMap extends StatefulWidget {
  final Map<String, dynamic> data;
  final MainModel model;

  TrackMap(this.data, this.model);

  @override
  _TrackMapState createState() => _TrackMapState();
}

class _TrackMapState extends State<TrackMap> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  List<Marker> _allMarkers = [];

  final firebaseDB = FirebaseDatabase.instance.reference();
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    print("###############33");
    print(widget.data);
    _allMarkers.add(Marker(
        markerId: MarkerId("Destination"),
        draggable: false,
        position: LatLng(widget.data["latitude"], widget.data["longitude"])));

    firebaseDB
        .child(widget.data["assignedAgent"])
        .once()
        .then((DataSnapshot data) {
      setState(() {
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        print(data);
        _allMarkers.add(Marker(
            markerId: MarkerId("agent"),
            draggable: false,
            position: LatLng(data.value["latitude"], data.value["longitude"])));
        _getPolyline();
      });
    });
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCb4Hq0N7PkpdBhX-MKq4Hl16eC4x-7qfE',
        PointLatLng(_allMarkers[0].position.latitude,
            _allMarkers[0].position.longitude),
        PointLatLng(_allMarkers[1].position.latitude,
            _allMarkers[1].position.longitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: CustomAppBar("Requests"),
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.grey[300])),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.data["latitude"], widget.data["longitude"]),
            zoom: 9,
          ),
          markers: Set.from(_allMarkers),
          polylines: Set<Polyline>.of(polylines.values),
        ),
      ),
      drawer: SideDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _trackCurrentLocation,
        child: Icon(Icons.location_searching),
      ),
    );
  }

  Future<void> _trackCurrentLocation() async {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      if (position != null) {
        firebaseDB.child(widget.data["assignedAgent"]).update(
            {"latitude": position.latitude, "longitude": position.longitude});
      }
    });
  }

  Future<void> _trackCollectionAgent() async {
    firebaseDB
        .child(widget.data["assignedAgent"])
        .onChildChanged
        .listen((event) {
      var key = event.snapshot.key;
      var value = event.snapshot.value;

      print(key);
      print(value);

      Marker _marker = Marker(
          markerId: MarkerId("agent"),
          draggable: false,
          position: (key == "latitude")
              ? LatLng(value, _allMarkers[1].position.longitude)
              : LatLng(_allMarkers[1].position.latitude, value));
      setState(() {
        _allMarkers[1] = _marker;
        print(_allMarkers);
      });
    });
  }
}
