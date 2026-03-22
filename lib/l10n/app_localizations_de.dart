// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Aufgabengenerator';

  @override
  String get inputLabel => 'Eingabetext';

  @override
  String get inputHint => 'Text hier einfügen oder eingeben...';

  @override
  String get outputLabel => 'Ergebnis';

  @override
  String get optionsSectionTitle => 'Transformationen';

  @override
  String get optionMirror => 'Gesamten Text spiegeln';

  @override
  String get optionMirrorWords => 'Jedes Wort spiegeln';

  @override
  String get optionRemoveSpaces => 'Leerzeichen entfernen';

  @override
  String get caseNone => 'Normal';

  @override
  String get optionLowercase => 'kleinschreibung';

  @override
  String get optionUppercase => 'GROẞSCHREIBUNG';

  @override
  String get optionScramble => 'Buchstaben vertauschen';

  @override
  String get optionShuffleWords => 'Wörter mischen';

  @override
  String get optionReplaceLetters => 'Buchstaben ersetzen';

  @override
  String get lettersToReplaceLabel => 'Zu ersetzende Buchstaben';

  @override
  String get lettersToReplaceHint => 'z.B. aeiou';

  @override
  String get replacementSymbolsLabel => 'Ersatzsymbole';

  @override
  String get replacementSymbolsHint => 'z.B. @#\$%!';

  @override
  String get generateRandom => 'Zufällig generieren';

  @override
  String get copyButton => 'Kopieren';

  @override
  String get copiedFeedback => 'In Zwischenablage kopiert';

  @override
  String get toggleTheme => 'Design wechseln';

  @override
  String get rerollTooltip => 'Neu generieren';
}
