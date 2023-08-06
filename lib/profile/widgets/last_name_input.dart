import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LastNameInput extends StatelessWidget {
  const LastNameInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return TextFormField(
          key: const Key('profile_lastNameInput_textField'),
          initialValue: state.user!.lastname,
          onChanged: (lastName) => context
              .read<ProfileBloc>()
              .add(LastNameChangedEvent(value: lastName)),
          keyboardType: TextInputType.text,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.text_fields),
            labelText: l10n.profileLastNameLabel,
            helperText: '',
            errorText: state.lastName.displayError != null
                ? l10n.profileFirstNameErrorMessage
                : null,
          ),
        );
      },
    );
  }
}
