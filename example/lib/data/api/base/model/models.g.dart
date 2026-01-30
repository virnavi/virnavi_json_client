// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageData _$MessageDataFromJson(Map<String, dynamic> json) => MessageData(
  code: json['code'] as String? ?? '',
  message: json['message'] as String? ?? '',
  params:
      (json['params'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$MessageDataToJson(MessageData instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'params': instance.params,
    };

FailureModel _$FailureModelFromJson(Map<String, dynamic> json) => FailureModel(
  code: json['code'] as String? ?? 'unknown',
  message: json['message'] as String? ?? '',
);

Map<String, dynamic> _$FailureModelToJson(FailureModel instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};

MetaData _$MetaDataFromJson(Map<String, dynamic> json) => MetaData(
  info: json['info'] == null
      ? null
      : MessageData.fromJson(json['info'] as Map<String, dynamic>),
  page: json['page'] == null
      ? null
      : PageMetaData.fromJson(json['page'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MetaDataToJson(MetaData instance) => <String, dynamic>{
  'info': instance.info,
  'page': instance.page,
};

PageMetaData _$PageMetaDataFromJson(Map<String, dynamic> json) => PageMetaData(
  current: (json['current'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$PageMetaDataToJson(PageMetaData instance) =>
    <String, dynamic>{
      'current': instance.current,
      'limit': instance.limit,
      'total': instance.total,
    };

ApiFailureResponse _$ApiFailureResponseFromJson(Map<String, dynamic> json) =>
    ApiFailureResponse(
      status: (json['status'] as num?)?.toInt() ?? 400,
      meta: json['meta'] == null
          ? null
          : MetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiFailureResponseToJson(ApiFailureResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'meta': instance.meta?.toJson(),
    };

EmptyDataModel _$EmptyDataModelFromJson(Map<String, dynamic> json) =>
    EmptyDataModel();

Map<String, dynamic> _$EmptyDataModelToJson(EmptyDataModel instance) =>
    <String, dynamic>{};
