part of 'models.dart';

@JsonSerializable(explicitToJson: true)
class ApiFailureResponse {
  @JsonKey(defaultValue: 400)
  int status;
  @JsonKey()
  MetaData? meta;

  ApiFailureResponse({
    required this.status,
    required this.meta,
  });

  FailureModel toModel() {
    return FailureModel(
      code: meta?.info?.code ?? "Unknown",
      message:
          meta?.info?.message ?? 'Something went wrong. Please try again later',
    );
  }

  factory ApiFailureResponse.empty() => ApiFailureResponse(
        status: 400,
        meta: MetaData(
            info: MessageData(
          code: 'badRequest',
          message: '',
          params: [],
        )),
      );

  factory ApiFailureResponse.fromException(Exception e) => ApiFailureResponse(
        status: 400,
        meta: MetaData(
          info: MessageData(
            code: 'internalError',
            message: e.toString(),
            params: [],
          ),
        ),
      );

  factory ApiFailureResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiFailureResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiFailureResponseToJson(this);
}
