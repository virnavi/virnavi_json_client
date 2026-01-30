# 🛠️ virnavi_json_client

A **generic HTTP JSON client wrapper** that simplifies REST API interactions in Flutter applications with type-safe request/response handling and built-in streaming support.

This package provides a robust abstraction layer over Dio, offering generic HTTP clients with built-in support for JSON serialization, error handling, and reactive data streaming. It handles the boilerplate of HTTP transactions, response parsing, and automatic retries.

## ✨ Features

✅ **BaseHttpJsonObjectClient** — Generic HTTP client for standard API calls (GET, POST, PUT, DELETE)  
✅ **BaseHttpJsonChunkObjectClient** — Streaming client for chunked responses (SSE, streaming APIs)  
✅ **Type-Safe Responses** — Automatic conversion between request/response models with compile-time safety  
✅ **ApiResponse Wrapper** — Structured response handling with success/error/exception states  
✅ **BaseJson Abstraction** — Enforced JSON serialization contract for all request/response models  
✅ **FormData Support** — Built-in support for multipart file uploads via `BaseFormData`  
✅ **Logging Integration** — Automatic request/response logging with correlation IDs via `virnavi_common_sdk`  
✅ **Flexible Response Transformation** — Custom parsers for non-standard API responses  

## 🚀 Usage

### 1. Create the Base HTTP Client

Create a project-specific abstract class to wrap `BaseHttpJsonObjectClient`. This gives you full control over configuration and enables features like **FormData** support and centralized error handling.

Copy this base class into your project:

```dart
import 'dart:io';
import 'package:virnavi_json_client/virnavi_json_client.dart';
import 'package:dartz/dartz.dart'; 
import 'package:flutter/foundation.dart';

abstract class BaseApi<Req extends BaseJson, Res> {
  final String path;
  final ApiMethod method;
  final bool sendToken;

  BaseHttpJsonObjectClient? _client;

  // 1. Configure the inner client
  BaseHttpJsonObjectClient get client {
    return _client ??= BaseHttpJsonObjectClient(
      baseUrl: "https://api.example.com",
      options: BaseHttpJsonObjectClientOptions(
        connectTimeout: const Duration(seconds: 30),
      ),
      onTransformRawData: (data, response) {
        final json = jsonDecode(data);
        return json['data'] ?? json;
      },
    );
  }

  BaseApi({
    required this.path,
    required this.method,
    this.sendToken = true,
  });

  // 2. Define default headers (Auth, Platform, etc.)
  Future<Map<String, String?>> get defaultHeaders async {
    final headers = <String, String?>{
      'Content-Type': 'application/json',
    };
    if (sendToken) {
     // headers['Authorization'] = 'Bearer $token'; 
    }
    return headers;
  }

  // 3. The main call method pattern
  Future<Either<ApiFailureResponse, Res>> call({
    required Req req,
    Map<String, String?>? headers,
    Map<String, dynamic>? pathParams,
  }) async {
    // A. Substitution for Path Params (e.g. /users/{id})
    var newPath = path;
    for (final key in pathParams?.keys.toList() ?? []) {
      newPath = newPath.replaceAll('{$key}', pathParams?[key].toString() ?? '');
    }

    // B. Header Merging
    final newHeaders = <String, String?>{};
    newHeaders.addAll(await defaultHeaders);
    if (method == ApiMethod.formData) {
      newHeaders.addAll({'Content-Type': 'multipart/form-data'});
    }
    newHeaders.addAll(headers ?? {});

    // C. FormData Handling
    dynamic request = req;
    if (method == ApiMethod.formData) {
      if (req is! BaseFormData) {
        throw Exception("For ApiMethod.formData, request must extend BaseFormData");
      }
      request = await (req as BaseFormData).toFormData();
    }

    // D. Execution
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

  // Abstract methods for implementation
  Res convertResponse(Map<String, dynamic> json);

  ApiFailureResponse _convertErrorResponse(dynamic data) => 
      ApiFailureResponse.fromJson(data);

  ApiFailureResponse _convertFromException(Exception? e) {
    if (e is DioException) {
      // Handle timeouts, no internet, etc.
      return ApiFailureResponse(status: 400, message: "Network Error: ${e.message}");
    }
    return ApiFailureResponse.fromException(e!);
  }
}
```

### 2. Define your Request Model

Extend `BaseJson` to create type-safe request models with JSON serialization.

```dart
import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest extends BaseJson {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  @override
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
```

### 3. Define your Response Models

Create pure Dart models for success and error responses.

```dart
@JsonSerializable()
class LoginResponse {
  final String token;
  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}
```

### 4. Create an API Service

