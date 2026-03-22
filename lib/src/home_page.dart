import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aufgabengenerator_flutter/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transformation_options.dart';
import 'widgets/input_section.dart';
import 'widgets/options_section.dart';
import 'widgets/output_section.dart';
import 'widgets/replace_section.dart';

// Material 3 compact/medium breakpoint — see m3.material.io/foundations/layout
const _wideLayoutBreakpoint = 600.0;
const _symbolPool = r'!@#$%^&*+=?/~|<>';

// SharedPreferences keys for persisted state.
const _kShuffleWords = 'shuffle_words';
const _kScramble = 'scramble';
const _kMirrorWords = 'mirror_words';
const _kRemoveSpaces = 'remove_spaces';
const _kCaseMode = 'case_mode';
const _kShowReplace = 'show_replace';
const _kLettersToReplace = 'letters_to_replace';
const _kReplacementSymbols = 'replacement_symbols';
const _kMirror = 'mirror';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.prefs,
    required this.themeMode,
    required this.onThemeToggle,
  });

  /// Pre-loaded SharedPreferences instance injected from App.
  final SharedPreferences prefs;
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _inputController = TextEditingController();

  late TransformationConfig _config;

  /// Whether the replace-letters panel is visible.
  /// Kept separate from [TransformationConfig] because it is a UI concern;
  /// the pipeline activates replacement based solely on field content.
  late bool _showReplace;

  int _generation = 0;

  static String? _safeGetString(SharedPreferences p, String key) {
    try {
      return p.getString(key);
    } catch (_) {
      p.remove(key);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_refresh);
    // Synchronous reads — SharedPreferences instance is pre-loaded.
    final p = widget.prefs;
    _config = TransformationConfig(
      shuffleWords: p.getBool(_kShuffleWords) ?? false,
      scramble: p.getBool(_kScramble) ?? false,
      mirrorWords: p.getBool(_kMirrorWords) ?? false,
      removeSpaces: p.getBool(_kRemoveSpaces) ?? false,
      caseMode: () {
        String? saved;
        try {
          saved = p.getString(_kCaseMode);
        } catch (_) {
          p.remove(_kCaseMode);
        }
        return saved != null
            ? CaseMode.values.firstWhere(
                (m) => m.name == saved,
                orElse: () => CaseMode.none,
              )
            : CaseMode.none;
      }(),
      lettersToReplace: _safeGetString(p, _kLettersToReplace) ?? '',
      replacementSymbols: _safeGetString(p, _kReplacementSymbols) ?? '',
      mirror: p.getBool(_kMirror) ?? false,
    );
    _showReplace = p.getBool(_kShowReplace) ?? false;
  }

  void _refresh() => setState(() {});

  // Fire-and-forget writes: UI state is non-critical; errors are silent by
  // design. The prefs instance is already loaded so writes complete quickly.
  void _savePrefs() {
    final p = widget.prefs;
    p.setBool(_kShuffleWords, _config.shuffleWords);
    p.setBool(_kScramble, _config.scramble);
    p.setBool(_kMirrorWords, _config.mirrorWords);
    p.setBool(_kRemoveSpaces, _config.removeSpaces);
    p.setString(_kCaseMode, _config.caseMode.name);
    p.setBool(_kShowReplace, _showReplace);
    p.setString(_kLettersToReplace, _config.lettersToReplace);
    p.setString(_kReplacementSymbols, _config.replacementSymbols);
    p.setBool(_kMirror, _config.mirror);
  }

  void _updateConfig(TransformationConfig config) {
    setState(() => _config = config);
    _savePrefs();
  }

  void _updateShowReplace(bool show) {
    setState(() {
      _showReplace = show;
      // Turning the panel off clears the fields so the pipeline also stops.
      if (!show) {
        _config = _config.copyWith(lettersToReplace: '', replacementSymbols: '');
      }
    });
    _savePrefs();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Random get _random => Random(computeSeed(_inputController.text, _generation));

  String get _output =>
      applyTransformations(_inputController.text, _config, _random);

  void _reroll() => setState(() => _generation++);

  void _generateRandomSymbols() {
    final count = _config.lettersToReplace.isEmpty
        ? 5
        : _config.lettersToReplace.length;
    final pool = _symbolPool.split('')..shuffle(Random());
    _updateConfig(
        _config.copyWith(replacementSymbols: pool.take(count).join()));
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _output));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.copiedFeedback),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        width: 280,
      ),
    );
  }

  OptionsSection _buildOptionsSection() => OptionsSection(
        config: _config,
        onChanged: _updateConfig,
        showReplace: _showReplace,
        onShowReplaceChanged: _updateShowReplace,
      );

  ReplaceSection _buildReplaceSection() => ReplaceSection(
        lettersToReplace: _config.lettersToReplace,
        onLettersChanged: (v) => _updateConfig(_config.copyWith(lettersToReplace: v)),
        replacementSymbols: _config.replacementSymbols,
        onSymbolsChanged: (v) => _updateConfig(_config.copyWith(replacementSymbols: v)),
        onGenerateRandom: _generateRandomSymbols,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final optionsSection = _buildOptionsSection();
    final replaceSection = _showReplace ? _buildReplaceSection() : null;
    final output = _output;
    final onReroll = _config.hasRandomTransforms ? _reroll : null;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          IconButton(
            icon: Icon(switch (widget.themeMode) {
              ThemeMode.system => Icons.brightness_auto_rounded,
              ThemeMode.light => Icons.light_mode_rounded,
              ThemeMode.dark => Icons.dark_mode_rounded,
            }),
            tooltip: l10n.toggleTheme,
            onPressed: widget.onThemeToggle,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= _wideLayoutBreakpoint) {
            return _WideLayout(
              inputController: _inputController,
              optionsSection: optionsSection,
              replaceSection: replaceSection,
              output: output,
              onCopy: _copyToClipboard,
              onReroll: onReroll,
            );
          }
          return _NarrowLayout(
            inputController: _inputController,
            optionsSection: optionsSection,
            replaceSection: replaceSection,
            output: output,
            onCopy: _copyToClipboard,
            onReroll: onReroll,
          );
        },
      ),
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({
    required this.inputController,
    required this.optionsSection,
    required this.replaceSection,
    required this.output,
    required this.onCopy,
    required this.onReroll,
  });

  final TextEditingController inputController;
  final OptionsSection optionsSection;
  final ReplaceSection? replaceSection;
  final String output;
  final VoidCallback onCopy;
  final VoidCallback? onReroll;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputSection(controller: inputController),
          const SizedBox(height: 12),
          optionsSection,
          _AnimatedReplaceSection(section: replaceSection),
          const SizedBox(height: 12),
          OutputSection(text: output, onCopy: onCopy, onReroll: onReroll),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.inputController,
    required this.optionsSection,
    required this.replaceSection,
    required this.output,
    required this.onCopy,
    required this.onReroll,
  });

  final TextEditingController inputController;
  final OptionsSection optionsSection;
  final ReplaceSection? replaceSection;
  final String output;
  final VoidCallback onCopy;
  final VoidCallback? onReroll;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputSection(controller: inputController),
                const SizedBox(height: 12),
                optionsSection,
                _AnimatedReplaceSection(section: replaceSection),
              ],
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: OutputSection(
              text: output,
              onCopy: onCopy,
              onReroll: onReroll,
              expanded: true,
            ),
          ),
        ),
      ],
    );
  }
}

/// Wraps [section] in an animated expand/collapse container.
/// A proper widget (rather than a free function) ensures Flutter's
/// reconciliation algorithm tracks it correctly at a stable tree position.
class _AnimatedReplaceSection extends StatelessWidget {
  const _AnimatedReplaceSection({this.section});

  final ReplaceSection? section;

  @override
  Widget build(BuildContext context) => AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: section != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: section,
              )
            : const SizedBox.shrink(),
      );
}
