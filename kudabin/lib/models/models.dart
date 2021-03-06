class Users {
  String id;
  String username;
  String email;
  String firstName;
  String lastName;
  String dob;
  String gender;
  String password;
  String mobileNo;
  String address;
  int aadharNo;
  String profilePic;
  String userType;

  Users({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
    this.password,
    this.mobileNo,
    this.address,
    this.aadharNo,
    this.userType,
  });
}

class CollectionAgent {
  int id;
  int userId;
  double rating;
  int vehicleId;

  CollectionAgent({
    this.id,
    this.userId,
    this.rating,
    this.vehicleId,
  });
}


class Vehicle {
  int id;
  String vehicleNo;
  int collectCenter;

  Vehicle({
    this.id,
    this.vehicleNo,
    this.collectCenter,
  });
}

//class Complaint {
//  int id;
//  String ticketNo;
//  String date;
//  String image;
//  double latitude;
//  double longitude;
//  String body;
//  String title;
//  int complainedBy;
//  bool status;
//
//  Complaint({
//    this.id,
//    this.ticketNo,
//    this.date,
//    this.image,
//    this.latitude,
//    this.longitude,
//    this.body,
//    this.title,
//    this.complainedBy,
//    this.status,
//  });
//}

class Request {
  int id;
  int userId;
  String date;
  int collectedBy; // Collection Center
  String paymentMode;
  String address;

  Request({
    this.id,
    this.userId,
    this.date,
    this.collectedBy,
    this.paymentMode,
    this.address,
  });
}
