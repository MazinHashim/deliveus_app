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
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment:
            isAuth ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          if (!isAuth)
            Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
          // const Icon(Icons.arrow_back_ios),
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
                l10n.localeName == 'en' ? 'Arabic' : 'English',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () => context.read<AppBloc>().add(
                    AppLanguageChanged(
                      Locale(l10n.localeName == 'en' ? 'ar' : 'en'),
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
