import 'package:kudabin/ScopedModels/collection_center_model.dart';
import 'package:kudabin/ScopedModels/complaint_model.dart';
import 'package:kudabin/ScopedModels/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with CollectionCenterModel, UserModel, ComplaintModel {}