Extend your `BaseApi` to create a concrete service for a specific endpoint.

```dart
class LoginApi extends BaseApi<LoginRequest, LoginResponse> {
  LoginApi() : super(path: '/auth/login', method: ApiMethod.post);

  @override
  LoginResponse convertResponse(Map<String, dynamic> json) {
    return LoginResponse.fromJson(json);
  }
}
```

### 5. Call the API

Use your concrete API service to make requests.

```dart
void main() async {
  final loginApi = LoginApi();

  final result = await loginApi.call(
    req: LoginRequest(email: 'user@example.com', password: 'password123'),
  );

  result.fold(
    (failure) {
      print('Error: ${failure.message}');
    },
    (response) {
      print('Success! Token: ${response.token}');
    },
  );
}
```

### 6. Streaming API Calls

For Server-Sent Events (SSE) or chunked responses, create a `BaseStreamApi` similar to `BaseApi`.

```dart
abstract class BaseStreamApi<Req extends BaseJson, Res> {
  final String path;
  final ApiMethod method;
  final bool sendToken;

  BaseHttpJsonChunkObjectClient? _client;

  BaseHttpJsonChunkObjectClient get client {
    return _client ??= BaseHttpJsonChunkObjectClient(
      baseUrl: "https://api.example.com",
      options: BaseHttpJsonObjectClientOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 5), // Longer timeout for streams
      ),
      onTransformRawData: (data, response) {
         // Transform chunk data if needed
         return jsonDecode(data);
      }
    );
  }

  BaseStreamApi({
    required this.path,
    required this.method,
    this.sendToken = true,
  });

  Stream<ApiResponse<Res, ApiError>> call({
    required Req req,
    Map<String, String?>? headers,
  }) async* {
    // Merge headers similar to BaseApi
    final finalHeaders = <String, String?>{}; 
    if (sendToken) {
       // finalHeaders['Authorization'] = 'Bearer $token';
    }
    finalHeaders.addAll(headers ?? {});

    yield* client.call<Req, Res, ApiError>(
      path: path,
      method: method,
      req: req,
      headers: finalHeaders,
      convertSuccess: (json) => LoginResponse.fromJson(json) as Res, // Adjust casting
      convertError: (json) => ApiError.fromJson(json),
    );
  }
}
```

**Usage:**

```dart
class ChatStreamApi extends BaseStreamApi<ChatRequest, ChatMessage> {
  ChatStreamApi() : super(path: '/chat/stream', method: ApiMethod.post);
}

// In your code:
final chatApi = ChatStreamApi();
chatApi.call(req: request).listen((response) {
  if (response.isSuccess) {
    print("Chunk: ${response.response?.content}");
  }
});
```

### 7. File Upload with FormData

Since your `BaseApi` (Step 1) handles `ApiMethod.formData` conversion logic automatically, uploading files is simple.

1. **Define the Request** (must extend `BaseFormData`):
```dart
class UploadImageRequest extends BaseFormData {
  final File file;
  UploadImageRequest(this.file);

  @override
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
  }

  @override
  Map<String, dynamic> toJson() => {}; // unused
}
```

2. **Define the API**:
```dart
class UploadApi extends BaseApi<UploadImageRequest, UploadResponse> {
  UploadApi() : super(path: '/upload', method: ApiMethod.formData);

  @override
  UploadResponse convertResponse(Map<String, dynamic> json) => 
      UploadResponse.fromJson(json);
}
```

3. **Call it**:
```dart
await UploadApi().call(req: UploadImageRequest(myFile));
```

### 8. Path Parameters

Support for dynamic path parameters using placeholders.

```dart
Future<ApiResponse<User, ApiError>> getUserById({
  required String userId,
}) async {
  final request = EmptyRequest(); // Or use null if no body needed

  return await _client.call<EmptyRequest, User, ApiError>(
    path: '/users/{userId}',
    method: ApiMethod.get,
    pathParams: {'userId': userId}, // Will replace {userId} in path
    req: request,
    headers: {'Authorization': 'Bearer $token'},
    convertSuccess: (json) => User.fromJson(json),
    convertError: (json) => ApiError.fromJson(json),
  );
}
```

## 🧠 How It Works

- **Type Safety**: The package uses Flutter's generic type system to ensure:
  - Request models extend `BaseJson` for consistent serialization
  - Response converters are type-checked at compile time
  - Success and error responses are strongly typed
  
- **HTTP Methods**: `BaseHttpJsonObjectClient` supports all standard REST methods:
  - **GET**: Query parameters from `BaseJson.toJson()`
  - **POST**: Request body from `BaseJson.toJson()` or `FormData`
  - **PUT**: Request body from `BaseJson.toJson()`
  - **DELETE**: Query parameters from `BaseJson.toJson()`
  
