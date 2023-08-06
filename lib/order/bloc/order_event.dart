part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class AddItemToOrderEvent extends OrderEvent {
  const AddItemToOrderEvent({required this.item});

  final OrderItem item;

  @override
  List<Object> get props => [item];
}

class RemoveItemFromOrderEvent extends OrderEvent {
  const RemoveItemFromOrderEvent({required this.foodId});

  final String foodId;

  @override
  List<Object> get props => [foodId];
}

class ConfirmDestinationLocationEvent extends OrderEvent {
  const ConfirmDestinationLocationEvent({required this.destination});
  final LatLng destination;

  @override
  List<Object> get props => [destination];
}

class ConfirmPickupBranchEvent extends OrderEvent {
  const ConfirmPickupBranchEvent({required this.branchId});
  final String branchId;

  @override
  List<Object> get props => [branchId];
}

class ClearOrderErrorMessageEvent extends OrderEvent {
  const ClearOrderErrorMessageEvent();
}

class ClearOrderItemsEvent extends OrderEvent {
  const ClearOrderItemsEvent();
}

class FetchLocalOrderItemsEvent extends OrderEvent {
  const FetchLocalOrderItemsEvent();
}

class OrderFoodForCustomerEvent extends OrderEvent {
  const OrderFoodForCustomerEvent({required this.order});

  final Order order;
  @override
  List<Object> get props => [order];
}

class FetchHistoryOrdersEvent extends OrderEvent {
  const FetchHistoryOrdersEvent({required this.userId});
  final String userId;

  @override
  List<Object> get props => [userId];
}

class IncreaseItemQuantityEvent extends OrderEvent {
  const IncreaseItemQuantityEvent();
}

class DecreaseItemQuantityEvent extends OrderEvent {
  const DecreaseItemQuantityEvent();
}

class ComputeTotalAmountEvent extends OrderEvent {
  const ComputeTotalAmountEvent();
}

class OrderErrorEvent extends OrderEvent {
  const OrderErrorEvent({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}
