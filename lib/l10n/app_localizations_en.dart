// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Exercise Generator';

  @override
  String get inputLabel => 'Input Text';

  @override
  String get inputHint => 'Paste or type your text here...';

  @override
  String get outputLabel => 'Result';

  @override
  String get optionsSectionTitle => 'Transformations';

  @override
  String get optionMirror => 'Mirror entire text';

  @override
  String get optionMirrorWords => 'Mirror each word';

  @override
  String get optionRemoveSpaces => 'Remove spaces';

  @override
  String get caseNone => 'Normal';

  @override
  String get optionLowercase => 'lowercase';

  @override
  String get optionUppercase => 'UPPERCASE';

  @override
  String get optionScramble => 'Scramble letters';

  @override
  String get optionShuffleWords => 'Shuffle words';

  @override
  String get optionReplaceLetters => 'Replace letters';

  @override
  String get lettersToReplaceLabel => 'Letters to replace';

  @override
  String get lettersToReplaceHint => 'e.g. aeiou';

  @override
  String get replacementSymbolsLabel => 'Replacement symbols';

  @override
  String get replacementSymbolsHint => 'e.g. @#\$%!';

  @override
  String get generateRandom => 'Generate random';

  @override
  String get copyButton => 'Copy';

  @override
  String get copiedFeedback => 'Copied to clipboard';

  @override
  String get toggleTheme => 'Toggle theme';

  @override
  String get rerollTooltip => 'Regenerate';
}
