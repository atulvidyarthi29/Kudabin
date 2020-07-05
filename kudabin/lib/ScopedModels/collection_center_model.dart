import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';

class CollectionCenterModel extends Model {
  List<CollectionCenter> colCenters = [];

  List<CollectionCenter> get collectionCenters {
    return List.from(colCenters);
  }

  void fetchCenter() {
    colCenters.add(CollectionCenter(
      id: 1,
      tag: 'Patna',
      latitude: 25.5941,
      longitude: 85.1376,
      description: "Something",
    ));
    colCenters.add(CollectionCenter(
      id: 2,
      tag: 'Delhi',
      latitude: 28.7041,
      longitude: 77.1025,
      description: "Something",
    ));
    colCenters.add(CollectionCenter(
      id: 3,
      tag: 'Lucknow',
      latitude: 26.8467,
      longitude: 80.9462,
      description: "Something",
    ));
    colCenters.add(CollectionCenter(
      id: 4,
      tag: 'Darbhanga',
      latitude: 26.1542,
      longitude: 85.8918,
      description: "Something",
    ));
    colCenters.add(CollectionCenter(
      id: 5,
      tag: 'Kanpur',
      latitude: 26.4499,
      longitude: 80.3319,
      description: "Something",
    ));
    colCenters.add(CollectionCenter(
      id: 6,
      tag: 'Ahemdabad',
      latitude: 23.0225,
      longitude: 72.5714,
      description: "Something",
    ));
    colCenters.add(CollectionCenter(
      id: 7,
      tag: 'Rachi',
      latitude: 23.3441,
      longitude: 85.3096,
      description: "Something",
    ));
    colCenters.add(CollectionCenter(
      id: 8,
      tag: 'Indore',
      latitude: 22.7196,
      longitude: 75.8577,
      description: "Something",
    ));
    colCenters.add(CollectionCenter(
      id: 9,
      tag: 'Gaya',
      latitude: 24.7914,
      longitude: 85.0002,
      description: "Something",
    ));
  }

  void addCenter() {}

  void removeCenter() {}
}
