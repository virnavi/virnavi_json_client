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

### 1. Define your Request Model

Extend `BaseJson` to create type-safe request models with JSON serialization.

```dart
import 'package:virnavi_json_client/virnavi_json_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest extends BaseJson {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
```

### 2. Define your Response Models

Create pure Dart models for success and error responses with JSON deserialization support.

```dart
part 'auth_models.g.dart';

// Success Response
@JsonSerializable(explicitToJson: true)
class LoginResponse {
  final String token;
  final UserProfile user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

// Error Response
@JsonSerializable()
class ApiError {
  final String message;
  final int errorCode;

  ApiError({
    required this.message,
    required this.errorCode,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}
```

### 3. Create the HTTP Client

Initialize `BaseHttpJsonObjectClient` with your API base URL and configuration options.

```dart
import 'package:virnavi_json_client/virnavi_json_client.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiClient {
  late final BaseHttpJsonObjectClient _client;

  ApiClient() {
    _client = BaseHttpJsonObjectClient(
      baseUrl: 'https://api.example.com',
      options: BaseHttpJsonObjectClientOptions(
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        sendTimeout: Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
      // Transform raw response data (optional)
      onTransformRawData: (data, response) {
        // Handle non-standard API formats
        final json = jsonDecode(data);
        return json['data'] ?? json; // Unwrap 'data' field if needed
      },
      // Transform status code (optional)
      onStatusCodeTransform: (data, response) {
        // Use custom status codes from response body
        return data['statusCode'] ?? response?.statusCode ?? -1;
      },
    );
  }

  Future<ApiResponse<LoginResponse, ApiError>> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequest(email: email, password: password);

    return await _client.call<LoginRequest, LoginResponse, ApiError>(
      path: '/auth/login',
      method: ApiMethod.post,
      req: request,
      headers: {'Content-Type': 'application/json'},
      convertSuccess: (json) => LoginResponse.fromJson(json),
      convertError: (json) => ApiError.fromJson(json),
      correlationId: 'login-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<ApiResponse<List<Product>, ApiError>> getProducts({
    required int page,
    required int limit,
  }) async {
    final request = GetProductsRequest(page: page, limit: limit);

    return await _client.call<GetProductsRequest, List<Product>, ApiError>(
      path: '/products',
      method: ApiMethod.get,
      req: request, // Will be converted to query parameters
      headers: {'Authorization': 'Bearer $token'},
      convertSuccess: (json) => (json['items'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      convertError: (json) => ApiError.fromJson(json),
    );
  }
}
```

### 4. Handle API Responses

Use the `ApiResponse` wrapper to handle success, error, and exception states.

```dart
void main() async {
  final apiClient = ApiClient();

  // Login example
  final response = await apiClient.login(
    email: 'user@example.com',
    password: 'password123',
  );

  if (response.isSuccess) {
    print('Token: ${response.response?.token}');
    print('User: ${response.response?.user.name}');
  } else if (response.isError) {
    print('API Error: ${response.errorResponse?.message}');
    print('Error Code: ${response.errorResponse?.errorCode}');
  } else if (response.isException) {
    print('Exception: ${response.exception}');
  }

  // Alternative pattern matching
  switch (response.code) {
    case >= 200 && < 300:
      // Success
      break;
    case 401:
      // Unauthorized
      break;
    case 404:
      // Not found
      break;
    default:
      // Other errors
  }
}
```

### 5. Streaming API Calls

For Server-Sent Events (SSE) or chunked responses, use `BaseHttpJsonChunkObjectClient`.

```dart
@singleton
class StreamApiClient {
  late final BaseHttpJsonChunkObjectClient _streamClient;

  StreamApiClient() {
    _streamClient = BaseHttpJsonChunkObjectClient(
      baseUrl: 'https://api.example.com',
      options: BaseHttpJsonObjectClientOptions(
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(minutes: 5), // Longer for streams
        sendTimeout: Duration(seconds: 30),
      ),
      onTransformRawData: (data, response) {
        return jsonDecode(data);
      },
    );
  }

  Stream<ApiResponse<ChatMessage, ApiError>> streamChatCompletion({
    required String prompt,
  }) {
    final request = ChatRequest(prompt: prompt);

    return _streamClient.call<ChatRequest, ChatMessage, ApiError>(
      path: '/chat/stream',
      method: ApiMethod.post,
      req: request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      convertSuccess: (json) => ChatMessage.fromJson(json),
      convertError: (json) => ApiError.fromJson(json),
      correlationId: 'chat-stream-${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

// Usage
void main() async {
  final streamClient = StreamApiClient();

  await for (final response in streamClient.streamChatCompletion(
    prompt: 'Tell me a joke',
  )) {
    if (response.isSuccess) {
      print('Chunk: ${response.response?.content}');
    } else if (response.isError) {
      print('Error: ${response.errorResponse?.message}');
      break;
    } else if (response.isException) {
      print('Exception: ${response.exception}');
      break;
    }
  }
}
```

### 6. File Upload with FormData

Use `BaseFormData` for multipart file uploads.

```dart
import 'dart:io';

class UploadImageRequest extends BaseFormData {
  final File imageFile;
  final String caption;

  UploadImageRequest({
    required this.imageFile,
    required this.caption,
  });

  @override
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
      'caption': caption,
    });
  }

  @override
  Map<String, dynamic> toJson() {
    return {}; // Not used for FormData
  }
}

class ApiClient {
  // ... previous code ...

  Future<ApiResponse<UploadResponse, ApiError>> uploadImage({
    required File imageFile,
    required String caption,
  }) async {
    final request = UploadImageRequest(
      imageFile: imageFile,
      caption: caption,
    );

    final formData = await request.toFormData();

    return await _client.call<FormData, UploadResponse, ApiError>(
      path: '/upload/image',
      method: ApiMethod.post,
      req: formData,
      headers: {
        'Authorization': 'Bearer $token',
      },
      convertSuccess: (json) => UploadResponse.fromJson(json),
      convertError: (json) => ApiError.fromJson(json),
    );
  }
}
```

### 7. Path Parameters

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

## 🎯 Best Practices

1. **Type Safety**: Always define explicit types for your request/response models
2. **Error Handling**: Handle all three states: success, error, and exception
3. **Logging**: Use correlation IDs to trace requests across your application
4. **Timeouts**: Configure appropriate timeouts based on your API's response time
5. **Null Safety**: Use null-aware operators when accessing response data
6. **Dependency Injection**: Register clients as singletons in your DI container
7. **Testing**: Mock `BaseHttpJsonObjectClient` for unit tests

## 🧑‍💻 Contributors

* **Mohammed Shakib** ([@shakib1989](https://github.com/shakib1989)) - *Main Library Development*
* **Shuvo Prosad Sarnakar** ([@shuvoprosadsarnakar](https://github.com/shuvoprosadsarnakar)) - *Extensive documentation and getting the project for pub.dev.*

## 🪪 License

This project is licensed under the **MIT License** — see the LICENSE file for details.