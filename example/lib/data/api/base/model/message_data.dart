part of 'models.dart';

@JsonSerializable()
class MessageData {
  @JsonKey(defaultValue:'')
  final String code;
  @JsonKey(defaultValue:'')
  final String message;
  @JsonKey(defaultValue: [])
  final List<String> params;

  MessageData({
    required this.code,
    required this.message,
    required this.params,
  });

  Map<String, dynamic> toJson() => _$MessageDataToJson(this);

  factory MessageData.fromJson(Map<String, dynamic> json) =>
      _$MessageDataFromJson(json);
}
