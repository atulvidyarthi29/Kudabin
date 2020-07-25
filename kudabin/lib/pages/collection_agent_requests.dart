import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/custom_appbar.dart';
import 'package:kudabin/Utils/side_drawer.dart';
import 'package:kudabin/pages/tracker.dart';

class CollectionAgentRequests extends StatefulWidget {
  final MainModel model;

  CollectionAgentRequests(this.model);

  @override
  _CollectionAgentRequestsState createState() =>
      _CollectionAgentRequestsState();
}

class _CollectionAgentRequestsState extends State<CollectionAgentRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Requests"),
      drawer: SideDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemBuilder: (context, index) {
              print(widget.model.colRequsts);
              return ListTile(
                title: Text("Pick up on " +
                    widget.model.colRequsts[index]["dateOfPickup"]),
                leading: Icon(Icons.airport_shuttle),
                subtitle: Text("Status - " +
                    ((widget.model.colRequsts[index]["status"] == "R")
                        ? "To be processed"
                        : (widget.model.colRequsts[index]["status"] == "G")
                            ? "Arriving today"
                            : "Processed")),
                trailing: IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () async {
                      if (widget.model.colRequsts[index]["status"] == "R") {
                        bool success = await widget.model.startProcessing(
                            widget.model.token,
                            widget.model.colRequsts[index]["_id"]);
                        if (success) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrackMap(
                                      widget.model.colRequsts[index],
                                      widget.model)));
                        } else {
                          print("Something went wrong");
                        }
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TrackMap(widget.model.colRequsts[index], widget.model)));
                      }
                    }),
              );
            },
            itemCount: widget.model.colRequsts.length),
      ),
    );
  }
}
