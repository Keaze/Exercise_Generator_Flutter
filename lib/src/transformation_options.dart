import 'dart:math';

enum CaseMode { none, lowercase, uppercase }

/// Deterministic seed: same text + generation → same shuffle/scramble.
/// Masked to 31 bits so the value is always a positive int, which keeps
/// behaviour identical on native and JavaScript (JS uses 32-bit integers).
int computeSeed(String input, int generation) {
  var h = generation;
  for (final code in input.runes) {
    h = (h * 31 + code) & 0x7FFFFFFF;
  }
  return h;
}

/// All transformation settings as an immutable value object.
///
/// Note: letter-replacement visibility is UI state kept in the page widget,
/// not here. The pipeline activates replacement whenever [lettersToReplace]
/// and [replacementSymbols] are both non-empty.
class TransformationConfig {
  const TransformationConfig({
    this.shuffleWords = false,
    this.scramble = false,
    this.mirrorWords = false,
    this.removeSpaces = false,
    this.caseMode = CaseMode.none,
    this.lettersToReplace = '',
    this.replacementSymbols = '',
    this.mirror = false,
  });

  final bool shuffleWords;
  final bool scramble;
  final bool mirrorWords;
  final bool removeSpaces;
  final CaseMode caseMode;
  final String lettersToReplace;
  final String replacementSymbols;
  final bool mirror;

  /// True when any transformation requires a [Random] instance to produce
  /// output. Controls whether the re-roll button is shown.
  /// Replacement is random only when there are multiple symbols to choose from.
  bool get hasRandomTransforms =>
      shuffleWords ||
      scramble ||
      (lettersToReplace.isNotEmpty && replacementSymbols.length > 1);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransformationConfig &&
          shuffleWords == other.shuffleWords &&
          scramble == other.scramble &&
          mirrorWords == other.mirrorWords &&
          removeSpaces == other.removeSpaces &&
          caseMode == other.caseMode &&
          lettersToReplace == other.lettersToReplace &&
          replacementSymbols == other.replacementSymbols &&
          mirror == other.mirror;

  @override
  int get hashCode => Object.hash(
      shuffleWords, scramble, mirrorWords, removeSpaces,
      caseMode, lettersToReplace, replacementSymbols, mirror);

  TransformationConfig copyWith({
    bool? shuffleWords,
    bool? scramble,
    bool? mirrorWords,
    bool? removeSpaces,
    CaseMode? caseMode,
    String? lettersToReplace,
    String? replacementSymbols,
    bool? mirror,
  }) =>
      TransformationConfig(
        shuffleWords: shuffleWords ?? this.shuffleWords,
        scramble: scramble ?? this.scramble,
        mirrorWords: mirrorWords ?? this.mirrorWords,
        removeSpaces: removeSpaces ?? this.removeSpaces,
        caseMode: caseMode ?? this.caseMode,
        lettersToReplace: lettersToReplace ?? this.lettersToReplace,
        replacementSymbols: replacementSymbols ?? this.replacementSymbols,
        mirror: mirror ?? this.mirror,
      );
}

// Splits text on runs of whitespace (spaces, tabs, newlines), trimming and
// ignoring empty tokens. Any word-based transformation uses this, which
// normalises multi-whitespace to single spaces. This is intentional and
// consistent — if you need the original spacing preserved, don't enable a
// word-based transformation.
List<String> _words(String text) =>
    text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

/// Applies [config] transformations to [input] in a fixed pipeline order.
/// [random] controls all stochastic steps (shuffle, scramble, replace); pass
/// a seeded [Random] for reproducible output.
String applyTransformations(
  String input,
  TransformationConfig config,
  Random random,
) {
  if (input.isEmpty) return input;

  String result = input;

  // Step 1: Shuffle word order
  if (config.shuffleWords) {
    final words = _words(result);
    for (int i = words.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = words[i];
      words[i] = words[j];
      words[j] = temp;
    }
    result = words.join(' ');
  }

  // Step 2: Scramble all letters of each word
  if (config.scramble) {
    result = _words(result).map((word) {
      if (word.length <= 1) return word;
      final chars = word.split('');
      for (int i = chars.length - 1; i > 0; i--) {
        final j = random.nextInt(i + 1);
        final temp = chars[i];
        chars[i] = chars[j];
        chars[j] = temp;
      }
      return chars.join();
    }).join(' ');
  }

  // Step 3: Mirror each word individually ("Hallo Welt" → "ollaH tleW")
  if (config.mirrorWords) {
    result = _words(result)
        .map((word) => String.fromCharCodes(word.runes.toList().reversed))
        .join(' ');
  }

  // Step 4: Remove spaces
  if (config.removeSpaces) {
    result = result.replaceAll(' ', '');
  }

  // Step 5: Case
  if (config.caseMode == CaseMode.lowercase) {
    result = result.toLowerCase();
  } else if (config.caseMode == CaseMode.uppercase) {
    result = result.toUpperCase();
  }

  // Step 6: Replace letters with symbols.
  // Active whenever both fields are non-empty — no separate enable flag needed.
  // Iterates runes (Unicode codepoints) so supplementary characters
  // (e.g. emoji) are handled correctly instead of splitting surrogate pairs.
  if (config.lettersToReplace.isNotEmpty &&
      config.replacementSymbols.isNotEmpty) {
    final buffer = StringBuffer();
    // Precompute rune list so indexing is Unicode-safe (emoji, supplementary
    // chars). String.[i] uses UTF-16 code units and would corrupt surrogates.
    final symbols = config.replacementSymbols.runes.toList();
    for (final rune in result.runes) {
      final char = String.fromCharCode(rune);
      if (config.lettersToReplace.contains(char)) {
        buffer.write(String.fromCharCode(symbols[random.nextInt(symbols.length)]));
      } else {
        buffer.write(char);
      }
    }
    result = buffer.toString();
  }

  // Step 7: Mirror entire string ("Hallo Welt" → "tleW ollaH").
  // Uses runes for correct Unicode handling.
  if (config.mirror) {
    result = String.fromCharCodes(result.runes.toList().reversed);
  }

  return result;
}
