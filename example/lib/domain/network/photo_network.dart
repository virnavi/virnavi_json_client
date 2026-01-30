import 'package:example/data/api/base/model/models.dart';
import 'package:example/domain/models/models.dart';
import 'package:virnavi_common_sdk/virnavi_common_sdk.dart';

abstract class PhotoNetwork {
  Future<Either<FailureModel, List<PhotoModel>>> getList();
}
