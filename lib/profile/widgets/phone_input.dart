import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneInput extends StatelessWidget {
  const PhoneInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return TextFormField(
          initialValue:
              state.user!.phone!.replaceFirst(RegExp('^[+]{1}966'), ''),
          readOnly: true,
          key: const Key('profile_phoneInput_textField'),
          onChanged: (phone) =>
              context.read<ProfileBloc>().add(PhoneChangedEvent(value: phone)),
          keyboardType: TextInputType.phone,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            prefixText: '+966',
            prefixIcon: const Icon(Icons.phone),
            labelText: l10n.signInInputLabelText,
            helperText: '',
            errorText: state.phone.displayError != null
                ? l10n.signInInputErrorMessage
                : null,
          ),
        );
      },
    );
  }
}
