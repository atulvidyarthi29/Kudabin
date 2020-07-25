import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/app_logo.dart';
import 'package:kudabin/pages/collection_agent_requests.dart';
import 'package:kudabin/pages/collection_centers.dart';
import 'package:kudabin/pages/complaints.dart';
import 'package:kudabin/pages/profile.dart';
import 'package:kudabin/pages/requests.dart';
import 'package:kudabin/pages/splash_screen.dart';
import 'package:kudabin/pages/welcomePage.dart';
import 'package:kudabin/pages/profile_edit.dart';
import 'package:scoped_model/scoped_model.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
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
                            model.loggedInUser.firstName +
                                " " +
                                model.loggedInUser.lastName,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          FlatButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileEdit(model)));
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
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xfffbb448), Color(0xfff7892b)]),
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
                        builder: (context) => FutureBuilder(
                            future: model.fetchCenter(model.token),
                            builder: (context, authResultSnapShot) {
                              return authResultSnapShot.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : CollectionPoints(model);
                            })));
              },
            ),
            (model.loggedInUser.userType == "cAgent")
                ? ListTile(
                    title: Text('Requests'),
                    leading: Icon(Icons.directions_car),
                    onTap: () {
                      DateTime date = DateTime.now();

                      String strDate = "${date.day}-${date.month}-${date.year}";

                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FutureBuilder(
                                  future: model.fetchCollectionAgentRequests(
                                      model.token, strDate),
                                  builder: (context, authResultSnapShot) {
                                    return authResultSnapShot.connectionState ==
                                            ConnectionState.waiting
                                        ? SplashScreen()
                                        : CollectionAgentRequests(model);
                                  })));
                    },
                  )
                : ListTile(
                    title: Text('Request a pickup'),
                    leading: Icon(Icons.directions_car),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FutureBuilder(
                                  future: model.fetchPastRequests(model.token),
                                  builder: (context, authResultSnapShot) {
                                    return authResultSnapShot.connectionState ==
                                            ConnectionState.waiting
                                        ? SplashScreen()
                                        : Requests(model);
                                  })));
                    },
                  ),
            ListTile(
              title: Text('Your complaints'),
              leading: Icon(Icons.insert_comment),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                            future: model.fetchAllComplaints(model.token),
                            builder: (context, authResultSnapShot) {
                              return authResultSnapShot.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : Complaints(model);
                            })));
              },
            ),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.account_circle),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(model)));
              },
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                model.logout();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WelcomePage(model)));
              },
            ),
          ],
        ),
      );
    });
  }
}
