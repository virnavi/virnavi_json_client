import 'package:equatable/equatable.dart';
import 'package:example/data/api/base/model/models.dart';
import 'package:example/domain/models/models.dart';

class PostState extends Equatable {
  final bool isLoading;
  final List<PostModel> posts;
  final FailureModel? error;

  const PostState({this.isLoading = false, this.posts = const [], this.error});

  PostState copyWith({
    bool? isLoading,
    List<PostModel>? posts,
    FailureModel? error,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, posts, error];
}
