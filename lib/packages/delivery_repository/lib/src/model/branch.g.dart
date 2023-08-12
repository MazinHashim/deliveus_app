// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Branch _$BranchFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Branch',
      json,
      ($checkedConvert) {
        final val = Branch(
          id: $checkedConvert('id', (v) => v! as String),
          name: $checkedConvert('name', (v) => v as String?),
          address: $checkedConvert('address', (v) => v as String?),
          prepareTime: $checkedConvert('prepare_time', (v) => v as String?),
          openingTime: $checkedConvert(
            'opening_time',
            (v) => v == null
                ? null
                : DateTime.fromMicrosecondsSinceEpoch(
                    (v as Timestamp).microsecondsSinceEpoch,
                  ),
          ),
          closingTime: $checkedConvert(
            'closing_time',
            (v) => v == null
                ? null
                : DateTime.fromMicrosecondsSinceEpoch(
                    (v as Timestamp).microsecondsSinceEpoch,
                  ),
          ),
          distance: $checkedConvert('distance', (v) => (v as num?)?.toDouble()),
          long: $checkedConvert('long', (v) => (v as num?)?.toDouble()),
          lat: $checkedConvert('lat', (v) => (v as num?)?.toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'prepareTime': 'prepare_time',
        'openingTime': 'opening_time',
        'closingTime': 'closing_time'
      },
    );

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'name': instance.name,
      // 'id': instance.id,instance.distance
      'address': instance.address,
      'prepare_time': instance.prepareTime,
      'opening_time': instance.openingTime,
      'closing_time': instance.closingTime,
      'lat': instance.lat,
      'long': instance.long,
    };
