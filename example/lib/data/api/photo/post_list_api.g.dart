// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_list_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostListResponse _$PostListResponseFromJson(Map<String, dynamic> json) =>
    PostListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => PostData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostListResponseToJson(PostListResponse instance) =>
    <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
