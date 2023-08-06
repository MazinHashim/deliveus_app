// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'ratings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Rating',
      json,
      ($checkedConvert) {
        final val = Rating(
          value: $checkedConvert('value', (v) => v as int?),
          userId: $checkedConvert('user_id', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'userId': 'user_id'},
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'user_id': instance.userId,
      'value': instance.value,
    };
