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
          isOpen: $checkedConvert('is_open', (v) => v as bool?),
          long: $checkedConvert('long', (v) => (v as num?)?.toDouble()),
          lat: $checkedConvert('lat', (v) => (v as num?)?.toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {'prepareTime': 'prepare_time', 'isOpen': 'is_open'},
    );

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'name': instance.name,
      // 'id': instance.id,
      'address': instance.address,
      'prepare_time': instance.prepareTime,
      'is_open': instance.isOpen,
      'lat': instance.lat,
      'long': instance.long,
    };
