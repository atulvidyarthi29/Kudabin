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
