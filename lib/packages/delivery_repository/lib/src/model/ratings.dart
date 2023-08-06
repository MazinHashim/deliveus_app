import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template calorie}
/// Rating model
///
/// {@endtemplate}
part 'ratings.g.dart';

/// Create rating model
@immutable
@JsonSerializable()
class Rating extends Equatable {
  /// {@macro rating}

  const Rating({
    this.value,
    this.userId,
  });

  /// The rating userId.
  final String? userId;

  /// The rating value
  final int? value;

  ///
  /// {@macro rating_item}
  Rating copyWith({
    String? userId,
    int? value,
  }) {
    return Rating(
      userId: userId ?? this.userId,
      value: value ?? this.value,
    );
  }

  /// Deserializes the given [Map] into a [Rating].
  static Rating fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  /// Converts this [Rating] into a [Map].
  Map<String, dynamic> toJson() => _$RatingToJson(this);

  // /// Empty user which represents an unauthenticated user.
  // static const empty = User(id: '');

  @override
  List<Object?> get props => [value, userId];
}
