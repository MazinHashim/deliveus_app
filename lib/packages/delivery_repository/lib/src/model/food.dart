import 'package:delivery_repository/delivery_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template food}
/// Food model
///
/// {@endtemplate}
part 'food.g.dart';

/// Create food model
@immutable
@JsonSerializable()
class Food extends Equatable {
  /// {@macro food}

  const Food({
    required this.id,
    this.name,
    this.price,
    this.description,
    this.isSpaicy,
    this.calories,
    this.photo,
    this.category,
    this.ratings,
  });

  /// The food name.
  final String? name;

  /// The food id.
  final String id;

  /// The food price
  final double? price;

  /// The food description.
  final String? description;

  /// The food isSpaicy.
  final bool? isSpaicy;

  /// The food calories
  final List<Calorie>? calories;

  /// The food photo.
  final String? photo;

  /// The food category.
  final String? category;

  /// The food ratings
  final List<Rating>? ratings;

  ///
  /// {@macro food_item}
  Food copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    bool? isSpaicy,
    List<Calorie>? calories,
    String? photo,
    String? category,
    List<Rating>? ratings,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      isSpaicy: isSpaicy ?? this.isSpaicy,
      calories: calories ?? this.calories,
      photo: photo ?? this.photo,
      category: category ?? this.category,
      ratings: ratings ?? this.ratings,
    );
  }

  /// Deserializes the given [Map] into a [Food].
  static Food fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

  /// Converts this [Food] into a [Map].
  Map<String, dynamic> toJson() => _$FoodToJson(this);

  // /// Empty user which represents an unauthenticated user.
  // static const empty = User(id: '');

  @override
  List<Object?> get props => [
        name,
        id,
        price,
        description,
        isSpaicy,
        calories,
        photo,
        category,
        ratings
      ];
}
