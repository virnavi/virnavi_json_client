part of 'http_client.dart';

class BaseHttpJsonChunkObjectClient {
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
      responseType: ResponseType.stream,
    ),
  );

  BaseHttpJsonChunkObjectClient({
    required this.baseUrl,
    required this.options,
    this.onTransformRawData,
    this.onStatusCodeTransform,
  });

  bool _isSuccess(int statusCode) {
    return (200 <= statusCode && statusCode < 300);
  }

  Stream<ApiResponse<Res, ErrorRes>> call<Data, Res, ErrorRes>({
    required String path,
    required ApiMethod method,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? headers,
    Data? req,
    required Res Function(Map<String, dynamic> data) convertSuccess,
    required ErrorRes Function(Map<String, dynamic> data) convertError,
    String? correlationId,
  }) async* {
    try {
      final response = await _callMethod<Data, Res, ErrorRes>(
        path: path,
        method: method,
        headers: headers,
        pathParams: pathParams,
        req: req,
        correlationId: correlationId,
      );

      final responseStream = response.data?.stream;
      if (responseStream == null) {
        yield ApiResponse<Res, ErrorRes>(
          code: -1,
          exception: Exception('No response stream received'),
        );
        return;
      }

      // Decode the byte stream through utf8.decoder so multi-byte characters
      // that straddle a chunk boundary are buffered internally instead of
      // throwing. `buffer` then accumulates text across emissions so a JSON
      // object split across chunks is parsed once it is complete.
      final buffer = StringBuffer();
      await for (final piece
          in responseStream.cast<List<int>>().transform(utf8.decoder)) {
        buffer.write(piece);
        final text = buffer.toString();

        Map<String, dynamic> jsonData;
        if (onTransformRawData != null) {
          // A custom transformer owns framing/parsing; hand it the text and
          // treat any failure as a parse error rather than crashing.
          try {
            jsonData = onTransformRawData!.call(text, response);
          } catch (e) {
            buffer.clear();
            yield ApiResponse<Res, ErrorRes>(
              code: -1,
              exception: Exception('Failed to parse chunk: $e'),
            );
            continue;
          }
        } else {
          dynamic decoded;
          try {
            decoded = json.decode(text);
          } on FormatException {
            // Incomplete JSON so far — wait for more chunks to arrive.
            continue;
          }
          try {
            jsonData = _asJsonObject(decoded);
          } catch (e) {
            buffer.clear();
            yield ApiResponse<Res, ErrorRes>(
              code: -1,
              exception: Exception('Failed to parse chunk: $e'),
            );
            continue;
          }
        }
        buffer.clear();

        Logger.shared.log(
          'chunk received: $jsonData',
          tag: tag,
          correlationId: correlationId,
        );

        final statusCode =
            onStatusCodeTransform?.call(jsonData, response) ??
            response.statusCode ??
            0;

        if (_isSuccess(statusCode)) {
          yield ApiResponse<Res, ErrorRes>(
            code: statusCode,
            response: convertSuccess(jsonData),
          );
        } else {
          yield ApiResponse<Res, ErrorRes>(
            code: statusCode,
            errorResponse: convertError(jsonData),
          );
        }
      }
    } on DioException catch (e) {
      final errorBody = _tryDecodeErrorBody(
        e.response?.data,
        e.response,
        onTransformRawData,
      );
      if (errorBody != null) {
        yield ApiResponse<Res, ErrorRes>(
          code: e.response?.statusCode ?? -1,
          errorResponse: convertError(errorBody),
        );
      } else {
        yield ApiResponse<Res, ErrorRes>(
          code: -1,
          exception: e,
        );
      }
    } on Exception catch (e) {
      log('$correlationId    exception: ${e.toString()}');
      yield ApiResponse<Res, ErrorRes>(code: -1, exception: e);
    }
  }

  Future<Response<ResponseBody>> _callMethod<Data, Res, ErrorRes>({
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

    Logger.shared.log('calling: ${baseUrl + newPath}', tag: tag);
    Logger.shared.log('with headers: ${headers.toString()}', tag: tag);

    final options = Options(
      headers: headers,
      responseType: ResponseType.stream,
    );

    if (method == ApiMethod.post || method == ApiMethod.formData) {
      return client.post<ResponseBody>(
        baseUrl + newPath,
        data: req,
        options: options,
      );
    } else if (method == ApiMethod.put) {
      return client.put<ResponseBody>(
        baseUrl + newPath,
        data: req,
        options: options,
      );
    } else if (method == ApiMethod.patch) {
      return client.patch<ResponseBody>(
        baseUrl + newPath,
        data: req,
        options: options,
      );
    } else if (method == ApiMethod.delete) {
      return client.delete<ResponseBody>(
        baseUrl + newPath,
        queryParameters: (req is BaseJson) ? req.toJson() : {},
        options: options,
      );
    }
    final queryParams = (req is BaseJson) ? req.toJson() : null;
    return client.get<ResponseBody>(
      baseUrl + newPath,
      queryParameters: queryParams,
      options: options,
    );
  }
}
