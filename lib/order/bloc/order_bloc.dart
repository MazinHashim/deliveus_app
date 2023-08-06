import 'dart:async';

import 'package:delivery_repository/delivery_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(this._orderRepository, this.user) : super(const OrderState()) {
    on<AddItemToOrderEvent>(_addItemToOrder);
    on<RemoveItemFromOrderEvent>(_removeItemFromOrder);
    on<FetchLocalOrderItemsEvent>(_fetchLocalOrderItems);
    on<FetchHistoryOrdersEvent>(_fetchHistoryOrders);
    on<IncreaseItemQuantityEvent>(_increaseItemQuantity);
    on<DecreaseItemQuantityEvent>(_decreaseItemQuantity);
    on<ComputeTotalAmountEvent>(_computeTotalAmount);
    on<ConfirmDestinationLocationEvent>(_confirmDeliveryDestination);
    on<ConfirmPickupBranchEvent>(_confirmPickupBranch);
    on<OrderFoodForCustomerEvent>(_orderFoodForCustomer);
    on<ClearOrderItemsEvent>(_clearOrderItems);
    on<ClearOrderErrorMessageEvent>(
      (event, emit) {
        emit(state.copyWith(errorMessage: ''));
      },
    );

    on<OrderErrorEvent>((event, emit) {
      emit(
        state.copyWith(
          errorMessage: event.error,
          order: state.order.copyWith(status: OrderStatus.failure),
        ),
      );
    });

    add(const FetchLocalOrderItemsEvent());
    add(FetchHistoryOrdersEvent(userId: user.id));
  }

  final OrderRepository _orderRepository;
  final User user;

  void _confirmDeliveryDestination(
    ConfirmDestinationLocationEvent event,
    Emitter<OrderState> emit,
  ) {
    emit(
      state.copyWith(
        order: state.order.copyWith(
          destinationLat: event.destination.latitude,
          destinationLong: event.destination.longitude,
        ),
      ),
    );
  }

  void _confirmPickupBranch(
    ConfirmPickupBranchEvent event,
    Emitter<OrderState> emit,
  ) {
    emit(
      state.copyWith(order: state.order.copyWith(fromBranch: event.branchId)),
    );
  }

  Future<void> _fetchHistoryOrders(
    FetchHistoryOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    await emit.forEach(
      _orderRepository.getOrders(event.userId),
      onData: (orders) {
        // orders.sort((a, b) => a.orderDate!.compareTo(b.orderDate!));
        final prevOrds = state.copyWith(prevOrders: orders);
        return prevOrds;
      },
      onError: (_, __) {
        return state.copyWith(
          order: state.order.copyWith(status: OrderStatus.failure),
          errorMessage: 'error',
        );
      },
    );
  }

  Future<void> _fetchLocalOrderItems(
    FetchLocalOrderItemsEvent event,
    Emitter<OrderState> emit,
  ) async {
    await emit.forEach(
      _orderRepository.getOrderItems(),
      onData: (items) {
        final sts = state.copyWith(orderItems: items);
        add(const ComputeTotalAmountEvent());
        return sts;
      },
      onError: (_, __) {
        return state.copyWith(
          order: state.order.copyWith(status: OrderStatus.failure),
          errorMessage: 'error',
        );
      },
    );
  }

  Future<void> _orderFoodForCustomer(
    OrderFoodForCustomerEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          order: state.order.copyWith(
            status: OrderStatus.progressing,
          ),
        ),
      );
      await _orderRepository.saveOrder(event.order);
      //final items = state.prevOrders.toList(growable: true)..add(event.order);
      add(const ClearOrderItemsEvent());
      emit(
        state.copyWith(
          // prevOrders: items,
          order: state.order.copyWith(
            status: OrderStatus.initial,
          ),
        ),
      );
    } on OrderFailure catch (e, _) {
      add(OrderErrorEvent(error: e.message));
    }
  }

  void _addItemToOrder(
    AddItemToOrderEvent event,
    Emitter<OrderState> emit,
  ) {
    final items = state.orderItems.toList(growable: true);
    final itemIndex = items.indexWhere((t) => t.foodId == event.item.foodId);
    if (itemIndex >= 0) {
      items[itemIndex] = event.item;
    } else {
      items.add(event.item);
    }
    _orderRepository.saveOrderItem(event.item);
    emit(state.copyWith(orderItems: items));
    try {} on OrderFailure catch (e, _) {
      add(OrderErrorEvent(error: e.message));
    }
  }

  void _removeItemFromOrder(
    RemoveItemFromOrderEvent event,
    Emitter<OrderState> emit,
  ) {
    final items = state.orderItems.toList(growable: true);
    final itemIndex = items.indexWhere((t) => t.foodId == event.foodId);
    if (itemIndex == -1) {
      throw const OrderFailure();
    } else {
      items.removeAt(itemIndex);
      _orderRepository.removeOrderItem(event.foodId);
      emit(state.copyWith(orderItems: items));
    }
    try {} on OrderFailure catch (e, _) {
      add(OrderErrorEvent(error: e.message));
    }
  }

  void _clearOrderItems(
    ClearOrderItemsEvent event,
    Emitter<OrderState> emit,
  ) {
    final items = state.orderItems.toList(growable: true)..clear();
    _orderRepository.clearOrderItems();
    emit(state.copyWith(orderItems: items));
    try {} on OrderFailure catch (e, _) {
      add(OrderErrorEvent(error: e.message));
    }
  }

  void _increaseItemQuantity(
    IncreaseItemQuantityEvent event,
    Emitter<OrderState> emit,
  ) {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void _decreaseItemQuantity(
    DecreaseItemQuantityEvent event,
    Emitter<OrderState> emit,
  ) {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void _computeTotalAmount(
    ComputeTotalAmountEvent event,
    Emitter<OrderState> emit,
  ) {
    if (state.orderItems.isNotEmpty) {
      final amount =
          state.orderItems.map((e) => e.price! * e.quantity!).toList();
      final total = amount.reduce((value, element) => value + element);
      emit(state.copyWith(totalAmount: total));
    }
  }
}
