import 'package:example/ui/home/cubits/note/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/domain/network/post_network.dart';

class PostCubit extends Cubit<PostState> {
  final PostNetwork _photoNetwork;

  PostCubit(this._photoNetwork) : super(const PostState());

  Future<void> getList() async {
    emit(state.copyWith(isLoading: true));
    final response = await _photoNetwork.getList();
    response.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure)),
      (photos) => emit(state.copyWith(isLoading: false, posts: photos)),
    );
  }
}
