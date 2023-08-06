import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState._(
                  status: AppStatus.authenticated,
                  user: authenticationRepository.currentUser,
                )
              : const AppState._(status: AppStatus.unauthenticated),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppLanguageChanged>(_onLanguageChanged);
    _userSubscription = _authenticationRepository.user.listen((user) async {
      if (user.isNotEmpty) {
        final readedUser =
            await _userRepository.getUserData(user, toSignIn: true);
        add(AppUserChanged(readedUser));
      } else {
        add(AppUserChanged(user));
      }
    });
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late final StreamSubscription<User> _userSubscription;

  Future<void> _onUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) async {
    if (event.user.isNotEmpty) {
      emit(
        state.copyWith(
          status: AppStatus.authenticated,
          user: event.user,
          locale: state.locale,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AppStatus.unauthenticated,
          user: User.empty,
          locale: state.locale,
        ),
      );
    }
  }

  void _onLanguageChanged(AppLanguageChanged event, Emitter<AppState> emit) {
    emit(state.copyWith(locale: event.locale));
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
