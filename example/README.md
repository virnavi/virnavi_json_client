# Virnavi JSON Client Example

A modern, production-ready example demonstrating how to use `virnavi_json_client` for seamless API integration in Flutter applications. This example showcases how to fetch and display data using a structured, layered architecture.

## Project Overview

This example demonstrates a photo discovery application that fetches data from an external API. It showcases:
- Efficient API handling with `virnavi_json_client`.
- Error handling and data transformation.

---

## Folder Structure

```text
lib/
├── data/               # Data layer implementation
│   ├── api/            # API definitions and models
│   │   ├── base/       # Base API and response models
│   │   ├── models/     # API-specific data models
│   │   └── photo/      # Photo feature API implementations
│   └── network/        # Concrete network implementations
├── domain/             # Business logic layer (Framework independent)
│   ├── models/         # Pure Dart domain models
│   └── network/        # Abstract network interfaces
├── ui/                 # Presentation layer
│   └── home/
│       ├── cubits/     # BLoC logic for state management
│       ├── widgets/    # Reusable UI components
│       └── home_screen.dart # Main feature entry point
└── main.dart           # App entry
```

---

## Architecture & Code Pattern

The project follows a basic **Clean Architecture** pattern to decouple the UI from the network implementation.

1.  **Domain Layer**: Contains the core logic. Models (`PhotoModel`) and Network interfaces (`PhotoNetwork`) reside here. It remains agnostic of the underlying HTTP client.
2.  **Data Layer**: Implements the Domain interfaces. `PhotoNetworkImpl` uses `PhotoListApi` (extending `BaseJsonObjectApi`) to handle the actual communication with the API.
3.  **Presentation Layer (UI)**: Uses Cubits to interact with the Network layer. The UI observes state changes and updates reactively based on API responses.

### API Integration Pattern
We use `BaseJsonObjectApi` from `virnavi_json_client` to create a robust and type-safe bridge between the API and the application. It provides:
- Automatic JSON serialization/deserialization.
- Flexible data transformation via `onTransformRawData`.
- Standardized error handling through `Either<Failure, Success>`.

#### Effective Usage: `BaseJsonObjectApi`
To use the package effectively, you should create a project-specific abstract class that extends `BaseJsonObjectApi`. This class centralization:
- **Base URL**: Define your API's root URL in one place.
- **Default Headers**: Manage authentication tokens, platform info, and content types globally.
- **Client Configuration**: Initialize the `BaseHttpJsonObjectClient` with project-specific options.
- **Error Handling**: Standardize how API/Network errors are converted into your domain models.

Example of a base class in this project:
```dart
abstract class BaseJsonObjectApi<Req extends BaseJson, Res> {
  // ... common properties (path, method, client initialization)

  Future<Either<ApiFailureResponse, Res>> apiCall({
    // ... handles headers, path parameters, and the actual client call
  }) async {
    // ... implementation
  }

  Res convertResponse(Map<String, dynamic> json);
  
  // Standardized error conversion
  ApiFailureResponse _convertErrorResponse(dynamic data) => ApiFailureResponse.fromJson(data);
}
```
This pattern ensures that all your API implementations (like `PhotoListApi`) stay clean and focused only on their specific endpoint logic.

---

## Example Details

### PhotoListApi
Handles fetching a list of photos from the `/photos` endpoint.
- **Implementation**: Extends `BaseJsonObjectApi<EmptyDataModel, PhotoListResponse>`.
- **Key Feature**: Overrides `onTransformRawData` to handle APIs that return a top-level JSON list by wrapping it in a data object for consistent processing.

### PhotoCubit
Manages the UI state for the photo grid.
- **Workflow**: Calls `getPhotos()` on the Network layer.
- **State**: Emits a `PhotoState` containing `isLoading`, `photos` list, and optional `error` details.

---

## Getting Started

1.  **Dependencies**: Run `flutter pub get`.
2.  **Code Generation**: If you modify API models or responses, run:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
3.  **Run**: `flutter run`.
