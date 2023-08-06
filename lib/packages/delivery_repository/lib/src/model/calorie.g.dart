// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'calorie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Calorie _$CalorieFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Calorie',
      json,
      ($checkedConvert) {
        final val = Calorie(
          title: $checkedConvert('title', (v) => v as String?),
          amount: $checkedConvert('amount', (v) => v as int?),
        );
        return val;
      },
    );

Map<String, dynamic> _$CalorieToJson(Calorie instance) => <String, dynamic>{
      'title': instance.title,
      'amount': instance.amount,
    };
