import 'package:bloc/bloc.dart';

import '../data/repo/cities_repo.dart';
import 'cities_state.dart';


class CitiesCubit extends Cubit<CitiesState> {
  final CitiesRepo _repo;
  CitiesCubit(this._repo) : super(const CitiesState.initial());

  void getCities() async {
    emit(const CitiesState.loading());
    final response = await _repo.getCities();

    response.when(success: (data) {
      emit(CitiesState.success(data));
    }, failure: (error) {
      emit(CitiesState.error(error: error.apiErrorModel.message ?? ''));
    });
  }
}