- **Response Handling**: All responses are wrapped in `ApiResponse<SuccessType, ErrorType>`:
  - `isSuccess` — HTTP 2xx responses with parsed `response` object
  - `isError` — HTTP error responses (4xx, 5xx) with parsed `errorResponse` object
  - `isException` — Network errors, timeouts, or parsing failures with `exception` object
  
- **Streaming Support**: `BaseHttpJsonChunkObjectClient` provides:
  - Line-by-line or chunk-by-chunk response streaming
  - Automatic JSON parsing per chunk
  - Same error handling as standard client
  - Ideal for SSE, WebSocket-like APIs, or large file downloads
  
- **Logging**: Integrated with `virnavi_common_sdk` Logger:
  - Automatic request/response logging
  - Correlation IDs for request tracing
  - Configurable log tags per client instance
  
- **Flexible Parsing**: Custom transformers allow you to:
  - Unwrap nested response structures (`data.result.items`)
  - Handle non-standard HTTP status codes in response bodies
  - Pre-process raw response strings before JSON parsing

- **Error Recovery**: Built-in DioException handling:
  - Network timeouts with automatic error responses
  - Connection failures with exception wrapping
  - Invalid JSON responses with graceful degradation

## 🧰 Dependencies

- [dio](https://pub.dev/packages/dio) - Powerful HTTP client for Dart
- [virnavi_common_sdk](https://pub.dev/packages/virnavi_common_sdk) - Logging and utility functions

## 📋 API Reference

### BaseHttpJsonObjectClient

| Method | Description |
|--------|-------------|
| `call<Data, Res, ErrorRes>()` | Execute HTTP request with type-safe response handling |
| `client` | Access underlying Dio instance for advanced customization |

### BaseHttpJsonChunkObjectClient

| Method | Description |
|--------|-------------|
| `call<Data, Res, ErrorRes>()` | Execute streaming HTTP request returning `Stream<ApiResponse>` |
| `client` | Access underlying Dio instance configured for streaming |

### ApiResponse<R, ER>

| Property | Type | Description |
|----------|------|-------------|
| `code` | `int` | HTTP status code |
| `response` | `R?` | Success response object (only set on success) |
| `errorResponse` | `ER?` | Error response object (only set on error) |
| `exception` | `Exception?` | Exception object (only set on exception) |
| `isSuccess` | `bool` | True if 200 ≤ code < 300 |
| `isError` | `bool` | True if 0 < code and not success |
| `isException` | `bool` | True if code == -1 (exception occurred) |

### BaseJson

Abstract class requiring:
```dart
Map<String, dynamic> toJson();
```

### BaseFormData

Abstract class requiring:
```dart
Future<FormData> toFormData();
Map<String, dynamic> toJson(); // Return empty map
```

### ApiMethod

Enum values:
- `ApiMethod.get`
- `ApiMethod.post`
- `ApiMethod.put`
- `ApiMethod.delete`
- `ApiMethod.formData`

## 🔧 Advanced Configuration

### Custom Interceptors

```dart
final client = BaseHttpJsonObjectClient(
  baseUrl: baseUrl,
  options: options,
);

// Add custom interceptors to the Dio client
client.client.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      // Add auth token
      options.headers['Authorization'] = 'Bearer $token';
      return handler.next(options);
    },
    onResponse: (response, handler) {
      // Log response
      print('Response: ${response.data}');
      return handler.next(response);
    },
    onError: (error, handler) {
      // Handle specific errors
      if (error.response?.statusCode == 401) {
        // Refresh token logic
      }
      return handler.next(error);
    },
  ),
);
```

### Custom Response Transformers

```dart
// For APIs that wrap responses in a 'data' field
final client = BaseHttpJsonObjectClient(
  baseUrl: baseUrl,
  options: options,
  onTransformRawData: (rawString, response) {
    final json = jsonDecode(rawString);
    // Unwrap nested structure
    return json['data']['result'] ?? json;
  },
  onStatusCodeTransform: (parsedData, response) {
    // Use status code from response body instead of HTTP header
    return parsedData['statusCode'] ?? response?.statusCode ?? -1;
  },
);
```

## 🧑‍💻 Contributors

* **Mohammed Shakib** ([@shakib1989](https://github.com/shakib1989)) - *Main Library Development*
* **Shuvo Prosad Sarnakar** ([@shuvoprosadsarnakar](https://github.com/shuvoprosadsarnakar)) - *Extensive documentation and getting the project for pub.dev.*

## 🪪 License

This project is licensed under the **MIT License** — see the LICENSE file for details.