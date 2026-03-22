import 'package:flutter/material.dart';
import 'package:aufgabengenerator_flutter/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

const _kThemeMode = 'theme_mode';

class App extends StatefulWidget {
  const App({super.key, required this.prefs});

  /// Pre-loaded SharedPreferences instance injected from main().
  final SharedPreferences prefs;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    // Synchronous read — instance is already loaded.
    // Persisted by name so enum reordering doesn't corrupt stored preferences.
    final saved = widget.prefs.getString(_kThemeMode);
    _themeMode = saved != null
        ? ThemeMode.values.firstWhere(
            (m) => m.name == saved,
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.system;
  }

  void _cycleTheme() {
    final next = switch (_themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    setState(() => _themeMode = next);
    // Fire-and-forget: theme persistence is non-critical; errors are silent
    // by design (UI state, not user data).
    widget.prefs.setString(_kThemeMode, next.name);
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Colors.indigo;
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomePage(
        prefs: widget.prefs,
        themeMode: _themeMode,
        onThemeToggle: _cycleTheme,
      ),
    );
  }
}
