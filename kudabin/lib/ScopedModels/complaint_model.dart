import 'package:kudabin/models/models.dart';
import 'package:scoped_model/scoped_model.dart';

class ComplaintModel extends Model {
  List<Complaint> _allComplaints = [];

  List<Complaint> get allComplaints {
    return List.from(_allComplaints);
  }

  void fetchAllComplaints() {
    _allComplaints.add(
      Complaint(
        ticketNo: 'REF0000001',
        date: '02/01/2019',
        body:
            "This is very pathetic that the garbage is thrown like this. Please do something.",
        image: "assets/garbage.jpg",
        latitude: 28.5355,
        longitude: 77.3910,
        title: 'Sewage in Noida',
        status: 'P',
      ),
    );
    _allComplaints.add(
      Complaint(
        ticketNo: 'REF0000002',
        date: '02/01/2019',
        body:
            "This is very pathetic that the garbage is thrown like this. Please do something.",
        image: "assets/garbage.jpg",
        latitude: 28.5355,
        longitude: 77.3910,
        title: 'Sewage in Noida',
        status: 'R',
      ),
    );
  }

  void addComplaint(Complaint complain) {}
}
