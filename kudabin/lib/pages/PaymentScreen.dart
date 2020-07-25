import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:kudabin/pages/requests.dart';
import 'package:kudabin/pages/splash_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Constants.dart';

class PaymentScreen extends StatefulWidget {
  final String data;
  final MainModel model;

  PaymentScreen(this.data, this.model);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController _webController;
  bool _loadingPayment = true;
  String _responseStatus = STATUS_LOADING;

  String _loadHTML() {
    return widget.data;
  }

  void getData() {
    _webController.evaluateJavascript("document.body.innerText").then((data) {
      var decodedJSON = jsonDecode(data);
      print(decodedJSON);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      print(responseJSON);
      final paytmResponse = responseJSON["paymentObject"];
      if (paytmResponse["STATUS"] == "TXN_SUCCESS") {
        _responseStatus = STATUS_SUCCESSFUL;
      } else if (paytmResponse["STATUS"] == "TXN_FAILURE") {
        _responseStatus = STATUS_FAILED;
      }
      this.setState(() {});
    });
  }

  Widget getResponseScreen() {
    switch (_responseStatus) {
      case STATUS_SUCCESSFUL:
        return PaymentSuccessfulScreen(widget.model);
      case STATUS_CHECKSUM_FAILED:
        return CheckSumFailedScreen(widget.model);
      case STATUS_FAILED:
        return PaymentFailedScreen(widget.model);
    }
    return PaymentSuccessfulScreen(widget.model);
  }

  @override
  void dispose() {
    _webController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: WebView(
              debuggingEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webController = controller;
                _webController.loadUrl(
                    new Uri.dataFromString(_loadHTML(), mimeType: 'text/html')
                        .toString());
              },
              onPageFinished: (page) {
                if (page.contains("/process")) {
                  if (_loadingPayment) {
                    this.setState(() {
                      _loadingPayment = false;
                    });
                  }
                }
                if (page.contains("/response-payment")) {
                  getData();
                }
              },
            ),
          ),
          (_responseStatus != STATUS_LOADING)
              ? Center(child: getResponseScreen())
              : Center()
        ],
      )),
    );
  }
}

class PaymentSuccessfulScreen extends StatelessWidget {
  final MainModel model;

  PaymentSuccessfulScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Great!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Thank you making the payment!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FutureBuilder(
                                future: model.fetchPastRequests(model.token),
                                builder: (context, authResultSnapShot) {
                                  return authResultSnapShot.connectionState ==
                                          ConnectionState.waiting
                                      ? SplashScreen()
                                      : Requests(model);
                                })));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentFailedScreen extends StatelessWidget {
  final MainModel model;

  PaymentFailedScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "OOPS!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Payment was not successful, Please try again Later!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FutureBuilder(
                                future: model.fetchPastRequests(model.token),
                                builder: (context, authResultSnapShot) {
                                  return authResultSnapShot.connectionState ==
                                          ConnectionState.waiting
                                      ? SplashScreen()
                                      : Requests(model);
                                })));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CheckSumFailedScreen extends StatelessWidget {
  final MainModel model;

  CheckSumFailedScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Oh Snap!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Problem Verifying Payment, If you balance is deducted please contact our customer support and get your payment verified!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FutureBuilder(
                                future: model.fetchPastRequests(model.token),
                                builder: (context, authResultSnapShot) {
                                  return authResultSnapShot.connectionState ==
                                          ConnectionState.waiting
                                      ? SplashScreen()
                                      : Requests(model);
                                })));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
