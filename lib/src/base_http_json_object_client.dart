part of 'http_client.dart';

class BaseHttpJsonObjectClient {
  static String tag = '';
  final String baseUrl;
  final BaseHttpJsonObjectClientOptions options;
  final Map<String, dynamic> Function(String data, Response? response)?
  onTransformRawData;
  final int Function(Map<String, dynamic> data, Response? response)?
  onStatusCodeTransform;

  Dio? _client;

  Dio get client => _client ??= Dio(
    BaseOptions(
      connectTimeout: options.connectTimeout,
      receiveTimeout: options.receiveTimeout,
      sendTimeout: options.sendTimeout,
      responseType: options.responseType,
    ),
  );

  BaseHttpJsonObjectClient({
    required this.baseUrl,
    required this.options,
    this.onTransformRawData,
    this.onStatusCodeTransform,
  });

  Future<ApiResponse<Res, ErrorRes>> call<Data, Res, ErrorRes>({
    required String path,
    required ApiMethod method,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? headers,
    Data? req,
    required Res Function(Map<String, dynamic> data) convertSuccess,
    required ErrorRes Function(Map<String, dynamic> data) convertError,
    String? correlationId,
  }) async {
    try {
      final response = await _callMethod<Data, Res, ErrorRes>(
        path: path,
        method: method,
        headers: headers,
        pathParams: pathParams,
        req: req,
        correlationId: correlationId,
      );

      final statusCode = response.statusCode ?? 0;
      Logger.shared.log(
        'status code: $statusCode',
        tag: tag,
        correlationId: correlationId,
      );
      if (response.data != null) {
        if (200 <= statusCode && statusCode < 300) {
          return ApiResponse<Res, ErrorRes>(
            code: statusCode,
            response: convertSuccess(response.data ?? {}),
          );
        } else {
          return ApiResponse<Res, ErrorRes>(
            code: statusCode,
            errorResponse: convertError(response.data ?? {}),
          );
        }
      }
    } on DioException catch (e) {
      log('$correlationId    exception: ${e.toString()}');
      final rawData = e.response?.data;
      final errorBody = _tryDecodeErrorBody(rawData, e.response, onTransformRawData);
      if (errorBody != null) {
        Logger.shared.log(
          'error status code: ${e.response?.statusCode ?? -1}',
          tag: tag,
          correlationId: correlationId,
        );
        return ApiResponse<Res, ErrorRes>(
          code: e.response?.statusCode ?? -1,
          errorResponse: convertError(errorBody),
        );
      } else {
        return ApiResponse<Res, ErrorRes>(code: -1, exception: e);
      }
    } on Exception catch (e) {
      log('$correlationId    exception: ${e.toString()}');
      return ApiResponse<Res, ErrorRes>(code: -1, exception: e);
    }

    log('$correlationId    error: Unexpected Error');
    return ApiResponse<Res, ErrorRes>(
      code: -1,
      exception: Exception('Unexpected Error'),
    );
  }

  Future<Response<Map<String, dynamic>>> _callMethod<Data, Res, ErrorRes>({
    required String path,
    required ApiMethod method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? pathParams,
    Data? req,
    String? correlationId,
  }) {
    var newPath = path;
    if (pathParams != null) {
      for (final key in pathParams.keys) {
        newPath = newPath.replaceAll('{$key}', pathParams[key].toString());
      }
    }

    Logger.shared.log(
      'calling: ${baseUrl + newPath}',
      tag: tag,
      correlationId: correlationId,
    );
    Logger.shared.log(
      'with base url: $baseUrl',
      tag: tag,
      correlationId: correlationId,
    );
    Logger.shared.log(
      'with path: $newPath',
      tag: tag,
      correlationId: correlationId,
    );
    Logger.shared.log(
      ' with headers: ${headers.toString()}',
      tag: tag,
      correlationId: correlationId,
    );

    if (req is BaseJson) {
      Logger.shared.log(
        ' with data 1: ${req.toJson().toString()}',
        tag: tag,
        correlationId: correlationId,
      );
    } else {
      Logger.shared.log(
        ' with data 2: ${req?.toString()}',
        tag: tag,
        correlationId: correlationId,
      );
    }
    Logger.shared.log(
      ' method: ${method.toString()}',
      tag: tag,
      correlationId: correlationId,
    );
    if (method == ApiMethod.post || method == ApiMethod.formData) {
      return _post(path: newPath, headers: headers, req: req);
    } else if (method == ApiMethod.put) {
      return _put(path: newPath, headers: headers, req: req);
    } else if (method == ApiMethod.patch) {
      return _patch(path: newPath, headers: headers, req: req);
    } else if (method == ApiMethod.delete) {
      return _delete(path: newPath, headers: headers, req: req);
    }
    final queryParams = (req is BaseJson) ? req.toJson() : null;
    return _get(path: newPath, headers: headers, req: queryParams);
  }

