import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/custom_appbar.dart';
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
  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
      markerId:
          MarkerId(widget.model.allComplaints.elementAt(widget.index)["_id"]),
      draggable: false,
      infoWindow: InfoWindow(
          title: widget.model.allComplaints
                  .elementAt(widget.index)["latitude"]
                  .toString() +
              widget.model.allComplaints
                  .elementAt(widget.index)["longitude"]
                  .toString()),
      position: LatLng(
          widget.model.allComplaints.elementAt(widget.index)["latitude"],
          widget.model.allComplaints.elementAt(widget.index)["longitude"]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Details"),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      widget.model.allComplaints
                          .elementAt(widget.index)["latitude"],
                      widget.model.allComplaints
                          .elementAt(widget.index)["longitude"]),
                  zoom: 7,
                ),
                markers: Set.from(allMarkers),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey[200])),
              padding: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Details",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.model.allComplaints
                              .elementAt(widget.index)["title"]
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              widget.model.allComplaints
                                  .elementAt(widget.index)["createdAt"],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            widget.model.allComplaints
                                        .elementAt(widget.index)["solved"] ==
                                    true
                                ? ResolvedButton()
                                : PendingButton()
                          ],
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            widget.model.allComplaints
                                .elementAt(widget.index)["content"],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(6),
                    child: Text(
                      "Media",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
//                    height: 80,
                    child: Image.asset(
                      'assets/garbage.jpg',
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            (widget.model.allComplaints.elementAt(widget.index)["feedback"] !=
                    null)
                ? Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(6),
                          child: Text(
                            "Feedback",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.model.allComplaints
                                .elementAt(widget.index)["feedback"],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
