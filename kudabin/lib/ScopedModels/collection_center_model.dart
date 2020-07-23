import "dart:async";
import "dart:convert";

import "package:http/http.dart" as http;
import 'package:scoped_model/scoped_model.dart';

class CollectionCenterModel extends Model {
  List<Map<String, dynamic>> _colCenters = [];
  bool _managingCenter = false;

  bool get managingCenter => _managingCenter;

  List<Map<String, dynamic>> get collectionCenters {
    return List.from(_colCenters);
  }

  Future<bool> fetchCenter(token) async {
    http.Response response =
        await http.get("https://kudabin.herokuapp.com/cpoints", headers: {
      "Authorization": "Bearer " + token,
    });
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 201) {
      _colCenters = List.from(data["cPoints"]);
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> addCenter(
      token, String address, double latitude, double longitude) async {
    _managingCenter = true;
    notifyListeners();
    http.Response response = await http.post(
        "https://kudabin.herokuapp.com/cpoints/add-point",
        headers: {
          "Authorization": "Bearer " + token,
          "Content-Type": "application/json"
        },
        body: json.encode({
          "description": address,
          "latitude": latitude,
          "longitude": longitude
        }));

    if (response.statusCode == 201) {
      fetchCenter(token);
      _managingCenter = false;
      notifyListeners();
      return {"success": true, "message": "Added Successfully"};
    } else {
      _managingCenter = false;
      notifyListeners();
      return {
        "success": false,
        "message":
            "Something went wrong. Please check your connection and try again"
      };
    }
  }

  Future<Map<String, dynamic>> removeCenter(token, id) async {
    http.Response response = await http.delete(
        "https://kudabin.herokuapp.com/cpoints/delete-point/" + id,
        headers: {
          "Authorization": "Bearer " + token,
        });
    print(response.body);

    if (response.statusCode == 200) {
      fetchCenter(token);
      return {"success": true, "message": "Added Successfully"};
    } else
      return {
        "success": false,
        "message":
            "Something went wrong. Please check your connection and try again"
      };
  }
}