  Future<Response<Map<String, dynamic>>> _get({
    required String path,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? req,
  }) async {
    return convertRawResponse(
      await client.get<String>(
        baseUrl + path,
        queryParameters: req,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Response<Map<String, dynamic>>> _post<Data, Res, ErrorRes>({
    required String path,
    Map<String, dynamic>? headers,
    Data? req,
  }) async {
    final res = await client.post<String>(
      baseUrl + path,
      data: req,
      options: Options(headers: headers),
    );
    return convertRawResponse(res);
  }

  Future<Response<Map<String, dynamic>>> _put<Data, Res, ErrorRes>({
    required String path,
    Map<String, dynamic>? headers,
    Data? req,
  }) async {
    return convertRawResponse(
      await client.put<String>(
        baseUrl + path,
        data: req,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Response<Map<String, dynamic>>> _patch<Data, Res, ErrorRes>({
    required String path,
    Map<String, dynamic>? headers,
    Data? req,
  }) async {
    return convertRawResponse(
      await client.patch<String>(
        baseUrl + path,
        data: req,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Response<Map<String, dynamic>>> _delete<Data, Res, ErrorRes>({
    required String path,
    Data? req,
    Map<String, dynamic>? headers,
  }) async {
    return convertRawResponse(
      await client.delete<String>(
        baseUrl + path,
        queryParameters: (req is BaseJson) ? req.toJson() : {},
        options: Options(headers: headers),
      ),
    );
  }

  Response<Map<String, dynamic>> convertRawResponse(Response<String> res) {
    final data =
        onTransformRawData?.call(res.data ?? '', res) ??
        _decodeJsonObject(res.data ?? '');
    return Response(
      requestOptions: res.requestOptions,
      statusCode: onStatusCodeTransform?.call(data, res) ?? res.statusCode,
      statusMessage: res.statusMessage,
      isRedirect: res.isRedirect,
      redirects: res.redirects,
      extra: res.extra,
      headers: res.headers,
      data: data,
    );
  }
}

/// Decodes a raw response body into a JSON object.
///
/// An empty (or whitespace-only) body decodes to an empty map so that a
/// legitimate `204 No Content` or empty `200` response is not treated as a
/// failure. A body that parses to something other than a JSON object throws a
/// [FormatException] — a *catchable* [Exception] — instead of letting a
/// `TypeError` escape when the value is later used as a `Map`.
Map<String, dynamic> _decodeJsonObject(String raw) {
  if (raw.trim().isEmpty) return <String, dynamic>{};
  return _asJsonObject(json.decode(raw));
}

/// Coerces an already-decoded JSON value into a `Map<String, dynamic>`,
/// throwing a [FormatException] if it is not a JSON object.
Map<String, dynamic> _asJsonObject(dynamic decoded) {
  if (decoded is Map<String, dynamic>) return decoded;
  if (decoded is Map) {
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }
  throw FormatException(
    'Expected a JSON object but received ${decoded.runtimeType}',
  );
}

/// Best-effort decode of a Dio error-response body into a JSON object.
///
/// Returns `null` (rather than throwing) when the body is absent or cannot be
/// interpreted as a JSON object, so the caller can fall back to reporting the
/// underlying exception. Never throws — safe to call from inside a `catch`.
Map<String, dynamic>? _tryDecodeErrorBody(
  dynamic rawData,
  Response? response,
  Map<String, dynamic> Function(String data, Response? response)?
  onTransformRawData,
) {
  if (rawData == null) return null;
  try {
    if (onTransformRawData != null) {
      return onTransformRawData(rawData.toString(), response);
    }
    if (rawData is String) return _decodeJsonObject(rawData);
    if (rawData is Map) return _asJsonObject(rawData);
  } catch (_) {
    return null;
  }
  return null;
}
