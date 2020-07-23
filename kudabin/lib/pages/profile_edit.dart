import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/custom_appbar.dart';
import 'package:kudabin/pages/requests.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileEdit extends StatefulWidget {
  final MainModel model;

  ProfileEdit(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProfileEditState();
  }
}

class _ProfileEditState extends State<ProfileEdit> {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {
    "email": null,
    "first_name": null,
    "last_name": null,
    "gender": null,
    "mobileNo": null,
    "address": null,
    "aadharNo": null,
  };

  @override
  void initState() {
    _formData["email"] = widget.model.loggedInUser.email;
    _formData["first_name"] = widget.model.loggedInUser.firstName;
    _formData["last_name"] = widget.model.loggedInUser.lastName;
    _formData["gender"] = widget.model.loggedInUser.gender;
    _formData["mobileNo"] = widget.model.loggedInUser.mobileNo;
    _formData["address"] = widget.model.loggedInUser.address;
    _formData["aadharNo"] = widget.model.loggedInUser.aadharNo;
  }

  _showWarning(BuildContext context, String error) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Error",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: Text(error),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Try again",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget _firstNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "First Name",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: _formData["first_name"],
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (String value) {
              if (value.length < 1) {
                return "First Name can't be empty.";
              }
              return null;
            },
            onSaved: (String value) {
              _formData["first_name"] = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _lastNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Last Name",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: _formData["last_name"],
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (String value) {
              if (value.length < 1) {
                return "Last Name can't be empty.";
              }
              return null;
            },
            onSaved: (String value) {
              _formData["last_name"] = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _emailField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: _formData["email"],
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (String value) {
              if (value.isEmpty ||
                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (String value) {
              _formData["email"] = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _genderField() {
    List<String> _genders = ["Male", "Female", "Others"];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Gender",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          DropdownButtonFormField<String>(
            items: _genders.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                _formData["gender"] = newValue;
              });
            },
            value: _formData["gender"],
            onSaved: (value) {
              _formData["gender"] = value;
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return model.loading
            ? Center(child: CircularProgressIndicator())
            : InkWell(
                onTap: () async {
//                  TODO: change the whole logic
                  if (!_signUpKey.currentState.validate()) {
                    return;
                  }
                  _signUpKey.currentState.save();
                  Map<String, dynamic> successInformation =
                      await model.register(_formData);
                  if (successInformation['success'] == true)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Requests(model)));
                  else {
                    print("Registration Failed");
                    _showWarning(context, successInformation['message']);
                  }
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(2, 4),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xfffbb448), Color(0xfff7892b)]),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Update',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Edit Profile"),
      body: Form(
        key: _signUpKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _emailField(),
                _firstNameField(),
                _lastNameField(),
                _genderField(),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
