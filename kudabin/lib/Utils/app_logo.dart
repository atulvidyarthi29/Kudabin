import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  double size;
  Color col;

  AppLogo({double fs:25, Color colr}){
    size = fs;
    col = colr;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Kuda',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: col,
          ),
          children: [
            TextSpan(
              text: 'Bin',
              style: TextStyle(color: Theme.of(context).accentColor, fontSize: size),
            ),
          ]),
    );
  }
}
