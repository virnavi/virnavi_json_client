## 0.0.2

* **Bug fix**: Path parameters were never substituted — `_callMethod` was iterating `headers.keys` instead of `pathParams.keys`
* **Bug fix**: `onTransformRawData` null assertion crash — forced `!` dereference on nullable field caused a crash when omitted and the server returned an error body; now handles null gracefully in both clients
* **Bug fix**: `ApiResponse.isException` always returned `false` — checked `code == 0` but all exception paths set `code == -1`; corrected to `code < 0`
* **Bug fix**: `ApiMethod.formData` was unhandled in `_callMethod` — silently fell through to GET path; now correctly maps to POST
* **New**: Added `ApiMethod.patch` and full PATCH support in both `BaseHttpJsonObjectClient` and `BaseHttpJsonChunkObjectClient`
* **New**: GET requests no longer require a `BaseJson` body — passing `null` now sends no query parameters instead of throwing
* **Fix**: Removed `print(e)` from DioException handler to prevent stack trace leakage in production
* **Fix**: Removed dead `BaseOptions()` instantiation with no effect
* **Tests**: Replaced commented-out placeholder tests with real unit tests covering `ApiResponse`, `ApiMethod`, `BaseJson`, `BaseHttpJsonObjectClientOptions`

## 0.0.1

* Initial release of virnavi_json_client
* BaseHttpJsonObjectClient for standard REST API calls
* BaseHttpJsonChunkObjectClient for streaming/chunked responses
* Type-safe request/response handling with BaseJson abstraction
* ApiResponse wrapper for structured error handling
* FormData support via BaseFormData
* Integrated logging with correlation IDs
* Custom response transformers for flexible API formats
