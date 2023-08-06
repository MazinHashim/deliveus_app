import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template order}
/// Order model
///
/// {@endtemplate}
part 'order.g.dart';

/// Create order model
@immutable
@JsonSerializable()
class Order extends Equatable {
  /// {@macro order}

  const Order({
    required this.id,
    this.userId,
    this.orderItems,
    this.amount,
    this.status,
    this.orderDate,
    this.waitingTime,
    this.deliveryTime,
    this.fromBranch,
    this.destinationLat,
    this.destinationLong,
  });

  /// The Order user_id.
  final String? userId;

  /// The Order id.
  final String id;

  /// The Order order_items
  final List<OrderItem>? orderItems;

  /// The Order amount.
  final double? amount;

  /// The Order status.
  final OrderStatus? status;

  /// The Order orderDate.
  final DateTime? orderDate;

  /// The Order waitingTime.
  final String? waitingTime;

  /// The Order deliveryTime.
  final String? deliveryTime;

  /// The Order branch destination.
  final String? fromBranch;

  /// The Order destination Latitude.
  final double? destinationLat;

  /// The Order destination Longitude.
  final double? destinationLong;

  ///
  /// {@macro order}
  Order copyWith({
    String? userId,
    String? id,
    List<OrderItem>? orderItems,
    double? amount,
    OrderStatus? status,
    DateTime? orderDate,
    String? waitingTime,
    String? deliveryTime,
    String? fromBranch,
    double? destinationLat,
    double? destinationLong,
  }) {
    return Order(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      orderItems: orderItems ?? this.orderItems,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      waitingTime: waitingTime ?? this.waitingTime,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      fromBranch: fromBranch ?? this.fromBranch,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLong: destinationLong ?? this.destinationLong,
    );
  }

  /// Deserializes the given [Map] into a [Order].
  static Order fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// Converts this [Order] into a [Map].
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  List<Object?> get props => [
        userId,
        id,
        orderItems,
        amount,
        status,
        orderDate,
        waitingTime,
        deliveryTime,
        fromBranch,
        destinationLat,
        destinationLong,
      ];
}

///
enum OrderStatus {
  ///
  initial,

  ///
  progressing,

  ///
  ordered,

  ///
  processing,

  ///
  shipped,

  ///
  received,

  ///
  failure
}
