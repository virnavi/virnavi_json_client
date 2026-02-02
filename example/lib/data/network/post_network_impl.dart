import 'package:example/data/api/base/model/models.dart';
import 'package:example/domain/models/models.dart';
import 'package:example/domain/network/post_network.dart';
import 'package:virnavi_common_sdk/virnavi_common_sdk.dart';

import '../api/photo/post_list_api.dart';

class PostNetworkImpl implements PostNetwork {
  final PostListApi _api;

  PostNetworkImpl(this._api);
  @override
  Future<Either<FailureModel, List<PostModel>>> getList() {
    return _api.call();
  }
}
