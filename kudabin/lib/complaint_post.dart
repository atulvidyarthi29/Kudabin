import "package:flutter/material.dart";

import 'ScopedModels/main_model.dart';
import 'Utils/side_drawer.dart';

class PostComplaint extends StatefulWidget {
  final MainModel model;

  PostComplaint(this.model);

  @override
  State<StatefulWidget> createState() {
    return _PostComplaint();
  }
}

class _PostComplaint extends State<PostComplaint> {
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
              onSaved: (String value) {
                //_formdata['title'] = value;
              },
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
              onSaved: (String value) {
                //_formdata['description'] = value;
              },
            ),
          ],
        ),
      )),
      drawer: SideDrawer(widget.model),
    );
  }
}
