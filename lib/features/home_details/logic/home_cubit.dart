import 'package:final_project/features/home_details/logic/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/home_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeRepo) : super(const HomeState.initial());
  final HomeRepo _homeRepo;

  void getAllPosts(int page, {String? cityId}) async {
    emit(const HomeState.loading());
    final response = await _homeRepo.getAllPosts(page,cityId: cityId);

    response.when(success: (data) {
      emit(HomeState.success(data));
    }, failure: (error) {
      emit(HomeState.error(error: error.apiErrorModel.message ?? ''));
    });
  }

}
