import 'dart:convert';

import 'package:example/data/api/api_endpoints.dart';
import 'package:example/data/api/base/base_object_api.dart';
import 'package:example/data/api/base/model/models.dart';
import 'package:example/data/api/models/photo/models.dart';
import 'package:example/domain/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:virnavi_common_sdk/virnavi_common_sdk.dart';
import 'package:virnavi_json_client/virnavi_json_client.dart';

part 'post_list_api.g.dart';
part 'post_list_response.dart';

class PostListApi extends BaseJsonObjectApi<EmptyDataModel, PostListResponse> {
  PostListApi() : super(path: ApiEndpoints.posts, method: ApiMethod.get);

  Future<Either<FailureModel, List<PostModel>>> call() async {
    final response = await apiCall(req: EmptyDataModel());
    return response.fold(
      (failure) => Left(failure.toModel()),
      (result) => Right(result.data.map((e) => e.toModel()).toList()),
    );
  }

  @override
  PostListResponse convertResponse(Map<String, dynamic> json) {
    return PostListResponse.fromJson(json);
  }

  @override
  Map<String, dynamic> onTransformRawData(String? jsonString, Response? _) {
    final decoded = jsonString != null ? jsonDecode(jsonString) : [];
    return {"data": decoded};
  }
}
