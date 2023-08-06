import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          key: const Key('profile_emailInput_textField'),
          initialValue: state.user!.email,
          onChanged: (email) =>
              context.read<ProfileBloc>().add(EmailChangedEvent(value: email)),
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            labelText: l10n.profileEmailLabel,
            helperText: '',
            errorText: state.email.displayError != null
                ? l10n.profileEmailErrorMessage
                : null,
          ),
        );
      },
    );
  }
}
