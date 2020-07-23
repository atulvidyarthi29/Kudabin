import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/side_drawer.dart';
import 'package:kudabin/pages/profile_edit.dart';
import 'package:kudabin/pages/welcomePage.dart';

class ProfilePage extends StatefulWidget {
  final MainModel model;

  ProfilePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  Widget _aboutElement(String field, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: <Widget>[
          Text(
            field,
            style: TextStyle(color: Colors.black),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: CustomAppBar("Profile"),
      key: _key,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xfffbb448), Color(0xfff7892b)]),
                  ),
                  height: 300,
                  child: Center(
                      child: Wrap(
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.account_circle,
                              size: 140,
                              color: Colors.white,
                            ),
                            Text(
                              widget.model.loggedInUser.username,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28),
                            ),
                            Text(
                              widget.model.loggedInUser.userType,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "About",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _aboutElement(
                          "Email:     ", widget.model.loggedInUser.email),
                      _aboutElement(
                          "Name:      ",
                          widget.model.loggedInUser.firstName +
                              " " +
                              widget.model.loggedInUser.lastName),
                      _aboutElement(
                          "Gender:      ", widget.model.loggedInUser.gender),
                      _aboutElement("Aadhar No:    ", "8888-9999-6666-2222"),
                      _aboutElement("Phone No:    ", "8309926308"),
//                  Container(child:,),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey[200])),
                  child: ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 20),
                    ),
                    onTap: () {
                      widget.model.logout();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomePage(widget.model)));
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            top: 20,
            child: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                _key.currentState.openDrawer();
              },
            ),
          ),
          Positioned(
            right: 10,
            top: 20,
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
              },
            ),
          )
        ],
      ),

      drawer: SideDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfileEdit(widget.model)));
        },
        child: Icon(Icons.edit),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
