import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 22, left: 10, right: 10),
        child: Column(
          children: [
            const Divider(),
            AppTitle(title: l10n.settingsTitle, icon: Icons.settings),
            const Divider(),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              title: Text(
                l10n.languageSettingsSubtitle,
                style: const TextStyle(fontSize: 18),
              ),
              minLeadingWidth: 0,
              leading: const Icon(Icons.g_translate, color: Colors.black),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  appLanguageToggle(context, 'English', 'en'),
                  const SizedBox(width: 20),
                  appLanguageToggle(context, 'Arabic', 'ar'),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.only(left: 10, right: 10, top: 20),
              title: Text(
                l10n.accountSettingsSubtitle,
                style: const TextStyle(fontSize: 20),
              ),
              minLeadingWidth: 0,
              leading: const Icon(Icons.account_circle, color: Colors.black),
            ),
            ListTile(
              onTap: () {},
              selected: true,
              style: ListTileStyle.drawer,
              splashColor: Colors.red.shade100,
              minLeadingWidth: 0,
              selectedColor: Colors.red,
              leading: const Icon(Icons.delete),
              title: Text(l10n.deleteMyAccountText),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<AppBloc>().add(const AppLogoutRequested());
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout_outlined),
                label: Text(l10n.signOutButtonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded appLanguageToggle(BuildContext context, String title, String code) {
    return Expanded(
      child: InkWell(
        onTap: context.l10n.localeName == code
            ? null
            : () {
                context.read<AppBloc>().add(
                      AppLanguageChanged(
                        Locale(context.l10n.localeName == 'en' ? 'ar' : 'en'),
                      ),
                    );
              },
        child: Container(
          height: MediaQuery.of(context).size.height / 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: context.l10n.localeName == code
                ? null
                : const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
            color: context.l10n.localeName != code
                ? Colors.white
                : Theme.of(context).primaryColorLight.withOpacity(0.7),
          ),
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
