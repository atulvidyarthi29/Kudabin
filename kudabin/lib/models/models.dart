class Users {
  String username;
  String email;
  String firstName;
  String lastName;
  String dob;
  String gender;
  String password;
  String mobileNo;
  String address;
  String aadharNo;
  String profilePic;
  String userType;

  Users({
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

class CollectionCenter {
  int id;
  String tag;
  double latitude;
  double longitude;
  String description;

  CollectionCenter({
    this.tag,
    this.id,
    this.latitude,
    this.longitude,
    this.description,
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

class Complaint {
  int id;
  String ticketNo;
  String date;
  String image;
  double latitude;
  double longitude;
  String body;
  String title;
  int complainedBy;
  String status;

  Complaint({
    this.id,
    this.ticketNo,
    this.date,
    this.image,
    this.latitude,
    this.longitude,
    this.body,
    this.title,
    this.complainedBy,
    this.status,
  });
}

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
