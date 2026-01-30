import 'package:equatable/equatable.dart';
import 'package:example/data/api/base/model/models.dart';
import 'package:example/domain/models/models.dart';

class PhotoState extends Equatable {
  final bool isLoading;
  final List<PhotoModel> photos;
  final FailureModel? error;

  const PhotoState({
    this.isLoading = false,
    this.photos = const [],
    this.error,
  });

  PhotoState copyWith({
    bool? isLoading,
    List<PhotoModel>? photos,
    FailureModel? error,
  }) {
    return PhotoState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, photos, error];
}
