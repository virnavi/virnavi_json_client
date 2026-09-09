# Graph Report - virnavi_json_client  (2026-09-09)

## Corpus Check
- Corpus is ~7,777 words - fits in a single context window. You may not need a graph.

## Summary
- 266 nodes · 323 edges · 21 communities (17 shown, 4 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 30 edges (avg confidence: 0.93)
- Token cost: 2,800 input · 1,200 output

## Community Hubs (Navigation)
- HTTP Client Core
- Example API Models
- BLoC UI Layer
- Post API Implementation
- Base API Abstraction
- Package Public API
- App Icons & Assets
- Domain Models & State
- iOS Native Runner
- Post Data Models
- Library Entry Point
- API Endpoints Config
- Android Native Runner
- iOS Launch Screen
- Root Lint Config
- Example Lint Config
- Launch Image README

## God Nodes (most connected - your core abstractions)
1. `iOS App Icon 1024x1024@1x` - 15 edges
2. `virnavi_json_client README` - 10 edges
3. `PostCubit` - 7 edges
4. `BaseHttpJsonObjectClient` - 7 edges
5. `CHANGELOG` - 6 edges
6. `PostListApi` - 5 edges
7. `BaseJson` - 5 edges
8. `Example App README` - 5 edges
9. `BaseHttpJsonChunkObjectClient` - 5 edges
10. `Android HDPI Launcher Icon` - 5 edges

## Surprising Connections (you probably didn't know these)
- `_JsonReq` --inherits--> `BaseJson`  [EXTRACTED]
  test/virnavi_json_client_test.dart → lib/src/base_json.dart
- `BaseHttpJsonObjectClient` --references--> `Dio HTTP Client`  [INFERRED]
  README.md → pubspec.yaml
- `BaseHttpJsonObjectClient` --references--> `virnavi_common_sdk`  [INFERRED]
  README.md → pubspec.yaml
- `BaseHttpJsonChunkObjectClient` --references--> `Dio HTTP Client`  [INFERRED]
  README.md → pubspec.yaml
- `EmptyDataModel` --inherits--> `BaseJson`  [EXTRACTED]
  example/lib/data/api/base/model/empty_data_model.dart → lib/src/base_json.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Type-Safe HTTP Request/Response Pipeline** — base_json, api_response, base_http_json_object_client [EXTRACTED 0.95]
- **Clean Architecture Example Implementation** — post_list_api, post_cubit, base_json_object_api [EXTRACTED 0.95]
- **Streaming API Support** — base_http_json_chunk_object_client, api_response, base_json [INFERRED 0.85]

## Communities (21 total, 4 thin omitted)

### Community 0 - "HTTP Client Core"
Cohesion: 0.05
Nodes (39): bool get, dart:developer, Dio?, Dio get, Duration, ER?, Exception?, isSuccess (+31 more)

### Community 1 - "Example API Models"
Cohesion: 0.06
Nodes (35): @JsonSerializable, empty, fromJson, toJson, fromJson, toJson, code, empty (+27 more)

### Community 2 - "BLoC UI Layer"
Cohesion: 0.08
Nodes (29): Cubit, build, main, MyApp, getList, _photoNetwork, PostCubit, build (+21 more)

### Community 3 - "Post API Implementation"
Cohesion: 0.09
Nodes (27): ../api/photo/post_list_api.dart, dart:convert, BaseJsonObjectApi, call, convertResponse, onTransformRawData, PostListApi, _api (+19 more)

### Community 4 - "Base API Abstraction"
Cohesion: 0.09
Nodes (20): dart:io, apiCall, _client, _convertErrorResponse, _convertFromException, convertResponse, method, onStatusCodeTransform (+12 more)

### Community 5 - "Package Public API"
Cohesion: 0.19
Nodes (20): ApiFailureResponse, ApiMethod, ApiResponse, BaseFormData, BaseHttpJsonChunkObjectClient, BaseHttpJsonObjectClient, BaseJson, BaseJsonObjectApi (+12 more)

### Community 6 - "App Icons & Assets"
Cohesion: 0.10
Nodes (20): Android HDPI Launcher Icon, Android MDPI Launcher Icon, Android XHDPI Launcher Icon, Android XXHDPI Launcher Icon, Android XXXHDPI Launcher Icon, iOS App Icon 1024x1024@1x, iOS App Icon 20x20@1x, iOS App Icon 20x20@2x (+12 more)

### Community 7 - "Domain Models & State"
Cohesion: 0.12
Nodes (17): Equatable, copyWith, error, isLoading, posts, PostState, props, List (+9 more)

### Community 8 - "iOS Native Runner"
Cohesion: 0.15
Nodes (10): Any, Bool, AppDelegate, RunnerTests, Flutter, FlutterAppDelegate, UIApplication, UIKit (+2 more)

### Community 9 - "Post Data Models"
Cohesion: 0.22
Nodes (8): package:json_annotation/json_annotation.dart, body, fromJson, id, title, toJson, toModel, userId

### Community 10 - "Library Entry Point"
Cohesion: 0.40
Nodes (4): virnavi_json_client, library, package:dio/dio.dart, src/http_client.dart

### Community 11 - "API Endpoints Config"
Cohesion: 0.50
Nodes (3): ApiEndpoints, posts, static const String

### Community 13 - "iOS Launch Screen"
Cohesion: 0.67
Nodes (3): iOS Launch Image @2x, iOS Launch Image @3x, iOS Launch Image @1x

## Knowledge Gaps
- **134 isolated node(s):** `XCTest`, `ApiEndpoints`, `posts`, `path`, `method` (+129 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `BaseJson` connect `Post API Implementation` to `HTTP Client Core`?**
  _High betweenness centrality (0.066) - this node is a cross-community bridge._
- **Why does `EmptyDataModel` connect `Post API Implementation` to `Example API Models`?**
  _High betweenness centrality (0.057) - this node is a cross-community bridge._
- **Why does `PostModel` connect `Domain Models & State` to `BLoC UI Layer`?**
  _High betweenness centrality (0.014) - this node is a cross-community bridge._
- **Are the 15 inferred relationships involving `iOS App Icon 1024x1024@1x` (e.g. with `Android HDPI Launcher Icon` and `iOS App Icon 20x20@1x`) actually correct?**
  _`iOS App Icon 1024x1024@1x` has 15 INFERRED edges - model-reasoned connections that need verification._
- **Are the 4 inferred relationships involving `BaseHttpJsonObjectClient` (e.g. with `ApiResponse` and `BaseHttpJsonChunkObjectClient`) actually correct?**
  _`BaseHttpJsonObjectClient` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `XCTest`, `ApiEndpoints`, `posts` to the rest of the system?**
  _134 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `HTTP Client Core` be split into smaller, more focused modules?**
  _Cohesion score 0.05128205128205128 - nodes in this community are weakly interconnected._