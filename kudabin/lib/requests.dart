import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudabin/Utils/side_drawer.dart';

class Requests extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RequestsState();
  }
}

class _RequestsState extends State<Requests> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    TrackMap(),
    ListView(
        children: <Widget>[Text("data"), Text("data")],
      )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Orders', style: TextStyle(color: Colors.white)),
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
      body: _widgetOptions.elementAt(_selectedIndex),
      drawer: SideDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_circle),
            title: Text('Track'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Past Orders'),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
      ),
    );
  }
}

class TrackMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrackMapState();
  }
}

class _TrackMapState extends State<TrackMap> {
  Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
