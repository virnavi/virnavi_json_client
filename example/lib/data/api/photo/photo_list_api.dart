import 'dart:convert';

import 'package:example/data/api/api_endpoints.dart';
import 'package:example/data/api/base/base_object_api.dart';
import 'package:example/data/api/base/model/models.dart';
import 'package:example/data/api/models/photo/models.dart';
import 'package:example/domain/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:virnavi_common_sdk/virnavi_common_sdk.dart';
import 'package:virnavi_json_client/virnavi_json_client.dart';

part 'photo_list_api.g.dart';
part 'photo_list_response.dart';

class PhotoListApi
    extends BaseJsonObjectApi<EmptyDataModel, PhotoListResponse> {
  PhotoListApi() : super(path: ApiEndpoints.photos, method: ApiMethod.get);

  Future<Either<FailureModel, List<PhotoModel>>> call() async {
    final response = await apiCall(req: EmptyDataModel());
    return response.fold(
      (failure) => Left(failure.toModel()),
      (result) => Right(result.data.map((e) => e.toModel()).toList()),
    );
  }

  @override
  PhotoListResponse convertResponse(Map<String, dynamic> json) {
    return PhotoListResponse.fromJson(json);
  }

  @override
  Map<String, dynamic> onTransformRawData(String? jsonString, Response? _) {
    final decoded = jsonString != null ? jsonDecode(jsonString) : [];
    return {"data": decoded};
  }
}
