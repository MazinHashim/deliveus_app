import 'package:deleveus_app/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  bootstrap();
  // whenever your initialization is completed, remove the splash screen:
  // FlutterNativeSplash.remove();
}
