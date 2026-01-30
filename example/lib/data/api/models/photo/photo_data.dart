part of 'models.dart';

@JsonSerializable()
class PhotoData {
  @JsonKey(name: "albumId")
  int albumId;
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "url")
  String url;
  @JsonKey(name: "thumbnailUrl")
  String thumbnailUrl;

  PhotoData({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  PhotoModel toModel() {
    return PhotoModel(
      albumId: albumId,
      id: id,
      title: title,
      url: url,
      thumbnailUrl: thumbnailUrl,
    );
  }

  factory PhotoData.fromJson(Map<String, dynamic> json) =>
      _$PhotoDataFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoDataToJson(this);
}
