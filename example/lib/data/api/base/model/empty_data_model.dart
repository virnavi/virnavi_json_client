part of 'models.dart';

@JsonSerializable()
class EmptyDataModel extends BaseJson {
  EmptyDataModel();

  factory EmptyDataModel.fromJson(Map<String, dynamic> json) =>
      _$EmptyDataModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmptyDataModelToJson(this);
}
