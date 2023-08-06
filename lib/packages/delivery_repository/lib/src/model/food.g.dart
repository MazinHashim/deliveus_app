// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Food _$FoodFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Food',
      json,
      ($checkedConvert) {
        final val = Food(
          id: $checkedConvert('id', (v) => v! as String),
          name: $checkedConvert('name', (v) => v as String?),
          price: $checkedConvert('price', (v) => (v as num?)?.toDouble()),
          description: $checkedConvert('description', (v) => v as String?),
          isSpaicy: $checkedConvert('is_spaicy', (v) => v as bool?),
          calories: $checkedConvert(
            'calories',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Calorie.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          photo: $checkedConvert('photo', (v) => v as String?),
          category: $checkedConvert('category', (v) => v as String?),
          ratings: $checkedConvert(
            'ratings',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Rating.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {'isSpaicy': 'is_spaicy'},
    );

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'price': instance.price,
      'description': instance.description,
      'is_spaicy': instance.isSpaicy,
      'calories': instance.calories,
      'photo': instance.photo,
      'category': instance.category,
      'ratings': instance.ratings,
    };
