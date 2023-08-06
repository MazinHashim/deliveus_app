import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/profile/profile.dart';
import 'package:deleveus_app/profile/widgets/widgets.dart';
import 'package:deleveus_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({required this.state, super.key});

  final ProfileState state;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        const Divider(),
        AppTitle(title: l10n.profileTitle, icon: Icons.account_box),
        const Divider(),
        const Padding(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            children: [
              PhoneInput(),
              FirstNameInput(),
              LastNameInput(),
              EmailInput(),
            ],
          ),
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
                    final updatedUser = state.user!.copyWith(
                      email: state.email.value,
                      firstname: state.firstName.value,
                      lastname: state.lastName.value,
                    );
                    context
                        .read<ProfileBloc>()
                        .add(UserProfileUpdatedEvent(user: updatedUser));
                    context.read<AppBloc>().add(AppUserChanged(updatedUser));
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save),
                  label: Text(l10n.profileSaveButton),
                ),
        ),
      ],
    );
  }
}
