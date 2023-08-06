import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template calorie}
/// Calorie model
///
/// {@endtemplate}
part 'calorie.g.dart';

/// Create Calorie model
@immutable
@JsonSerializable()
class Calorie extends Equatable {
  /// {@macro calorie}

  const Calorie({
    this.title,
    this.amount,
  });

  /// The calorie title.
  final String? title;

  /// The calorie amount
  final int? amount;

  ///
  /// {@macro calorie_item}
  Calorie copyWith({
    String? title,
    int? amount,
  }) {
    return Calorie(
      title: title ?? this.title,
      amount: amount ?? this.amount,
    );
  }

  /// Deserializes the given [Map] into a [Calorie].
  static Calorie fromJson(Map<String, dynamic> json) => _$CalorieFromJson(json);

  /// Converts this [Calorie] into a [Map].
  Map<String, dynamic> toJson() => _$CalorieToJson(this);

  // /// Empty user which represents an unauthenticated user.
  // static const empty = User(id: '');

  @override
  List<Object?> get props => [title, amount];
}
