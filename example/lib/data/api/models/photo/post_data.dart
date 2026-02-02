part of 'models.dart';

@JsonSerializable()
class PostData {
  @JsonKey(name: "userId")
  int userId;
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "body")
  String body;

  PostData({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  PostModel toModel() {
    return PostModel(userId: userId, id: id, title: title, body: body);
  }

  factory PostData.fromJson(Map<String, dynamic> json) =>
      _$PostDataFromJson(json);

  Map<String, dynamic> toJson() => _$PostDataToJson(this);
}
