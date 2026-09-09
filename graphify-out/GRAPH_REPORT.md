# Graph Report - virnavi_json_client  (2026-09-09)

## Corpus Check
- 50 files · ~8,524 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 274 nodes · 333 edges · 22 communities (18 shown, 4 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 30 edges (avg confidence: 0.93)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `06fd2063`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- http_client.dart
- model/models.dart
- post_grid.dart
- post_list_api.dart
- base_object_api.dart
- virnavi_json_client README
- iOS App Icon 1024x1024@1x
- post_state.dart
- .application
- photo/models.dart
- virnavi_json_client.dart
- api_endpoints.dart
- MainActivity.kt
- iOS Launch Image @1x
- Root Analysis Options
- Example Analysis Options
- iOS Launch Screen Assets README
- virnavi_json_client_test.dart

## God Nodes (most connected - your core abstractions)
1. `iOS App Icon 1024x1024@1x` - 15 edges
2. `virnavi_json_client README` - 10 edges
3. `PostCubit` - 7 edges
4. `BaseHttpJsonObjectClient` - 7 edges
5. `BaseJson` - 6 edges
6. `CHANGELOG` - 6 edges
7. `PostListApi` - 5 edges
8. `BaseHttpJsonChunkObjectClient` - 5 edges
9. `Example App README` - 5 edges
10. `Android HDPI Launcher Icon` - 5 edges

## Surprising Connections (you probably didn't know these)
- `_JsonReq` --inherits--> `BaseJson`  [EXTRACTED]
  test/virnavi_json_client_test.dart → lib/src/base_json.dart
- `BaseHttpJsonChunkObjectClient` --references--> `Dio HTTP Client`  [INFERRED]
  README.md → pubspec.yaml
- `BaseHttpJsonObjectClient` --references--> `Dio HTTP Client`  [INFERRED]
  README.md → pubspec.yaml
- `BaseHttpJsonObjectClient` --references--> `virnavi_common_sdk`  [INFERRED]
  README.md → pubspec.yaml
- `EmptyDataModel` --inherits--> `BaseJson`  [EXTRACTED]
  example/lib/data/api/base/model/empty_data_model.dart → lib/src/base_json.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Clean Architecture Example Implementation** — post_list_api, post_cubit, base_json_object_api [EXTRACTED 0.95]
- **Type-Safe HTTP Request/Response Pipeline** — base_json, api_response, base_http_json_object_client [EXTRACTED 0.95]
- **Streaming API Support** — base_http_json_chunk_object_client, api_response, base_json [INFERRED 0.85]

## Communities (22 total, 4 thin omitted)

### Community 0 - "http_client.dart"
Cohesion: 0.05
Nodes (44): bool get, dart:developer, Dio?, Dio get, Duration, ER?, Exception?, isSuccess (+36 more)

### Community 1 - "model/models.dart"
Cohesion: 0.06
Nodes (36): @JsonSerializable, empty, fromJson, toJson, fromJson, toJson, code, empty (+28 more)

### Community 2 - "post_grid.dart"
Cohesion: 0.08
Nodes (30): Cubit, build, main, MyApp, getList, _photoNetwork, PostCubit, build (+22 more)

### Community 3 - "post_list_api.dart"
Cohesion: 0.11
Nodes (19): ../api/photo/post_list_api.dart, dart:convert, call, convertResponse, onTransformRawData, _api, getList, PostNetworkImpl (+11 more)

### Community 4 - "base_object_api.dart"
Cohesion: 0.13
Nodes (14): dart:io, apiCall, _client, _convertErrorResponse, _convertFromException, convertResponse, method, onStatusCodeTransform (+6 more)

### Community 5 - "virnavi_json_client README"
Cohesion: 0.19
Nodes (20): ApiFailureResponse, ApiMethod, ApiResponse, BaseFormData, BaseHttpJsonChunkObjectClient, BaseHttpJsonObjectClient, BaseJson, BaseJsonObjectApi (+12 more)

### Community 6 - "iOS App Icon 1024x1024@1x"
Cohesion: 0.10
Nodes (20): Android HDPI Launcher Icon, Android MDPI Launcher Icon, Android XHDPI Launcher Icon, Android XXHDPI Launcher Icon, Android XXXHDPI Launcher Icon, iOS App Icon 1024x1024@1x, iOS App Icon 20x20@1x, iOS App Icon 20x20@2x (+12 more)

### Community 7 - "post_state.dart"
Cohesion: 0.12
Nodes (16): Equatable, copyWith, error, isLoading, posts, PostState, props, List (+8 more)

### Community 8 - ".application"
Cohesion: 0.15
Nodes (10): Any, Bool, AppDelegate, RunnerTests, Flutter, FlutterAppDelegate, UIApplication, UIKit (+2 more)

### Community 9 - "photo/models.dart"
Cohesion: 0.22
Nodes (8): package:json_annotation/json_annotation.dart, body, fromJson, id, title, toJson, toModel, userId

### Community 10 - "virnavi_json_client.dart"
Cohesion: 0.40
Nodes (4): virnavi_json_client, library, package:dio/dio.dart, src/http_client.dart

### Community 11 - "api_endpoints.dart"
Cohesion: 0.50
Nodes (3): ApiEndpoints, posts, static const String

### Community 13 - "iOS Launch Image @1x"
Cohesion: 0.67
Nodes (3): iOS Launch Image @2x, iOS Launch Image @3x, iOS Launch Image @1x

### Community 21 - "virnavi_json_client_test.dart"
Cohesion: 0.13
Nodes (16): BaseJsonObjectApi, PostListApi, main, FormatException, package:flutter_test/flutter_test.dart, package:virnavi_json_client/virnavi_json_client.dart, _JsonReq, main (+8 more)

## Knowledge Gaps
- **139 isolated node(s):** `XCTest`, `ApiEndpoints`, `posts`, `path`, `method` (+134 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `BaseJson` connect `virnavi_json_client_test.dart` to `http_client.dart`?**
  _High betweenness centrality (0.073) - this node is a cross-community bridge._
- **Why does `EmptyDataModel` connect `virnavi_json_client_test.dart` to `model/models.dart`?**
  _High betweenness centrality (0.059) - this node is a cross-community bridge._
- **Why does `PostListApi` connect `virnavi_json_client_test.dart` to `post_list_api.dart`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Are the 15 inferred relationships involving `iOS App Icon 1024x1024@1x` (e.g. with `Android HDPI Launcher Icon` and `iOS App Icon 20x20@1x`) actually correct?**
  _`iOS App Icon 1024x1024@1x` has 15 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `BaseHttpJsonObjectClient` (e.g. with `ApiResponse` and `BaseHttpJsonChunkObjectClient`) actually correct?**
  _`BaseHttpJsonObjectClient` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `XCTest`, `ApiEndpoints`, `posts` to the rest of the system?**
  _139 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `http_client.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.045454545454545456 - nodes in this community are weakly interconnected._