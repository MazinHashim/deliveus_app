import 'dart:math';

import 'package:deleveus_app/signin/bloc/phone_auth_bloc.dart';
import 'package:deleveus_app/signin/bloc/ticker.dart';
import 'package:deleveus_app/signin/view/opt_form.dart';
import 'package:deleveus_app/signin/view/phone_form.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: SigninPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneAuthBloc>(
      create: (_) => PhoneAuthBloc(
        context.read<AuthenticationRepository>(),
        ticker: const Ticker(),
      ),
      child: const SigninView(),
    );
  }
}

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication Failure'),
                ),
              );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Theme.of(context).primaryColorLight.withOpacity(0.5),
                    Colors.white
                  ],
                ),
              ),
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(
                  top: max(MediaQuery.of(context).size.height / 7, 20),
                ),
                child: !state.status.isSuccess && state.verificationId == null
                    ? PhoneForm(state: state)
                    : OtpForm(state: state),
              ),
            ),
          );
        },
      ),
    );
  }
}
