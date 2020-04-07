import 'package:flutter/material.dart';
import 'package:kudabin/Utils/side_drawer.dart';

class Complaints extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ComplaintsState();
  }
}

class _ComplaintsState extends State<Complaints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Collection Centers', style: TextStyle(color: Colors.white)),
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
      body: ListView(
        children: <Widget>[Text("data"), Text("data")],
      ),
      drawer: SideDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
