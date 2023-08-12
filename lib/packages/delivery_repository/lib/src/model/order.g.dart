// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Order',
      json,
      ($checkedConvert) {
        final val = Order(
          id: $checkedConvert('id', (v) => v! as String),
          userId: $checkedConvert('user_id', (v) => v as String?),
          orderItems: $checkedConvert(
            'order_items',
            (v) => (v as List<dynamic>?)
                ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          orderNumber:
              $checkedConvert('order_number', (v) => (v as num?)?.toInt()),
          amount: $checkedConvert('amount', (v) => (v as num?)?.toDouble()),
          deliveryFee:
              $checkedConvert('delivery_fee', (v) => (v as num?)?.toDouble()),
          taxFee: $checkedConvert('tax_fee', (v) => (v as num?)?.toDouble()),
          status: $checkedConvert(
            'status',
            (v) => $enumDecodeNullable(_$OrderStatusEnumMap, v),
          ),
          orderDate: $checkedConvert(
            'order_date',
            (v) => v == null
                ? null
                : DateTime.fromMicrosecondsSinceEpoch(
                    (v as Timestamp).microsecondsSinceEpoch,
                  ),
          ),
          waitingTime: $checkedConvert('waiting_time', (v) => v as String?),
          deliveryTime: $checkedConvert('delivery_time', (v) => v as String?),
          fromBranch: $checkedConvert('from_branch', (v) => v as String?),
          destinationLat:
              $checkedConvert('destination_lat', (v) => v as double?),
          destinationLong:
              $checkedConvert('destination_long', (v) => v as double?),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'user_id',
        'orderItems': 'order_items',
        'orderNumber': 'order_number',
        'orderDate': 'order_date',
        'waitingTime': 'waiting_time',
        'deliveryTime': 'delivery_time',
        'deliveryFee': 'delivery_fee',
        'taxFee': 'tax_fee',
        'fromBranch': 'from_branch',
        'destinationLat': 'destination_lat',
        'destinationLong': 'destination_long'
      },
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'user_id': instance.userId,
      // 'id': instance.id,
      'order_items': instance.orderItems?.map((e) => e.toJson()).toList(),
      'order_number': instance.orderNumber,
      'amount': instance.amount,
      'delivery_time': instance.deliveryTime,
      'delivery_fee': instance.deliveryFee,
      'status': _$OrderStatusEnumMap[instance.status],
      'order_date': instance.orderDate,
      'waiting_time': instance.waitingTime,
      'tax_fee': instance.taxFee,
      'from_branch': instance.fromBranch,
      'destination_lat': instance.destinationLat,
      'destination_long': instance.destinationLong,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.initial: 'initial',
  OrderStatus.progressing: 'progressing',
  OrderStatus.ordered: 'ordered',
  OrderStatus.processing: 'processing',
  OrderStatus.shipped: 'shipped',
  OrderStatus.received: 'received',
  OrderStatus.failure: 'failure',
};
