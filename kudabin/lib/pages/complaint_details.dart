import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/side_drawer.dart';
import 'package:kudabin/Utils/status_button.dart';


class ComplaintDetails extends StatefulWidget {
  final MainModel model;
  final int index;

  ComplaintDetails(this.model, this.index);

  @override
  State<StatefulWidget> createState() {
    return _ComplaintDetailsState();
  }
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
      markerId:
          MarkerId(widget.model.allComplaints.elementAt(widget.index).ticketNo),
      draggable: false,
      onTap: () {
        print('Hey');
      },
      position: LatLng(
          widget.model.allComplaints.elementAt(widget.index).latitude,
          widget.model.allComplaints.elementAt(widget.index).longitude),
    ));
  }

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
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Center(
              child: Text(
                widget.model.allComplaints.elementAt(widget.index).ticketNo,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.model.allComplaints.elementAt(widget.index).title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.model.allComplaints.elementAt(widget.index).date,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.model.allComplaints.elementAt(widget.index).body,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
                child:
                    widget.model.allComplaints.elementAt(widget.index).status ==
                            'R'
                        ? ResolvedButton()
                        : PendingButton()),
            SizedBox(height: 10),
            Text(
              "Media",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/garbage.jpg',
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Location",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Container(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      widget.model.allComplaints
                          .elementAt(widget.index)
                          .latitude,
                      widget.model.allComplaints
                          .elementAt(widget.index)
                          .longitude),
                  zoom: 14.4746,
                ),
                markers: Set.from(allMarkers),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
      drawer: SideDrawer(widget.model),
    );
  }
}
