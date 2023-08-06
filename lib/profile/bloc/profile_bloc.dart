import 'dart:async';

import 'package:delivery_repository/delivery_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this.userRepository, this.user)
      : super(ProfileState(user: user)) {
    on<UserProfileUpdatedEvent>(_updateUserProfile);

    on<FirstNameChangedEvent>((event, emit) {
      final firstname = FirstName.dirty(event.value);
      emit(
        state.copyWith(
          firstName: firstname,
          isValid: Formz.validate([firstname]),
        ),
      );
    });

    on<LastNameChangedEvent>((event, emit) {
      final lastname = LastName.dirty(event.value);
      emit(
        state.copyWith(
          lastName: lastname,
          isValid: Formz.validate([lastname]),
        ),
      );
    });

    on<EmailChangedEvent>((event, emit) {
      final email = Email.dirty(event.value);
      emit(
        state.copyWith(
          email: email,
          isValid: Formz.validate([email]),
        ),
      );
    });

    on<PhoneChangedEvent>((event, emit) {
      final phone = Phone.dirty(event.value);
      emit(
        state.copyWith(
          phone: phone,
          isValid: Formz.validate([phone]),
        ),
      );
    });

    on<ProfileErrorEvent>((event, emit) {
      emit(
        state.copyWith(
          errorMessage: event.error,
          status: FormzSubmissionStatus.failure,
        ),
      );
    });

    // add(PhoneChangedEvent(value: user.phone!));
    add(EmailChangedEvent(value: user.email!));
    add(FirstNameChangedEvent(value: user.firstname!));
    add(LastNameChangedEvent(value: user.lastname!));
  }

  final UserRepository userRepository;
  final User user;

  FutureOr<void> _updateUserProfile(
    UserProfileUpdatedEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final user = await userRepository.saveUserData(event.user);
      emit(state.copyWith(user: user, status: FormzSubmissionStatus.success));
    } on UserFailure catch (e, _) {
      add(ProfileErrorEvent(error: e.message));
    }
  }
}
