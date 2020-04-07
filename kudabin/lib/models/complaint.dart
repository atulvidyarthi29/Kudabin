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
  });
}
