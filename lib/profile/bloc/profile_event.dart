part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class UserProfileUpdatedEvent extends ProfileEvent {
  const UserProfileUpdatedEvent({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

class ProfileErrorEvent extends ProfileEvent {
  const ProfileErrorEvent({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}

class PhoneChangedEvent extends ProfileEvent {
  const PhoneChangedEvent({required this.value});

  final String value;

  @override
  List<Object> get props => [value];
}

class FirstNameChangedEvent extends ProfileEvent {
  const FirstNameChangedEvent({required this.value});

  final String value;

  @override
  List<Object> get props => [value];
}

class LastNameChangedEvent extends ProfileEvent {
  const LastNameChangedEvent({required this.value});

  final String value;

  @override
  List<Object> get props => [value];
}

class EmailChangedEvent extends ProfileEvent {
  const EmailChangedEvent({required this.value});

  final String value;

  @override
  List<Object> get props => [value];
}
