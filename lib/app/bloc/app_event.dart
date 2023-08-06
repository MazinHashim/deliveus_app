part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

final class AppLanguageChanged extends AppEvent {
  const AppLanguageChanged(this.locale);

  final Locale locale;
}

final class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User user;
}
