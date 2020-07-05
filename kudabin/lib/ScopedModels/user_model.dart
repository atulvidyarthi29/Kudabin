import 'dart:async';
import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends Model {
  bool _isAuthenticated = false;
  bool _loading = false;

  bool get loading {
    return _loading;
  }

  bool get isAuthenticated {
    return _isAuthenticated;
  }

  Future<Map<String, dynamic>> authenticate(
      String email, String password) async {
    _loading = true;
    notifyListeners();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    http.Response response =
        await http.post("https://kudabin.herokuapp.com/auth/login",
            headers: headers,
            body: json.encode({
              "email": email,
              "password": password,
            }));

    Map<String, dynamic> body = json.decode(response.body);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("token", body["token"]);
    pref.setString("token", body["expiry"]);
//    body["user"].forEach((){
//
//    });
    _loading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      _isAuthenticated = true;
      return {"success": false, "message": "Successful"};
    } else
      return {"success": false, "message": body["message"]};
  }

  Future<Map<String, dynamic>> autoAuthenticate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    if(token != null){

    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    _loading = true;
    notifyListeners();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    http.Response response = await http.put(
      "https://kudabin.herokuapp.com/auth/signup",
      headers: headers,
      body: json.encode(userData),
    );
    authenticate(userData["email"], userData["password"]);
    _loading = false;
    notifyListeners();
    Map<String, dynamic> body = json.decode(response.body);
    if (response.statusCode == 201)
      return {"success": true, "message": "Successful"};
    else
      return {"success": false, "message": body["data"][0]["msg"]};
  }

  Future<Map<String, dynamic>> logout() {}
}
