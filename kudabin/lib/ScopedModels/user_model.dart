import 'dart:async';
import 'dart:convert';

import 'package:kudabin/models/models.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends Model {
  bool _isAuthenticated = false;
  bool _loading = false;
  String _token;

  Users _loggedInUser;

  Users get loggedInUser {
    return _loggedInUser;
  }

  bool get loading {
    return _loading;
  }

  bool get isAuthenticated {
    return _isAuthenticated;
  }

  String get token {
    return _token;
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
    if (response.statusCode == 200) {
      _isAuthenticated = true;
      _token = body["token"];
      _loggedInUser = Users(
        id: body["user"]["_id"],
        username: body["user"]["username"],
        email: body["user"]["email"],
        firstName: body["user"]["firstName"],
        lastName: body["user"]["lastName"],
        gender: body["user"]["gender"],
        aadharNo: body["user"]["aadhar"],
        userType: body["user"]["userType"],
      );
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("token", body["token"]);
      pref.setString("user", json.encode(body["user"]));
      _loading = false;
      notifyListeners();
      return {"success": true, "message": "Successful"};
    } else {
      _loading = false;
      notifyListeners();
      return {"success": false, "message": body["message"]};
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

  Future<bool> autoAuthenticate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    print(token);
    if (token != null) {
      Map<String, dynamic> user = json.decode(pref.getString("user"));
      _token = token;
      _loggedInUser = Users(
        id: user["_id"],
        username: user["username"],
        email: user["email"],
        firstName: user["firstName"],
        lastName: user["lastName"],
        gender: user["gender"],
        aadharNo: user["aadhar"],
        userType: user["userType"],
      );
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> fetchProfileData(String token) async {
    http.Response resp = await http
        .get("https://kudabin.herokuapp.com/user/profile", headers: {
      "Authorization": "Bearer " + token,
      "Accept": "application/json"
    });
    if (resp.statusCode == 200) {
      Map<String, dynamic> userData = json.decode(resp.body);
      _loggedInUser = Users(
        id: userData["user"]["_id"],
        username: userData["user"]["username"],
        email: userData["user"]["email"],
        firstName: userData["user"]["firstName"],
        lastName: userData["user"]["lastName"],
        gender: userData["user"]["gender"],
        aadharNo: userData["user"]["aadhar"],
        userType: userData["user"]["userType"],
      );
      return {"success": true, "message": "Successful"};
    } else {
      _isAuthenticated = false;
      return {"success": false, "message": "Something went wrong."};
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _loggedInUser = null;
    _token = null;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
