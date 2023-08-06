import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/home/home.dart';
import 'package:deleveus_app/signin/signin.dart';
import 'package:flutter/widgets.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.unauthenticated:
      return [SigninPage.page()];
    case AppStatus.authenticated:
      return [HomePage.page()];
    // case AppStatus.profile:
    //   return [HomePage.page(), ProfilePage.page()];
    // case AppStatus.settings:
    //   return [HomePage.page(), SettingsPage.page()];
    // case AppStatus.search:
    //   return [HomePage.page(), SearchPage.page()];
    // case AppStatus.history:
    //   return [HomePage.page(), HistoryPage.page()];
  }
}
