part of 'models.dart';

@JsonSerializable()
class PageMetaData {
  @JsonKey()
  final int current;
  @JsonKey()
  final int limit;
  @JsonKey()
  final int total;

  PageMetaData({
    required this.current,
    required this.limit,
    required this.total,
  });

  Map<String, dynamic> toJson() => _$PageMetaDataToJson(this);

  factory PageMetaData.fromJson(Map<String, dynamic> json) =>
      _$PageMetaDataFromJson(json);
}
