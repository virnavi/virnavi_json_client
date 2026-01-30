// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_list_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoListResponse _$PhotoListResponseFromJson(Map<String, dynamic> json) =>
    PhotoListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => PhotoData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PhotoListResponseToJson(PhotoListResponse instance) =>
    <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
