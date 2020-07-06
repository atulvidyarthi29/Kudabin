import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kudabin/pages/collection_centers.dart';
import 'package:kudabin/pages/welcomePage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
    as location_picker;

import 'ScopedModels/main_model.dart';

void main() => runApp(KudaBin());

class KudaBin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KudaBinState();
  }
}

class _KudaBinState extends State<KudaBin> {
  final _model = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xffe46b10),
            accentColor: Color(0xff0f03fc),
            textTheme: TextTheme(body1: TextStyle(color: Colors.purple)),
          ),
          localizationsDelegates: const [
            location_picker.S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale('en', ''),
            Locale('ar', ''),
          ],
          home: ScopedModelDescendant(
              builder: (BuildContext context, Widget widget, MainModel model) {
            return _model.isAuthenticated
                ? CollectionPoints(_model)
                : FutureBuilder(
                    future: _model.autoAuthenticate(),
                    builder: (context, authResultSnapShot) {
                      return authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? Scaffold(
                              body: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : WelcomePage(_model);
                    },
                  );
          }),
          debugShowCheckedModeBanner: false),
    );
  }
}
