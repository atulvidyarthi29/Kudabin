import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/app_logo.dart';
import 'package:kudabin/pages/collection_centers.dart';
import 'package:kudabin/pages/loginPage.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpPage extends StatefulWidget {
  final MainModel model;

  SignUpPage(this.model, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  Map<String, dynamic> _formData = {
    "username": null,
    "email": null,
    "first_name": null,
    "last_name": null,
    "gender": null,
    "password": null,
    "dob": null,
    "mobileNo": null,
    "address": null,
    "aadharNo": null,
    "profilePic": null,
    "userType": null,
  };
  String _dateOfBirth = "hi";

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

  Widget _usernameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Username",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (String value) {
              if (value.length < 5) {
                return 'Username should have a minimum length of 5';
              }
              return null;
            },
            onSaved: (String value) {
              _formData["username"] = value;
            },
          ),
        ],
      ),
    );
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

  Widget _dobPicker() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.cake),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(1940, 1, 1),
              maxTime: DateTime.now(),
              onChanged: (date) {
                var formatter = new DateFormat('yyyy-MM-dd');
                String changedDate = formatter.format(date);
                setState(() {
                  _dateOfBirth = changedDate;
                });
                print('change $date');
              },
              onConfirm: (date) {
                var formatter = new DateFormat('yyyy-MM-dd');
                _formData["dob"] = formatter.format(date);
              },
              locale: LocaleType.en,
            );
          },
        ),
        Text(_dateOfBirth),
      ],
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

  Widget _passwordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Password",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            controller: _passwordController,
            validator: (String value) {
              if (value.isEmpty || value.length < 6) {
                return 'Password invalid';
              }
              return null;
            },
            onSaved: (String value) {
              _formData["password"] = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _confirmPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Confirm Password",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            validator: (String value) {
              if (_passwordController.text != value) {
                return 'Password do not match';
              }
              return null;
            },
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
                            builder: (context) => CollectionPoints(model)));
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
                  child: Text('Register Now',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              );
      },
    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).accentColor),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(widget.model)));
            },
            child: Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _signUpKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                AppLogo(
                  fs: 30,
                  colr: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 30,
                ),
                _usernameField(),
                _emailField(),
                _firstNameField(),
                _lastNameField(),
//              _dobPicker(),
                _genderField(),
                _passwordField(),
                _confirmPasswordField(),
                _submitButton(),
                _loginAccountLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
