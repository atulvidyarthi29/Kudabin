import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kudabin/pages/collection_centers.dart';
import 'package:kudabin/pages/splash_screen.dart';
import 'package:kudabin/pages/welcomePage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
    as location_picker;
import 'package:flutter/services.dart';
import 'ScopedModels/main_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(KudaBin());
}

class KudaBin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KudaBinState();
  }
}

class _KudaBinState extends State<KudaBin> {
  final _model = MainModel();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        print(message["notification"]);
        _model.saveNotifications(message["notification"]);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['data'];
        _model.saveNotifications(notification);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _model.saveDeviceId(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xffe46b10),
            accentColor: Color(0xff0f03fc),
            textTheme: TextTheme(body1: TextStyle(color: Colors.black)),
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
                ? FutureBuilder(
                    future: model.fetchCenter(model.token),
                    builder: (context, authResultSnapShot) {
                      return authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : CollectionPoints(model);
                    })
                : FutureBuilder(
                    future: _model.autoAuthenticate(),
                    builder: (context, authResultSnapShot) {
                      return authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : WelcomePage(_model);
                    },
                  );
          }),
          debugShowCheckedModeBanner: false),
    );
  }
}
