import 'package:example/data/api/base/model/models.dart';
import 'package:example/domain/models/models.dart';
import 'package:example/domain/network/photo_network.dart';
import 'package:virnavi_common_sdk/virnavi_common_sdk.dart';

import '../api/photo/photo_list_api.dart';

class PhotoNetworkImpl implements PhotoNetwork {
  final PhotoListApi _api;

  PhotoNetworkImpl(this._api);
  @override
  Future<Either<FailureModel, List<PhotoModel>>> getList() {
    return _api.call();
  }
}
