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
    this.orderNumber,
    this.amount,
    this.taxFee,
    this.deliveryFee,
    this.status,
    this.orderDate,
    this.orderingTime,
    this.cookingTime,
    this.deliveringTime,
    this.fromBranch,
    this.address,
    this.destinationLat,
    this.destinationLong,
  });

  /// The Order user_id.
  final String? userId;

  /// The Order id.
  final String id;

  /// The Order order_items
  final List<OrderItem>? orderItems;

  /// The Order orderNumber.
  final int? orderNumber;

  /// The Order amount.
  final double? amount;

  /// The Order taxFee.
  final double? taxFee;

  /// The Order deliveryFee.
  final double? deliveryFee;

  /// The Order status.
  final OrderStatus? status;

  /// The Order orderDate.
  final DateTime? orderDate;

  /// The Order orderingTime.
  final String? orderingTime;

  /// The Order cookingTime.
  final String? cookingTime;

  /// The Order deliveringTime.
  final String? deliveringTime;

  /// The Order branch destination.
  final String? fromBranch;

  /// The Order destination address.
  final String? address;

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
    int? orderNumber,
    double? amount,
    double? deliveryFee,
    double? taxFee,
    OrderStatus? status,
    DateTime? orderDate,
    String? cookingTime,
    String? orderingTime,
    String? deliveringTime,
    String? fromBranch,
    String? address,
    double? destinationLat,
    double? destinationLong,
  }) {
    return Order(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      orderItems: orderItems ?? this.orderItems,
      orderNumber: orderNumber ?? this.orderNumber,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      taxFee: taxFee ?? this.taxFee,
      cookingTime: cookingTime,
      orderingTime: orderingTime,
      deliveringTime: deliveringTime,
      fromBranch: fromBranch,
      address: address,
      destinationLat: destinationLat,
      destinationLong: destinationLong,
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
        orderNumber,
        amount,
        status,
        orderDate,
        cookingTime,
        orderingTime,
        deliveringTime,
        deliveryFee,
        taxFee,
        fromBranch,
        address,
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
  failure,

  ///
  ordering,

  ///
  cooking,

  ///
  delivering,

  ///
  received
}
