import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/custom_appbar.dart';

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
    widget.model.fetchAllComplaints(widget.model.token);
  }

  Widget _complaintTile(index) {
    return ListTile(
      leading: Icon(
        Icons.announcement,
        color: Theme.of(context).accentColor,
      ),
      title: Text(widget.model.allComplaints[index]["title"]),
      subtitle: Text(widget.model.allComplaints[index]["createdAt"]),
      trailing: widget.model.allComplaints[index]["solved"] == true
          ? ResolvedButton()
          : PendingButton(),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ComplaintDetails(widget.model, index)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Complaints"),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _complaintTile(index);
        },
        itemCount: widget.model.allComplaints.length,
      ),
      drawer: SideDrawer(),
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
