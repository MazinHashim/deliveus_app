import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    required this.title,
    this.icon,
    this.isAuth = false,
    super.key,
  });

  final String title;
  final IconData? icon;
  final bool isAuth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment:
            isAuth ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          if (!isAuth)
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
          if (!isAuth) const Spacer(),
          if (icon != null)
            Icon(
              icon,
              size: 33,
              color: Theme.of(context).primaryColor,
            ),
          const SizedBox(width: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25),
          ),
          const Spacer(),
          if (isAuth)
            TextButton.icon(
              label: Text(
                context.l10n.localeName == 'en' ? 'Arabic' : 'English',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () => context.read<AppBloc>().add(
                    AppLanguageChanged(
                      Locale(context.l10n.localeName == 'en' ? 'ar' : 'en'),
                    ),
                  ),
              icon: Icon(
                Icons.g_translate,
                color: Theme.of(context).primaryColor,
              ),
            )
        ],
      ),
    );
  }
}
