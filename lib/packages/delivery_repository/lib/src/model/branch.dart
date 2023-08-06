import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template branch}
/// Branch model
///
/// {@endtemplate}
part 'branch.g.dart';

/// Create branch model
@immutable
@JsonSerializable()
class Branch extends Equatable {
  /// {@macro branch}

  const Branch({
    required this.id,
    this.name,
    this.address,
    this.prepareTime,
    this.isOpen,
    this.long,
    this.lat,
  });

  /// The branch name.
  final String? name;

  /// The branch id.
  final String id;

  /// The branch address
  final String? address;

  /// The branch prepareTime.
  final String? prepareTime;

  /// The branch isOpen.
  final bool? isOpen;

  /// The branch lat.
  final double? lat;

  /// The branch lat.
  final double? long;

  ///
  /// {@macro branch}
  Branch copyWith({
    String? id,
    String? name,
    String? address,
    String? prepareTime,
    bool? isOpen,
    double? lat,
    double? long,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      prepareTime: prepareTime ?? this.prepareTime,
      isOpen: isOpen ?? this.isOpen,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  /// Deserializes the given [Map] into a [Branch].
  static Branch fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);

  /// Converts this [Branch] into a [Map].
  Map<String, dynamic> toJson() => _$BranchToJson(this);

  @override
  List<Object?> get props => [
        name,
        id,
        address,
        prepareTime,
        isOpen,
        lat,
        long,
      ];
}
