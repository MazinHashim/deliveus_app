import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/theme.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    super.key,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository;

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _userRepository),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
          userRepository: _userRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final bloc = context.watch<AppBloc>();
    final locale = bloc.state.locale;
    return MaterialApp(
      theme: theme.copyWith(
        textTheme: locale.languageCode == 'ar'
            ? GoogleFonts.tajawalTextTheme().copyWith(
                bodyLarge:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                labelLarge:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              )
            : GoogleFonts.barlowCondensedTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: FlowBuilder<AppStatus>(
        state: bloc.state.status,
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
