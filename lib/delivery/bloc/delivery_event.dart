part of 'delivery_bloc.dart';

sealed class DeliveryEvent extends Equatable {
  const DeliveryEvent();

  @override
  List<Object> get props => [];
}

class OrderOptionChangedEvent extends DeliveryEvent {
  const OrderOptionChangedEvent(this.orderOption);

  final OrderOption orderOption;

  @override
  List<Object> get props => [orderOption];
}

class LoadGeolocationEvent extends DeliveryEvent {
  const LoadGeolocationEvent();
}

class LoadBranchesDataEvent extends DeliveryEvent {
  const LoadBranchesDataEvent();
}

class ToggleBottomPillEvent extends DeliveryEvent {
  const ToggleBottomPillEvent(this.value);

  final double value;

  @override
  List<Object> get props => [value];
}

class AddErrorMessageEvent extends DeliveryEvent {
  const AddErrorMessageEvent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ClearDeliveryErrorMessageEvent extends DeliveryEvent {
  const ClearDeliveryErrorMessageEvent();
}

class ChangeSelectedLocationEvent extends DeliveryEvent {
  const ChangeSelectedLocationEvent(this.position);

  final LatLng position;

  @override
  List<Object> get props => [position];
}

class ChangeSelectedBranchEvent extends DeliveryEvent {
  const ChangeSelectedBranchEvent(this.branchId);

  final String branchId;

  @override
  List<Object> get props => [branchId];
}
