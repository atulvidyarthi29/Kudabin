import 'dart:async';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/custom_appbar.dart';
import 'package:kudabin/pages/complaints.dart';
import 'package:kudabin/pages/splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';

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
  Completer<GoogleMapController> _controller = Completer();
  LocationResult _pickedLocation;
  List<Marker> allMarkers = [];
  File _takenImage;

  final Map<String, dynamic> _formData = {"title": null, "content": null};

  Widget _titleField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Title",
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
            validator: (String value) {
              if (value.isEmpty || value.length < 4) {
                return "Title is required and should be 4+ characters";
              }
              return null;
            },
            onSaved: (String value) {
              _formData["title"] = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _descriptionField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Content",
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
                return "Description is required";
              }
              return null;
            },
            onSaved: (String value) {
              _formData["content"] = value;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Complaint"),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              _titleField(),
              _descriptionField(),
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
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topCenter,
                    ),
              SizedBox(height: 10),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      return model.complaintLoader
          ? CircularProgressIndicator()
          : InkWell(
              onTap: () async {
                print("@@@@@@@@@@@@@@@@@@@@@@@@@");
                if (_pickedLocation == null ||
                    !_formKey.currentState.validate()) {
                  print("#######################");
                  print(_formKey.currentState.validate());
                  print(_pickedLocation);
                  return;
                }
                print("%%%%%%%%%%%%%%%%%%%%%");
                _formKey.currentState.save();
                bool successInfo = await model.addComplaint(model.token, {
                  "title": _formData["title"],
                  "content": _formData["content"],
                  "latitude": _pickedLocation.latLng.latitude,
                  "longitude": _pickedLocation.latLng.longitude,
                  "imageUrl": "",
                  "solved": false
                });
                if (successInfo) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FutureBuilder(
                              future: model.fetchAllComplaints(model.token),
                              builder: (context, authResultSnapShot) {
                                return authResultSnapShot.connectionState ==
                                        ConnectionState.waiting
                                    ? SplashScreen()
                                    : Complaints(model);
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
                child: Text('Submit',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            );
    });
  }
}
