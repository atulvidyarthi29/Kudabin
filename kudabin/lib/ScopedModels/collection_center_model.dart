import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';

class CollectionCenterModel extends Model {
  List<CollectionCenter> colCenters;

  List<CollectionCenter> get collectionCenters {
    return List.from(colCenters);
  }

  void fetchCenter() {}

  void addCenter() {}

  void removeCenter() {}
}
