import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/app_logo.dart';
import 'package:kudabin/pages/collection_centers.dart';
import 'package:kudabin/pages/complaints.dart';
import 'package:kudabin/pages/profile.dart';
import 'package:kudabin/pages/requests.dart';
import 'package:kudabin/pages/welcomePage.dart';

import 'package:kudabin/pages/profile_edit.dart';

class SideDrawer extends StatelessWidget {
  final MainModel model;

  SideDrawer(this.model);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                AppLogo(
                  fs: 30,
                  colr: Colors.white,
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.white,
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 5),
                        Text(
                          "Atul Vidyarthi",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        FlatButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileEdit()));
                          },
                          icon: Icon(Icons.edit, color: Colors.white),
                          label: Text("Edit Profile",
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Collection Centers'),
            leading: Icon(Icons.store_mall_directory),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CollectionPoints(model)));
            },
          ),
          ListTile(
            title: Text('Your complaints'),
            leading: Icon(Icons.insert_comment),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Complaints(model)));
            },
          ),
          ListTile(
            title: Text('Request a pickup'),
            leading: Icon(Icons.directions_car),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Requests(model)));
            },
          ),
          ListTile(
            title: Text('Profile'),
            leading: Icon(Icons.account_circle),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage(model)));
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WelcomePage(model)));
            },
          ),
        ],
      ),
    );
  }
}
