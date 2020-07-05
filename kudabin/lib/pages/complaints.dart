import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';

import 'package:kudabin/Utils/side_drawer.dart';
import 'package:kudabin/Utils/status_button.dart';

import 'package:kudabin/pages/complaint_details.dart';
import 'package:kudabin/pages/complaint_post.dart';

class Complaints extends StatefulWidget {
  final MainModel model;

  Complaints(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ComplaintsState();
  }
}

class _ComplaintsState extends State<Complaints> {
  @override
  void initState() {
    super.initState();
    widget.model.fetchAllComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaints', style: TextStyle(color: Colors.white)),
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
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
//              decoration: BoxDecoration(
//                border: Border.all(width: 2),
//                borderRadius: BorderRadius.all(Radius.circular(5)),
//              ),
            margin: EdgeInsets.all(2),
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.model.allComplaints.elementAt(index).ticketNo +
                      " " +
                      widget.model.allComplaints.elementAt(index).title,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
//                Text(
//                  widget.model.allComplaints.elementAt(index).title,
//                  style: TextStyle(
//                    fontWeight: FontWeight.bold,
//                    fontSize: 18,
//                    color: Colors.black,
//                  ),
//                ),
                Text(
                  widget.model.allComplaints.elementAt(index).date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
//                  Divider(),
                Text(
                  widget.model.allComplaints.elementAt(index).body,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    widget.model.allComplaints.elementAt(index).status == 'R'
                        ? ResolvedButton()
                        : PendingButton(),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ComplaintDetails(widget.model, index)));
                      },
                      child: Row(
                        children: <Widget>[
                          Text("View Details"),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        },
        itemCount: widget.model.allComplaints.length,
      ),
      drawer: SideDrawer(widget.model),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostComplaint(widget.model)));
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
