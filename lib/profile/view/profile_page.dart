import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/profile/bloc/profile_bloc.dart';
import 'package:deleveus_app/profile/profile.dart';
import 'package:deleveus_app/profile/view/profile_form.dart';
import 'package:deleveus_app/widgets/app_page_widget.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: ProfilePage());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(context.read<UserRepository>(), user),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ProfileBloc, ProfileState>(
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
        return AppPageWidget(
          title: l10n.profileTitle,
          space: 100,
          child: ProfileForm(state: state),
        );
      },
    );
  }
}
