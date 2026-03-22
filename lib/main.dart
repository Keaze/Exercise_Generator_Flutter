import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/app.dart';

void main() async {
  // Must be called before any plugin (SharedPreferences) is accessed.
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-load once so App and HomePage can read/write synchronously.
  final prefs = await SharedPreferences.getInstance();
  runApp(App(prefs: prefs));
}
