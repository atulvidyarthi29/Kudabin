import 'package:flutter/material.dart';

import 'collection_centers.dart';


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
      home: CollectionPoints(),
    );
  }
}

