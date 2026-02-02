part of 'post_list_api.dart';

@JsonSerializable(explicitToJson: true)
class PostListResponse extends BaseJson {
  @JsonKey(name: "data")
  final List<PostData> data;

  PostListResponse({required this.data});

  factory PostListResponse.fromJson(Map<String, dynamic> json) =>
      _$PostListResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PostListResponseToJson(this);
}
