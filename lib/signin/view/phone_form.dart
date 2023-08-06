import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/signin/bloc/phone_auth_bloc.dart';
import 'package:deleveus_app/signin/widgets/widgets.dart';
import 'package:deleveus_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class PhoneForm extends StatelessWidget {
  const PhoneForm({required this.state, super.key});

  final PhoneAuthState state;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        AppTitle(
          title: l10n.signInTitle,
          icon: Icons.lock,
          isAuth: true,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Image.asset('assets/imgs/phone-logo.png'),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: PhoneInput(),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: state.status.isInProgress
              ? const Center(
                  child: CircularProgressIndicator(strokeWidth: 1),
                )
              : ElevatedButton.icon(
                  onPressed: () {
                    // '+11789456123'
                    context.read<PhoneAuthBloc>().add(
                          SendOtpToPhoneEvent(phoneNumber: state.phone.value),
                        );
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: Text(l10n.sendOtpButtonText),
                ),
        ),
      ],
    );
  }
}
