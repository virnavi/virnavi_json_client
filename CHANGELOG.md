## 0.0.2

* **Bug fix**: Path parameters were never substituted — `_callMethod` was iterating `headers.keys` instead of `pathParams.keys`
* **Bug fix**: `onTransformRawData` null assertion crash — forced `!` dereference on nullable field caused a crash when omitted and the server returned an error body; now handles null gracefully in both clients
* **Bug fix**: `ApiResponse.isException` always returned `false` — checked `code == 0` but all exception paths set `code == -1`; corrected to `code < 0`
* **Bug fix**: `ApiMethod.formData` was unhandled in `_callMethod` — silently fell through to GET path; now correctly maps to POST
* **New**: Added `ApiMethod.patch` and full PATCH support in both `BaseHttpJsonObjectClient` and `BaseHttpJsonChunkObjectClient`
* **New**: GET requests no longer require a `BaseJson` body — passing `null` now sends no query parameters instead of throwing
* **Robustness**: Empty response bodies (e.g. `204 No Content`, empty `200`) now decode to an empty map instead of crashing with a `FormatException`
* **Robustness**: Non-object JSON payloads (arrays, primitives) now raise a catchable `FormatException` instead of an uncatchable `TypeError` that could crash the caller
* **Robustness**: Streaming client now decodes the byte stream through `utf8.decoder` and buffers across chunks, so multi-byte characters or JSON objects split across chunk boundaries no longer crash or fail to parse
* **Robustness**: Error-response decoding in both clients is now failure-safe and never throws from inside the `catch` block; an undecodable error body falls back to reporting the underlying exception
* **Fix**: Removed `print(e)` from DioException handler to prevent stack trace leakage in production
* **Fix**: Removed dead `BaseOptions()` instantiation with no effect
* **Chore**: Raised minimum SDK constraints to Dart `>=3.11.1` and Flutter `>=3.41.4`
* **Tests**: Replaced commented-out placeholder tests with 17 real unit tests covering `ApiResponse`, `ApiMethod`, `BaseJson`, `BaseFormData`, options, and response decoding edge cases

## 0.0.1

* Initial release of virnavi_json_client
* BaseHttpJsonObjectClient for standard REST API calls
* BaseHttpJsonChunkObjectClient for streaming/chunked responses
* Type-safe request/response handling with BaseJson abstraction
* ApiResponse wrapper for structured error handling
* FormData support via BaseFormData
* Integrated logging with correlation IDs
* Custom response transformers for flexible API formats
