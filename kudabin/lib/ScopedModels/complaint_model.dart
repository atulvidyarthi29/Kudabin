import "dart:convert";

import 'package:kudabin/models/models.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class ComplaintModel extends Model {
  List<Map<String, dynamic>> _allComplaints = [];
  bool _complaintsLoader = false;

  List<Map<String, dynamic>> get allComplaints {
    return List.from(_allComplaints);
  }

  bool get complaintLoader {
    return _complaintsLoader;
  }

  Future<bool> fetchAllComplaints(String token) async {
    http.Response response = await http
        .get("https://kudabin.herokuapp.com/complaint/fetch", headers: {
      "Authorization": "Bearer " + token,
      "Content-Type": "application/json"
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _allComplaints = List.from(data["complaints"]);
      return true;
    } else
      return false;
  }

  Future<bool> addComplaint(String token, Map<String, dynamic> complain) async {
    print(complain);
    _complaintsLoader = true;
    notifyListeners();
    http.Response response = await http.post(
        "https://kudabin.herokuapp.com/complaint/",
        headers: {
          "Authorization": "Bearer " + token,
          "Content-Type": "application/json"
        },
        body: json.encode(complain));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      fetchAllComplaints(token);
      _complaintsLoader = false;
      notifyListeners();
      return true;
    } else {
      _complaintsLoader = false;
      notifyListeners();
      return false;
    }
  }
}
