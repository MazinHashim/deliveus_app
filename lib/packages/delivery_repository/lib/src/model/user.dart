import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
part 'user.g.dart';

/// Create user model
@immutable
@JsonSerializable()
class User extends Equatable {
  /// {@macro user}

  const User({
    required this.id,
    this.phone,
    this.email,
    this.firstname,
    this.lastname,
  });

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String id;

  /// The current user firstname
  final String? firstname;

  /// The current user lastname
  final String? lastname;

  /// the current user's phone number.
  final String? phone;

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  /// Returns a copy of this `todo` with the given values updated.
  ///
  /// {@macro todo_item}
  User copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  /// Deserializes the given [Map] into a [User].
  static User fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts this [User] into a [Map].
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  @override
  List<Object?> get props => [id, phone, email, firstname, lastname];
}
