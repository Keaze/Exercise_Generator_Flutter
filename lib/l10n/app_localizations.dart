import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Title shown in the app bar
  ///
  /// In en, this message translates to:
  /// **'Exercise Generator'**
  String get appTitle;

  /// Label above the text input field
  ///
  /// In en, this message translates to:
  /// **'Input Text'**
  String get inputLabel;

  /// Placeholder inside the input field
  ///
  /// In en, this message translates to:
  /// **'Paste or type your text here...'**
  String get inputHint;

  /// Label above the output display
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get outputLabel;

  /// Section heading for the checkboxes
  ///
  /// In en, this message translates to:
  /// **'Transformations'**
  String get optionsSectionTitle;

  /// Transformation: reverse whole string
  ///
  /// In en, this message translates to:
  /// **'Mirror entire text'**
  String get optionMirror;

  /// Transformation: reverse each word individually
  ///
  /// In en, this message translates to:
  /// **'Mirror each word'**
  String get optionMirrorWords;

  /// Transformation: strip all spaces
  ///
  /// In en, this message translates to:
  /// **'Remove spaces'**
  String get optionRemoveSpaces;

  /// No case transformation
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get caseNone;

  /// Transformation: convert to lowercase
  ///
  /// In en, this message translates to:
  /// **'lowercase'**
  String get optionLowercase;

  /// Transformation: convert to uppercase
  ///
  /// In en, this message translates to:
  /// **'UPPERCASE'**
  String get optionUppercase;

  /// Transformation: shuffle all letters of each word
  ///
  /// In en, this message translates to:
  /// **'Scramble letters'**
  String get optionScramble;

  /// Transformation: randomize the order of words
  ///
  /// In en, this message translates to:
  /// **'Shuffle words'**
  String get optionShuffleWords;

  /// Transformation: replace specific letters with symbols
  ///
  /// In en, this message translates to:
  /// **'Replace letters'**
  String get optionReplaceLetters;

  /// Label for the letters-to-replace field
  ///
  /// In en, this message translates to:
  /// **'Letters to replace'**
  String get lettersToReplaceLabel;

  /// Hint for letters-to-replace field
  ///
  /// In en, this message translates to:
  /// **'e.g. aeiou'**
  String get lettersToReplaceHint;

  /// Label for the replacement symbols field
  ///
  /// In en, this message translates to:
  /// **'Replacement symbols'**
  String get replacementSymbolsLabel;

  /// Hint for replacement symbols field
  ///
  /// In en, this message translates to:
  /// **'e.g. @#\$%!'**
  String get replacementSymbolsHint;

  /// Button to fill replacement symbols with random unique characters
  ///
  /// In en, this message translates to:
  /// **'Generate random'**
  String get generateRandom;

  /// Label for the copy-to-clipboard button
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyButton;

  /// SnackBar message after copy
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedFeedback;

  /// Tooltip for the dark/light mode toggle button
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get toggleTheme;

  /// Tooltip for the re-roll button in the output section
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get rerollTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
