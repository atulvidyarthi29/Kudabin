import 'dart:async';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/side_drawer.dart';


class PostComplaint extends StatefulWidget {
  final MainModel model;

  PostComplaint(this.model);

  @override
  State<StatefulWidget> createState() {
    return _PostComplaintState();
  }
}

class _PostComplaintState extends State<PostComplaint> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LocationResult _pickedLocation;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> allMarkers = [];
  File _takenImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details', style: TextStyle(color: Colors.white)),
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
      body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Title",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (String value) {
                    if (value.isEmpty || value.length < 4) {
                      return "Title is required and should be 4+ characters";
                    }
                    return "";
                  },
                  onSaved: (String value) {},
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 4,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Description is required";
                    }
                    return '';
                  },
                  onSaved: (String value) {},
                ),
                RaisedButton(
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
                      allMarkers.add(Marker(
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
                        'Pick location',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                (_pickedLocation != null)
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
                          markers: Set.from(allMarkers),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      )
                    : Container(),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                      Text(
                        ' Add a photo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.camera,
                                        size: 50,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      onPressed: () {
                                        ImagePicker.pickImage(
                                                source: ImageSource.gallery)
                                            .then((File image) {
                                          Navigator.pop(context);
                                          setState(() {
                                            _takenImage = image;
                                          });
                                        });
                                      },
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Gallery",
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: 50,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {
                                          ImagePicker.pickImage(
                                                  source: ImageSource.camera)
                                              .then((File image) {
                                            Navigator.pop(context);
                                            setState(() {
                                              _takenImage = image;
                                            });
                                          });
                                        }),
                                    SizedBox(height: 4),
                                    Text(
                                      "Camera",
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
                SizedBox(height: 10),
                (_takenImage == null)
                    ? Container()
                    : Image.file(
                        _takenImage,
                        fit: BoxFit.cover,
                        height: 300,
                        alignment: Alignment.topCenter,
                      ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      Text(
                        ' Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    _formKey.currentState.validate();
                    _formKey.currentState.save();
                  },
                ),
              ],
            ),
          )),
      drawer: SideDrawer(widget.model),
    );
  }
}
