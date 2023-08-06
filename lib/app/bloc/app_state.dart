part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

final class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.locale = const Locale('en'),
    this.user = User.empty,
  });

  // const AppState.authenticated(User user)
  //     : this._(status: AppStatus.authenticated, user: user);

  // const AppState.unauthenticated()
  //     : this._(status: AppStatus.unauthenticated);

  AppState copyWith({
    AppStatus? status,
    User? user,
    Locale? locale,
  }) {
    return AppState._(
      status: status ?? this.status,
      user: user ?? this.user,
      locale: locale ?? this.locale,
    );
  }

  final AppStatus status;
  final User user;
  final Locale locale;

  @override
  List<Object> get props => [status, locale, user];
}
