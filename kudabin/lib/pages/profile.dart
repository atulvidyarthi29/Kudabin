import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/side_drawer.dart';
import 'package:kudabin/pages/profile_edit.dart';

class ProfilePage extends StatefulWidget {
  final MainModel model;

  ProfilePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
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
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 160,
                color: Theme.of(context).primaryColor,
              ),
              Container(
                height: 160,
                color: Theme.of(context).primaryColor,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.white,
                      ),
                      height: 80,
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    ),
                  ],
                ),
              ),
              Container(
                  child: Column(
                children: <Widget>[
                  SizedBox(height: 25),
                  Center(
                    child: Icon(
                      Icons.account_circle,
                      size: 140,
                    ),
                  ),
                ],
              )),
            ],
          ),
          Container(
            child: Center(
                child: Text(
              'Atul Vidyarthi',
              style: TextStyle(fontSize: 22, color: Colors.black),
            )),
          ),
          SizedBox(height: 10),
          Container(
            child: Center(
                child: Text(
              'Customer',
              style: TextStyle(fontSize: 16, color: Colors.black),
            )),
          ),
          SizedBox(height: 10),
          Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.location_on),
                  Text(
                    "  " + 'P.C. Colony, Kankarbagh, Patna',
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: SideDrawer(widget.model),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfileEdit()));
        },
        child: Icon(Icons.edit),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
