part of 'models.dart';

@JsonSerializable(explicitToJson: true)
class FailureModel {
  @JsonKey(defaultValue: 'unknown')
  String code;
  @JsonKey(defaultValue: '')
  String message;
  FailureModel({
    required this.code,
    required this.message,
  });

  factory FailureModel.empty() => FailureModel(code: '', message: '');
  factory FailureModel.generic() => FailureModel(code: '', message: 'Something went wrong');

  factory FailureModel.fromJson(Map<String, dynamic> json) =>
      _$FailureModelFromJson(json);
  Map<String, dynamic> toJson() => _$FailureModelToJson(this);
}
