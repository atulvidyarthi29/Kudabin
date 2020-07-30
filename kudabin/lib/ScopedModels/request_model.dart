import 'dart:async';
import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import "package:http/http.dart" as http;

class RequestModel extends Model {
  List<Map<String, dynamic>> _requests = [];

  List<Map<String, dynamic>> _colRequsts = [];

  List<Map<String, dynamic>> get colRequsts {
    return List.from(_colRequsts);
  }

  bool _requestLoader = false;

  bool get requestLoader {
    return _requestLoader;
  }

  List<Map<String, dynamic>> get requests {
    return List.from(_requests);
  }

  Future<bool> fetchPastRequests(String token) async {
    http.Response response = await http
        .get("https://kudabin.herokuapp.com/request/fetch", headers: {
      "Authorization": "Bearer " + token,
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _requests = List.from(data["requests"]);
      return true;
    } else
      return false;
  }

  List<Map<String, dynamic>> filter(status) {
    List<Map<String, dynamic>> filteredData = [];
    _requests.forEach((Map<String, dynamic> element) {
      if (element["status"] == status) {
        filteredData.add(element);
      }
    });
  }

  Future<Map<String, dynamic>> redirectPayment(
      String token, Map<String, dynamic> data) async {
    _requestLoader = true;
    notifyListeners();

    http.Response response = await http.post(
        "https://kudabin.herokuapp.com/request/",
        headers: {
          "Authorization": "Bearer " + token,
          "Content-Type": "application/json"
        },
        body: json.encode(data));
    _requestLoader = false;
    notifyListeners();
    return {"success": true, "response": response.body};
  }

  Future<bool> fetchCollectionAgentRequests(String token, String date) async {
    http.Response response = await http.get(
        "https://kudabin.herokuapp.com/request/agent/fetch?date=${date}",
        headers: {
          "Authorization": "Bearer " + token,
          "Content-Type": "application/json"
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _colRequsts = List.from(data["requests"]);
      return true;
    } else
      return false;
  }

  Future<bool> startProcessing(String token, String id) async {
    http.Response response = await http.get(
        "https://kudabin.herokuapp.com/request/init-request/" + id,
        headers: {
          "Authorization": "Bearer " + token,
          "Content-Type": "application/json"
        });

    print(response.body);
    if (response.statusCode == 200) return true;
    return false;
  }

  Future<bool> finishProcessing(String token, String id) async {
    http.Response response = await http.get(
        "https://kudabin.herokuapp.com/request/end-request/" + id,
        headers: {
          "Authorization": "Bearer " + token,
          "Content-Type": "application/json"
        });

    return (response.statusCode == 200) ? true : false;
  }
}
