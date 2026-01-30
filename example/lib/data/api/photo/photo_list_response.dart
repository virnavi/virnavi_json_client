part of 'photo_list_api.dart';

@JsonSerializable(explicitToJson: true)
class PhotoListResponse extends BaseJson {
  @JsonKey(name: "data")
  final List<PhotoData> data;

  PhotoListResponse({required this.data});

  factory PhotoListResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotoListResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PhotoListResponseToJson(this);
}
