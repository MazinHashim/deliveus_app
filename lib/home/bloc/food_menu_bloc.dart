import 'package:delivery_repository/delivery_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'food_menu_event.dart';
part 'food_menu_state.dart';

enum MenuOptions { search, settings, profile, history }

class FoodMenuBloc extends Bloc<FoodMenuEvent, FoodMenuState> {
  FoodMenuBloc(this._foodRepository) : super(const FoodMenuState()) {
    on<FetchFoodOrFilterdEvent>(_onFoodFetched);
    on<ClearErrorMessageEvent>(
      (event, emit) {
        emit(state.copyWith(errorMessage: ''));
      },
    );
  }

  final FoodRepository _foodRepository;

  Future<void> _onFoodFetched(
    FetchFoodOrFilterdEvent event,
    Emitter<FoodMenuState> emit,
  ) async {
    emit(state.copyWith(status: FoodsListStatus.loading));
    await emit.forEach<List<Food>>(
      event.category == 'all'
          ? _foodRepository.getFoods()
          : _foodRepository.getFoods(event.category),
      onData: (foods) {
        if (event.category == 'all') {
          final c = foods.map((e) => e.category!).toSet().toList();
          if (!c.contains('all')) {
            c.insert(0, 'all');
          }
          return state.copyWith(
            categories: c,
            foods: foods,
            filter: event.category,
            status: FoodsListStatus.success,
          );
        }
        return state.copyWith(
          foods: foods,
          filter: event.category,
          status: FoodsListStatus.success,
        );
      },
      onError: (e, __) => state.copyWith(
        status: FoodsListStatus.failure,
        errorMessage: e.toString(),
      ),
    );
  }
}
