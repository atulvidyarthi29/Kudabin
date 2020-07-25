import 'package:flutter/material.dart';
import 'package:kudabin/Utils/app_logo.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          children: <Widget>[
            AppLogo(
              fs: 30,
              colr: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 10,
            ),
            Container(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}
