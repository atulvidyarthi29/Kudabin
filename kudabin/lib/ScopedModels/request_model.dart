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

  Future<Map<String, dynamic>> redirectpayment(token) async {
    http.Response response = await http.post(
        "https://kudabin.herokuapp.com/request/",
        headers: {
          "Authorization": "Bearer " + token,
          "Content-Type": "application/json"
        },
        body: json.encode({
          "latitude": 52.6,
          "longitude": 82.6,
          "quantity": 10,
          "dateOfPickup": "27/02/20"
        }));
    print("@@@@@@@@@@@@@@@@");
    print(response.statusCode);
    print(response.body);
    return {"success": true, "response": response.body};
  }
}
