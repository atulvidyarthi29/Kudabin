import 'dart:async';
import 'dart:convert';

import 'package:kudabin/models/models.dart';
import 'package:scoped_model/scoped_model.dart';
import "package:http/http.dart" as http;

class RequestModel extends Model {
  List<Request> requestPast = [];
  bool currentRequest = false;

  fetchPastRequests() {}

  getCurrentRequest() {}

  Future<Map<String, dynamic>> redirectPayment(
      String token, Map<String, dynamic> data) async {
    http.Response response = await http.post(
        "https://kudabin.herokuapp.com/request/",
        headers: {
          "Authorization": "Bearer " + token,
          "Content-Type": "application/json"
        },
        body: json.encode(data));
    print(response.statusCode);
    print(response.body);
    return {"success": true, "response": response.body};
  }
}
