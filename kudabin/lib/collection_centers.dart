import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:kudabin/Utils/side_drawer.dart';

class CollectionPoints extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionPointsState();
  }
}

class _CollectionPointsState extends State<CollectionPoints> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    CollectionCenterMap(),
    CollectionCenterList()
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
        title: Text('Collection Centers'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
       drawer: SideDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('List'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CollectionCenterList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionCenterListState();
  }
}

class _CollectionCenterListState extends State<CollectionCenterList> {
  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C'];

    return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 40,
            child: Text('Entry ${entries[index]}'),
          );
        });
  }
}

class CollectionCenterMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionCenterMapState();
  }
}

class _CollectionCenterMapState extends State<CollectionCenterMap> {
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
