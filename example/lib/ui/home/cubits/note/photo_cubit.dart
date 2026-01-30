import 'package:example/ui/home/cubits/note/photo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/domain/network/photo_network.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final PhotoNetwork _photoNetwork;

  PhotoCubit(this._photoNetwork) : super(const PhotoState());

  Future<void> getPhotos() async {
    emit(state.copyWith(isLoading: true));
    final response = await _photoNetwork.getList();
    response.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure)),
      (photos) => emit(state.copyWith(isLoading: false, photos: photos)),
    );
  }
}
