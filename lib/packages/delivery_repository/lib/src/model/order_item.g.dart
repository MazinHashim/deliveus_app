// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OrderItem',
      json,
      ($checkedConvert) {
        final val = OrderItem(
          foodId: $checkedConvert('food_id', (v) => v! as String),
          title: $checkedConvert('title', (v) => v as String?),
          price: $checkedConvert('price', (v) => (v as num?)?.toDouble()),
          quantity: $checkedConvert('quantity', (v) => v as int?),
        );
        return val;
      },
      fieldKeyMap: const {'foodId': 'food_id'},
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'title': instance.title,
      'food_id': instance.foodId,
      'price': instance.price,
      'quantity': instance.quantity,
    };
