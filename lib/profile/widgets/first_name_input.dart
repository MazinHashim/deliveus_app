import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstNameInput extends StatelessWidget {
  const FirstNameInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return TextFormField(
          initialValue: state.user!.firstname,
          key: const Key('profile_firstnameInput_textField'),
          onChanged: (firstname) => context
              .read<ProfileBloc>()
              .add(FirstNameChangedEvent(value: firstname)),
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.text_fields),
            labelText: l10n.profileFirstNameLabel,
            helperText: '',
            errorText: state.firstName.displayError != null
                ? l10n.profileFirstNameErrorMessage
                : null,
          ),
        );
      },
    );
  }
}
