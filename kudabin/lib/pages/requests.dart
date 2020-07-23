import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/custom_appbar.dart';
import 'package:kudabin/Utils/side_drawer.dart';
import 'package:kudabin/pages/PaymentScreen.dart';
import 'package:scoped_model/scoped_model.dart';

class Requests extends StatefulWidget {
  final MainModel model;

  Requests(this.model);

  @override
  State<StatefulWidget> createState() {
    return _RequestsState();
  }
}

class _RequestsState extends State<Requests> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _requestKey = GlobalKey<FormState>();
  LocationResult _pickedLocation;
  List<Marker> newMarkers = [];

  DateTime date;
  String quantity;

  final format = DateFormat("yyyy-mm-dd");

  Widget _dateField() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Date Field (${format.pattern})',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          DateTimeField(
            format: format,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            onShowPicker: (context, currentValue) {
              date = currentValue;
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
          ),
        ]);
  }

  Widget _quantityField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Quantity (kg)",
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
              if (value.isEmpty) {
                return "Quantity is required";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            onSaved: (String value) {
              quantity = value;
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
          _requestKey.currentState.save();
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

  Widget _proceedToPaymentButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      return InkWell(
        onTap: () async {
          if (!_requestKey.currentState.validate() && _pickedLocation == null)
            return;
          Map<String, dynamic> response =
              await model.redirectPayment(model.token, {
            "latitude": _pickedLocation.latLng.latitude,
            "longitude": _pickedLocation.latLng.longitude,
            "quantity": quantity,
            "dateOfPickup": date.toString()
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentScreen(response["response"])));
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
          child: Text('Proceed to Payment',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      );
    });
  }

  Widget _requestButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: InkWell(
        onTap: _requestAPickUp,
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
          child: Text('Request a Pickup',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
    );
  }

  void _requestAPickUp() {
    scaffoldState.currentState.showBottomSheet((context) {
      return SingleChildScrollView(
        child: Form(
          key: _requestKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                _dateField(),
                SizedBox(height: 10),
                _quantityField(),
                SizedBox(height: 10),
                _locationPreview(),
                _locationButton(),
                _proceedToPaymentButton(),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: CustomAppBar("Request"),
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
//                Container(
//                  height: MediaQuery.of(context).size.height * 0.7,
//                  child: Center(
//                    child: Text(
//                      "No past Requests.",
//                      style: TextStyle(
//                          fontWeight: FontWeight.w600,
//                          color: Theme.of(context).accentColor,
//                          fontSize: 16),
//                    ),
//                  ),
//                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text("Pick up on " + "27/85/96"),
                        leading: Icon(Icons.airport_shuttle),
                        subtitle: Text("Status - Pending"),
                      ),
                      ListTile(
                        title: Text("Pick up on " + "27/85/96"),
                        leading: Icon(Icons.airport_shuttle),
                        subtitle: Text("Status - Pending"),
                      ),
                      ListTile(
                        title: Text("Pick up on " + "27/85/96"),
                        leading: Icon(Icons.airport_shuttle),
                        subtitle: Text("Status - Pending"),
                      ),
                      ListTile(
                        title: Text("Pick up on " + "27/85/96"),
                        leading: Icon(Icons.airport_shuttle),
                        subtitle: Text("Status - Pending"),
                      ),
                      ListTile(
                        title: Text("Pick up on " + "27/85/96"),
                        leading: Icon(Icons.airport_shuttle),
                        subtitle: Text("Status - Pending"),
                      ),
                      ListTile(
                        title: Text("Pick up on " + "27/85/96"),
                        leading: Icon(Icons.airport_shuttle),
                        subtitle: Text("Status - Pending"),
                      ),
                      ListTile(
                        title: Text("Pick up on " + "27/85/96"),
                        leading: Icon(Icons.airport_shuttle),
                        subtitle: Text("Status - Pending"),
                      ),
                    ],
                  ),
                ),
                _requestButton(),
              ],
            ),
          );
        },
      ),
      drawer: SideDrawer(),
    );
  }
}
