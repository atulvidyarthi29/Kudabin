import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/Utils/app_logo.dart';
import 'package:kudabin/Widget/bezierContainer.dart';
import 'package:kudabin/pages/loginPage.dart';
import 'package:kudabin/pages/signup.dart';

class WelcomePage extends StatefulWidget {
  final MainModel model;

  WelcomePage(this.model, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginPage(widget.model)));
      },
      child: Container(
        height: 50,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).accentColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
        ),
        padding: const EdgeInsets.all(10.0),
        child:
            Text('Login', style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignUpPage(widget.model)));
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
        child: Text('Register',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 120,
                    ),
                    AppLogo(
                      fs: 50,
                      colr: Theme.of(context).primaryColor,
                    ),
                    Center(
                      child: Text(
                        'A step towards cleaner India.',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                    SizedBox(
                      height: 120,
                    ),
                    _submitButton(),
                    SizedBox(
                      height: 20,
                    ),
                    _signUpButton(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: -MediaQuery.of(context).size.height * .10,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer())
            ],
          ),
        ),
      ),
    );
  }
}
