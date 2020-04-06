import 'package:flutter/material.dart';
import 'package:kudabin/welcomePage.dart';

// import 'collection_centers.dart';

void main() => runApp(KudaBin());

class KudaBin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KudaBinState();
  }
}

class _KudaBinState extends State<KudaBin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffe46b10),
        accentColor: Color(0xff0f03fc),
        textTheme: TextTheme(body1: TextStyle(color: Colors.purple)),
      ),
      home: WelcomePage(),
      debugShowCheckedModeBanner: false
    );
  }
}
