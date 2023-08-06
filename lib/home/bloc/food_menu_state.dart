part of 'food_menu_bloc.dart';

enum FoodsListStatus { initial, loading, success, failure }

class FoodMenuState extends Equatable {
  const FoodMenuState({
    this.status = FoodsListStatus.initial,
    this.foods = const [],
    this.categories = const ['all'],
    this.filter = 'all',
    this.menuOption,
    this.errorMessage = '',
  });

  final MenuOptions? menuOption;
  final String errorMessage;
  final FoodsListStatus status;
  final List<Food> foods;
  final List<String> categories;
  final String filter;

  @override
  List<Object?> get props =>
      [filter, categories, foods, menuOption, errorMessage, status];

  FoodMenuState copyWith({
    MenuOptions? menuOption,
    String? errorMessage,
    FoodsListStatus? status,
    List<Food>? foods,
    List<String>? categories,
    String? filter,
  }) {
    return FoodMenuState(
      menuOption: menuOption ?? this.menuOption,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      foods: foods ?? this.foods,
      categories: categories ?? this.categories,
      filter: filter ?? this.filter,
    );
  }
}
