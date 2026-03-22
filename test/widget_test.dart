import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:aufgabengenerator_flutter/src/transformation_options.dart';

// Helper: applies transformations with all defaults off.
// [generation] seeds the Random instance for deterministic stochastic steps,
// using the same [computeSeed] function as the production app.
String transform(
  String input, {
  bool shuffleWords = false,
  bool scramble = false,
  bool mirrorWords = false,
  bool removeSpaces = false,
  CaseMode caseMode = CaseMode.none,
  String lettersToReplace = '',
  String replacementSymbols = '',
  bool mirror = false,
  int generation = 0,
}) =>
    applyTransformations(
      input,
      TransformationConfig(
        shuffleWords: shuffleWords,
        scramble: scramble,
        mirrorWords: mirrorWords,
        removeSpaces: removeSpaces,
        caseMode: caseMode,
        lettersToReplace: lettersToReplace,
        replacementSymbols: replacementSymbols,
        mirror: mirror,
      ),
      Random(computeSeed(input, generation)),
    );

void main() {
  test('returns empty for empty input', () {
    expect(transform(''), '');
  });

  test('mirror reverses the entire string', () {
    expect(transform('Hallo', mirror: true), 'ollaH');
  });

  test('mirrorWords reverses each word, keeps order', () {
    expect(transform('Hallo Welt', mirrorWords: true), 'ollaH tleW');
  });

  test('removeSpaces strips all spaces', () {
    expect(transform('Hallo Welt', removeSpaces: true), 'HalloWelt');
  });

  test('multiple spaces are treated as one word separator', () {
    expect(transform('Hallo  Welt', removeSpaces: true), 'HalloWelt');
  });

  test('CaseMode.uppercase converts to uppercase', () {
    expect(transform('Hallo', caseMode: CaseMode.uppercase), 'HALLO');
  });

  test('CaseMode.lowercase converts to lowercase', () {
    expect(transform('HALLO', caseMode: CaseMode.lowercase), 'hallo');
  });

  test('replaceLetters substitutes matched characters', () {
    expect(
      transform('aeiou', lettersToReplace: 'aeiou', replacementSymbols: '@'),
      '@@@@@',
    );
  });

  test('replaceLetters is no-op when fields are empty', () {
    // No letters or symbols → pipeline skips replacement entirely.
    expect(transform('hello'), 'hello');
  });

  test('replaceLetters does not run when only one field is set', () {
    expect(transform('hello', lettersToReplace: 'aeiou'), 'hello');
    expect(transform('hello', replacementSymbols: '@#'), 'hello');
  });

  test('scramble preserves single-char words', () {
    expect(transform('a', scramble: true), 'a');
  });

  test('scramble is deterministic for same input and generation', () {
    final first = transform('Hallo Welt', scramble: true, generation: 0);
    final second = transform('Hallo Welt', scramble: true, generation: 0);
    expect(first, second);
  });

  test('different generation produces different scramble', () {
    final gen0 = transform('Hallo Welt', scramble: true, generation: 0);
    final gen1 = transform('Hallo Welt', scramble: true, generation: 1);
    // Not guaranteed by the algorithm but extremely likely for any reasonable input.
    expect(gen0, isNot(equals(gen1)));
  });

  test('shuffleWords is deterministic for same generation', () {
    final first = transform('Ein zwei drei vier', shuffleWords: true);
    final second = transform('Ein zwei drei vier', shuffleWords: true);
    expect(first, second);
  });

  test('mirror is Unicode-safe with emoji', () {
    // 🎉 (U+1F389) is a supplementary-plane codepoint stored as a surrogate
    // pair in UTF-16. split('') would split the pair and corrupt output;
    // runes-based mirror must keep the emoji intact.
    const emoji = '🎉';
    final result = transform('AB$emoji', mirror: true);
    expect(result, '${emoji}BA');
  });

  test('shuffleWords splits on newlines (multi-line input)', () {
    // _words must treat \n as a word separator, not embed it in a token.
    final result = transform('Hello\nWorld', shuffleWords: true, generation: 0);
    // The two tokens must appear separated by a single space and contain no newline.
    expect(result.contains('\n'), isFalse);
    expect(result.split(' ').toSet(), equals({'Hello', 'World'}));
  });

  test('removeSpaces only removes space characters, not tabs', () {
    // The feature removes ' ' specifically. A word-based transform applied
    // first would normalise whitespace, but removeSpaces alone does not.
    expect(transform('Hello\tWorld', removeSpaces: true), 'Hello\tWorld');
  });

  test('mirrorWords with emoji', () {
    // '🎉' is a supplementary-plane codepoint; split('') would corrupt it.
    expect(transform('🎉test', mirrorWords: true), 'tset🎉');
  });

  test('shuffleWords + removeSpaces combination', () {
    final result =
        transform('Ein zwei drei', shuffleWords: true, removeSpaces: true);
    // No spaces remain, and all characters from the original words are present.
    expect(result.contains(' '), isFalse);
    expect(result.split('').toSet(),
        equals('Einzweidrei'.split('').toSet()));
  });

  test('computeSeed is stable for same input and generation', () {
    expect(computeSeed('Hallo', 0), computeSeed('Hallo', 0));
    expect(computeSeed('', 5), computeSeed('', 5));
  });

  test('computeSeed differs for different generation', () {
    expect(computeSeed('Hallo', 0), isNot(equals(computeSeed('Hallo', 1))));
  });

  test('TransformationConfig equality', () {
    const a = TransformationConfig(shuffleWords: true, caseMode: CaseMode.uppercase);
    const b = TransformationConfig(shuffleWords: true, caseMode: CaseMode.uppercase);
    const c = TransformationConfig(shuffleWords: false, caseMode: CaseMode.uppercase);
    expect(a, equals(b));
    expect(a, isNot(equals(c)));
    expect(a.hashCode, equals(b.hashCode));
  });

  test('hasRandomTransforms false when only lettersToReplace set', () {
    expect(
      const TransformationConfig(lettersToReplace: 'abc').hasRandomTransforms,
      isFalse,
    );
  });

  test('hasRandomTransforms reflects active random steps', () {
    expect(
      const TransformationConfig(shuffleWords: true).hasRandomTransforms,
      isTrue,
    );
    expect(
      const TransformationConfig(scramble: true).hasRandomTransforms,
      isTrue,
    );
    // Replace is random only when there are multiple symbols to pick from.
    expect(
      const TransformationConfig(
        lettersToReplace: 'abc',
        replacementSymbols: '@#',
      ).hasRandomTransforms,
      isTrue,
    );
    expect(
      const TransformationConfig(
        lettersToReplace: 'abc',
        replacementSymbols: '@', // single symbol → deterministic
      ).hasRandomTransforms,
      isFalse,
    );
    expect(
      const TransformationConfig().hasRandomTransforms,
      isFalse,
    );
  });
}
