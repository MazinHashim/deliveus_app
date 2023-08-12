import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:deleveus_app/app/view/app.dart';
import 'package:deleveus_app/signin/bloc/phone_auth_bloc.dart';
import 'package:deleveus_app/widgets/custom_error_widget.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc.runtimeType == PhoneAuthBloc) {
      if (!(change.currentState as PhoneAuthState).timerStatus.isInProgress) {
        log('onChange(${bloc.runtimeType}, $change)');
      }
    } else {
      log('onChange(${bloc.runtimeType}, $change)');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp();

  // Add cross-flavor configuration here
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  final userRepository = UserRepository();

  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.dumpErrorToConsole(details);
  //   runApp(
  //     Directionality(
  //       textDirection: TextDirection.ltr,
  //       child: ErrorWidgetClass(errorDetails: details),
  //     ),
  //   );
  // };

  // runZonedGuarded(
  //   () =>
  runApp(
    App(
      authenticationRepository: authenticationRepository,
      userRepository: userRepository,
    ),
  );
  // ,
  // (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  // );
}

class ErrorWidgetClass extends StatelessWidget {
  const ErrorWidgetClass({required this.errorDetails, super.key});
  final FlutterErrorDetails errorDetails;
  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      errorMessage: errorDetails.exceptionAsString(),
    );
  }
}
