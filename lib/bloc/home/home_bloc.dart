import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_fit_man/bloc/home/home_event.dart';
import 'package:one_fit_man/bloc/home/home_state.dart';
import 'package:one_fit_man/repositories/home/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(HomeState.empty()) {
    on<HomeFetchEvent>((event, emit) async => _onHomeFetchEvent(event, emit));
  }

  Future<void> _onHomeFetchEvent(
      HomeFetchEvent event, Emitter<HomeState> emit) async {
    final squat = await homeRepository.getSquats();
    final pushUp = await homeRepository.getPushUps();
    emit(state.copyWith(squat: squat, pushUp: pushUp));
  }
}
