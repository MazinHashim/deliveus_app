part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.phone = const Phone.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.email = const Email.pure(),
    this.user,
    this.errorMessage,
  });

  final Phone phone;
  final FormzSubmissionStatus status;
  final bool isValid;
  final Email email;
  final FirstName firstName;
  final LastName lastName;
  final User? user;
  final String? errorMessage;

  @override
  List<Object?> get props =>
      [phone, status, email, user, firstName, lastName, isValid, errorMessage];

  ProfileState copyWith({
    Phone? phone,
    FormzSubmissionStatus? status,
    bool? isValid,
    FirstName? firstName,
    LastName? lastName,
    Email? email,
    User? user,
    String? errorMessage,
  }) {
    return ProfileState(
      phone: phone ?? this.phone,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
