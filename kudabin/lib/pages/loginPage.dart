import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/app_logo.dart';
import 'package:kudabin/pages/collection_centers.dart';
import 'package:kudabin/pages/signup.dart';
import 'package:kudabin/pages/splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  final MainModel model;

  LoginPage(this.model, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "email": null,
    "password": null,
  };

  Widget _entryField() {
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
              _formData['email'] = value;
            },
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
            validator: (String value) {
              if (value.isEmpty || value.length < 6) {
                return 'Password invalid';
              }
              return null;
            },
            onSaved: (String value) {
              _formData['password'] = value;
            },
          ),
        ],
      ),
    );
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

  Widget _submitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.loading
          ? CircularProgressIndicator()
          : InkWell(
              onTap: () async {
                if (!_loginFormKey.currentState.validate()) {
                  return;
                }
                _loginFormKey.currentState.save();
                Map<String, dynamic> successInformation = await widget.model
                    .authenticate(_formData['email'], _formData['password']);
                if (successInformation['success'] == true)
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
                else {
                  print("Login Failed");
                  _showWarning(context, successInformation["message"]);
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
                child: Text('Login',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            );
    });
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).accentColor)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.14,
            decoration: BoxDecoration(
              color: Color(0xff1959a9),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
            ),
            alignment: Alignment.center,
            child: Text('f',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.74,
            decoration: BoxDecoration(
              color: Color(0xff2872ba),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(5),
                  topRight: Radius.circular(5)),
            ),
            alignment: Alignment.center,
            child: Text('Log in with Facebook',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
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
                      builder: (context) => SignUpPage(widget.model)));
            },
            child: Text(
              'Register',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          _entryField(),
          _passwordField(),
          _submitButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            AppLogo(
              colr: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 30,
            ),
            _emailPasswordWidget(),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerRight,
              child: Text('Forgot Password ?',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).accentColor)),
            ),
            _divider(),
            _facebookButton(),
            _createAccountLabel(),
          ],
        ),
      ),
    );
  }
}
