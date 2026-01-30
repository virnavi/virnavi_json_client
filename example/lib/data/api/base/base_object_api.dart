import 'dart:convert';
import 'dart:io';

import 'package:example/data/api/base/model/models.dart';
import 'package:flutter/foundation.dart';
import 'package:virnavi_common_sdk/virnavi_common_sdk.dart';
import 'package:virnavi_json_client/virnavi_json_client.dart';

abstract class BaseJsonObjectApi<Req extends BaseJson, Res> {
  final String path;
  final ApiMethod method;
  final bool sendToken;

  BaseHttpJsonObjectClient? _client;

  BaseHttpJsonObjectClient get client {
    _client ??= BaseHttpJsonObjectClient(
      baseUrl: "https://jsonplaceholder.typicode.com/",
      options: BaseHttpJsonObjectClientOptions(),
      onTransformRawData: onTransformRawData,
      onStatusCodeTransform: onStatusCodeTransform,
    );

    return _client!;
  }

  Future<Map<String, String?>> get defaultHeaders async {
    final headers = {
      'cache-control': 'no-cache',
      'Content-Type': 'application/json',
    };
    if (kIsWeb) {
      headers.addAll({"platform": "Web"});
    } else {
      if (Platform.isAndroid) {
        headers.addAll({"platform": "Android"});
      } else if (Platform.isIOS) {
        headers.addAll({"platform": "IOS"});
      } else if (Platform.isMacOS) {
        headers.addAll({"platform": "MacOS"});
      } else if (Platform.isWindows) {
        headers.addAll({"platform": "Windows"});
      } else {
        headers.addAll({"platform": "Unknown"});
      }
    }

    return headers;
  }

  BaseJsonObjectApi({
    required this.path,
    required this.method,
    this.sendToken = true,
  });

  Future<Either<ApiFailureResponse, Res>> apiCall({
    Map<String, String?>? headers,
    Map<String, dynamic>? pathParams,
    required Req req,
    bool stopRefreshToken = false,
    String? correlationId,
  }) async {
    var newPath = path;
    for (final key in pathParams?.keys.toList() ?? []) {
      newPath = newPath.replaceAll('{$key}', pathParams?[key] ?? '');
    }
    final newHeaders = <String, String?>{};
    newHeaders.addAll(await defaultHeaders);
    if (method == ApiMethod.formData) {
      newHeaders.addAll({'Content-Type': 'multipart/form-data'});
    }
    newHeaders.addAll(headers ?? {});
    dynamic request = req;
    if (method == ApiMethod.formData) {
      if (req is! BaseFormData) {
        throw Exception("To use formData provide BaseFormData as request");
      }
      final newReq = req as BaseFormData;
      request = await newReq.toFormData();
    }

    final m = method == ApiMethod.formData ? ApiMethod.post : method;

    final result = await client.call<dynamic, Res, ApiFailureResponse>(
      path: newPath,
      method: m,
      pathParams: pathParams,
      req: request,
      headers: newHeaders,
      convertSuccess: convertResponse,
      convertError: _convertErrorResponse,
    );
    if (result.isSuccess) {
      return Right(result.response as Res);
    } else if (result.isError) {
      return Left(result.errorResponse!);
    }
    return Left(_convertFromException(result.exception));
  }

  Res convertResponse(Map<String, dynamic> json);

  ApiFailureResponse _convertErrorResponse(dynamic data) {
    return ApiFailureResponse.fromJson(data);
  }

  ApiFailureResponse _convertFromException(Exception? data) {
    if (data is DioException) {
      if (data.type == DioExceptionType.connectionTimeout) {
        return ApiFailureResponse(
          status: 400,
          meta: MetaData(
            info: MessageData(
              code: "400",
              message:
                  "The connection took too long to respond. Please check your internet connection and try again.",
              params: [],
            ),
          ),
        );
      }
      if (data.type == DioExceptionType.unknown ||
          data.error is SocketException) {
        return ApiFailureResponse(
          status: 400,
          meta: MetaData(
            info: MessageData(
              code: "400",
              message:
                  "We’re having trouble connecting to our servers. Check your network or contact support if this continues.",
              params: [],
            ),
          ),
        );
      }
    }
    return ApiFailureResponse.fromException(data!);
  }

  Map<String, dynamic> onTransformRawData(
    String? jsonString,
    Response<dynamic>? _,
  ) {
    return json.decode(
      jsonString == null
          ? '{}'
          : jsonString.isEmpty
          ? '{}'
          : jsonString,
    );
  }

  int onStatusCodeTransform(Map<String, dynamic> data, Response? response) {
    if (data['isSuccess'] == false) {
      return 400;
    } else {
      return response?.statusCode ?? 400;
    }
  }
}
