import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/signin/bloc/phone_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
      buildWhen: (previous, current) => previous.otp != current.otp,
      builder: (context, state) {
        return TextField(
          key: const Key('signinForm_otpInput_textField'),
          onChanged: (otp) => context
              .read<PhoneAuthBloc>()
              .add(OtpCodeChangedEvent(value: otp)),
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.numbers),
            labelText: l10n.otpInputLabelText,
            helperText: '',
            errorText: state.otp.displayError != null
                ? 'invalid verification code format'
                : null,
          ),
        );
      },
    );
  }
}
