part of 'models.dart';

@JsonSerializable()
class MetaData {
  @JsonKey()
  final MessageData? info;
  @JsonKey()
  final PageMetaData? page;

  MetaData({
    this.info,
    this.page,
  });

  Map<String, dynamic> toJson() => _$MetaDataToJson(this);

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);

}
