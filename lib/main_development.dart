import 'package:deleveus_app/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await bootstrap();
  // whenever your initialization is completed, remove the splash screen:
  // FlutterNativeSplash.remove();
}
