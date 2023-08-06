part of 'order_bloc.dart';

class OrderState extends Equatable {
  const OrderState({
    this.orderItems = const [],
    this.order = const Order(id: '', status: OrderStatus.initial),
    this.prevOrders = const [],
    this.totalAmount = 0.0,
    this.quantity = 1,
    this.errorMessage = '',
  });

  final List<OrderItem> orderItems;
  final Order order;
  final List<Order> prevOrders;
  final double totalAmount;
  final int quantity;
  final String errorMessage;

  @override
  List<Object?> get props =>
      [orderItems, order, quantity, prevOrders, totalAmount, errorMessage];

  OrderState copyWith({
    List<OrderItem>? orderItems,
    Order? order,
    List<Order>? prevOrders,
    double? totalAmount,
    int? quantity,
    String? errorMessage,
  }) {
    return OrderState(
      orderItems: orderItems ?? this.orderItems,
      order: order ?? this.order,
      prevOrders: prevOrders ?? this.prevOrders,
      totalAmount: totalAmount ?? this.totalAmount,
      quantity: quantity ?? this.quantity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
