import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template order_item}
/// OrderItem model
///
/// {@endtemplate}
part 'order_item.g.dart';

/// Create order_item model
@immutable
@JsonSerializable()
class OrderItem extends Equatable {
  /// {@macro order_item}

  const OrderItem({
    required this.foodId,
    this.title,
    this.price,
    this.quantity,
  });

  /// The OrderItem title.
  final String? title;

  /// The OrderItem foodId.
  final String foodId;

  /// The OrderItem price
  final double? price;

  /// The OrderItem quantity.
  final int? quantity;

  ///
  /// {@macro order_item}
  OrderItem copyWith({
    String? foodId,
    String? title,
    double? price,
    int? quantity,
  }) {
    return OrderItem(
      foodId: foodId ?? this.foodId,
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Deserializes the given [Map] into a [OrderItem].
  static OrderItem fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  /// Converts this [OrderItem] into a [Map].
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  @override
  List<Object?> get props => [foodId, title, price, quantity];
}
