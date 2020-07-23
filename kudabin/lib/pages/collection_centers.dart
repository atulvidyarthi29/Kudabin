import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/custom_appbar.dart';
import 'package:kudabin/Utils/side_drawer.dart';
import 'package:kudabin/pages/splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';

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
      appBar: CustomAppBar("Collection Centers"),
      body: CollectionCenterMap(widget.model),
      drawer: SideDrawer(),
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
  List<Marker> _allMarkers = [];
  LocationResult _pickedLocation;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> newMarkers = [];
  final GlobalKey<FormState> _addPointKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {
    "address": null,
  };

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.7914, 83.0002),
    zoom: 4.10,
  );

  @override
  void initState() {
    super.initState();
    widget.model.collectionCenters.forEach((Map<String, dynamic> cPoint) {
      _allMarkers.add(Marker(
          markerId: MarkerId(cPoint["_id"]),
          draggable: false,
          infoWindow: InfoWindow(
              title: cPoint["description"],
              snippet: "(" +
                  cPoint["latitude"].toString() +
                  ", " +
                  cPoint["longitude"].toString() +
                  ")"),
          onTap: () {
            showBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                        title: Text(
                          cPoint["description"] +
                              " " +
                              "(" +
                              cPoint["latitude"].toString() +
                              ", " +
                              cPoint["longitude"].toString() +
                              ")",
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                        trailing: widget.model.loggedInUser.userType == 'admin'
                            ? IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  Map<String, dynamic> successInfo =
                                      await widget.model.removeCenter(
                                          widget.model.token, cPoint["_id"]);
                                  if (successInfo["success"]) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FutureBuilder(
                                                future: widget.model
                                                    .fetchCenter(
                                                        widget.model.token),
                                                builder: (context,
                                                    authResultSnapShot) {
                                                  return authResultSnapShot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting
                                                      ? SplashScreen()
                                                      : CollectionPoints(
                                                          widget.model);
                                                })));
                                  } else {
                                    print("Something went wrong");
                                  }
                                })
                            : IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent,
                      ));
                });
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(150),
          position: LatLng(cPoint["latitude"], cPoint["longitude"])));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      return Scaffold(
        body: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set.from(_allMarkers),
        ),
        floatingActionButton: (model.loggedInUser.userType == 'admin')
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: _addPoint,
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
              )
            : FloatingActionButton(
                heroTag: null,
                onPressed: _getToCurrentLocation,
                child: Icon(Icons.location_searching),
              ),
      );
    });
  }

  Widget _addressField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Address of the Collection Center",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            maxLines: 4,
            validator: (String value) {
              if (value.isEmpty) {
                return "Address is required";
              }
              return null;
            },
            onChanged: (String value) {
              formData["address"] = value;
            },
            onSaved: (String value) {
              formData["address"] = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _locationPreview() {
    return (_pickedLocation != null)
        ? Container(
            height: 300,
            decoration: BoxDecoration(
                border: Border.all(
              width: 2,
              color: Theme.of(context).accentColor,
            )),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _pickedLocation.latLng,
                zoom: 14.4746,
              ),
              markers: Set.from(newMarkers),
            ),
          )
        : Container(
            child: Text(
              "Location is required.",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          );
  }

  Widget _locationButton() {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      onPressed: () async {
        LocationResult result = await showLocationPicker(
          context,
          'AIzaSyCb4Hq0N7PkpdBhX-MKq4Hl16eC4x-7qfE',
          initialCenter: LatLng(31.1975844, 29.9598339),
          myLocationButtonEnabled: true,
          layersButtonEnabled: true,
        );
        setState(() {
          _pickedLocation = result;
          _addPointKey.currentState.save();
          newMarkers.add(Marker(
            markerId: MarkerId("newId"),
            draggable: false,
            position: _pickedLocation.latLng,
            onTap: null,
          ));
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.location_on,
            color: Colors.white,
          ),
          Text(
            (_pickedLocation == null) ? 'Locate on Map' : 'Change Location',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _addLocationButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      return model.managingCenter
          ? CircularProgressIndicator()
          : InkWell(
              onTap: () async {
                if (!_addPointKey.currentState.validate() ||
                    _pickedLocation == null) {
                  return;
                }
                Map<String, dynamic> successInfo = await model.addCenter(
                    model.token,
                    formData["address"],
                    _pickedLocation.latLng.latitude,
                    _pickedLocation.latLng.longitude);
                if (successInfo["success"]) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FutureBuilder(
                              future: model.fetchCenter(model.token),
                              builder: (context, authResultSnapShot) {
                                return authResultSnapShot.connectionState ==
                                        ConnectionState.waiting
                                    ? SplashScreen()
                                    : CollectionPoints(model);
                              })));
                } else {
                  print("Something went wrong");
                }
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xfffbb448), Color(0xfff7892b)]),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text('Add the Location',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            );
    });
  }

  void _addPoint() {
    showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _addPointKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _addressField(),
                    _locationPreview(),
                    _locationButton(),
                    _addLocationButton()
                  ],
                ),
              ),
            ),
          );
        });
  }

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
}
