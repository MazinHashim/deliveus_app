part of 'food_menu_bloc.dart';

sealed class FoodMenuEvent extends Equatable {
  const FoodMenuEvent();

  @override
  List<Object> get props => [];
}

class FetchMenuItemsEvent extends FoodMenuEvent {
  const FetchMenuItemsEvent();
}

class ClearErrorMessageEvent extends FoodMenuEvent {
  const ClearErrorMessageEvent();
}

class SelectDropdownNavigationEvent extends FoodMenuEvent {
  const SelectDropdownNavigationEvent(this.menuOption);

  final MenuOptions menuOption;
  @override
  List<Object> get props => [menuOption];
}

class FetchFoodOrFilterdEvent extends FoodMenuEvent {
  const FetchFoodOrFilterdEvent(this.category);

  final String category;
  @override
  List<Object> get props => [category];
}
