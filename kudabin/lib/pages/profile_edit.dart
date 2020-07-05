import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileEditState();
  }
}

class _ProfileEditState extends State<ProfileEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Edit', style: TextStyle(color: Colors.white)),
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
        key: _formKey,
        child: ListView(
          children: <Widget>[
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
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "username",
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (String value) {
                if (value.isEmpty || value.length < 4) {
                  return "Title is required and should be 4+ characters";
                }
                return "";
              },
              onSaved: (String value) {},
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "First Name",
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return "First Name cannot be empty.";
                }
                return "";
              },
              onSaved: (String value) {},
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Last Name",
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Last Name cannot be empty.";
                }
                return "";
              },
              onSaved: (String value) {},
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (String value) {
                if (value.isEmpty || value.length < 4) {
                  return "Email field cannot be empty.";
                }
                return "";
              },
              onSaved: (String value) {},
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Address",
                filled: true,
                fillColor: Colors.white,
              ),
              onSaved: (String value) {},
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Mobile No.",
                filled: true,
                fillColor: Colors.white,
              ),
              onSaved: (String value) {},
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  Text(
                    ' Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                _formKey.currentState.validate();
                _formKey.currentState.save();
              },
            )
          ],
        ),
      ),
    );
  }
}
