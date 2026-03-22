import 'package:flutter/material.dart';
import 'package:aufgabengenerator_flutter/l10n/app_localizations.dart';

class ReplaceSection extends StatelessWidget {
  const ReplaceSection({
    super.key,
    required this.lettersToReplace,
    required this.onLettersChanged,
    required this.replacementSymbols,
    required this.onSymbolsChanged,
    required this.onGenerateRandom,
  });

  final String lettersToReplace;
  final ValueChanged<String> onLettersChanged;
  final String replacementSymbols;
  final ValueChanged<String> onSymbolsChanged;
  final VoidCallback onGenerateRandom;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.4)),
      ),
      color: colorScheme.primaryContainer.withValues(alpha: 0.18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.find_replace_rounded,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.optionReplaceLetters,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // CrossAxisAlignment.center keeps the arrow vertically centred
            // on the text input area, not at the top of the floating label.
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _CompactField(
                    value: lettersToReplace,
                    onChanged: onLettersChanged,
                    label: l10n.lettersToReplaceLabel,
                    hint: l10n.lettersToReplaceHint,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: _CompactField(
                    value: replacementSymbols,
                    onChanged: onSymbolsChanged,
                    label: l10n.replacementSymbolsLabel,
                    hint: l10n.replacementSymbolsHint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: lettersToReplace.isEmpty ? null : onGenerateRandom,
                icon: const Icon(Icons.casino_rounded, size: 18),
                label: Text(l10n.generateRandom),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A compact text field that owns its own [TextEditingController].
/// The parent drives the value via [value]; the field notifies changes via
/// [onChanged]. When the parent changes [value] (e.g. "Generate random"
/// fills the symbols field), [didUpdateWidget] syncs the controller.
class _CompactField extends StatefulWidget {
  const _CompactField({
    required this.value,
    required this.onChanged,
    required this.label,
    required this.hint,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String label;
  final String hint;

  @override
  State<_CompactField> createState() => _CompactFieldState();
}

class _CompactFieldState extends State<_CompactField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    // Guard prevents echoing the parent's pushed value back up the tree,
    // which would cause a redundant setState + SharedPreferences write.
    _controller.addListener(() {
      if (_controller.text != widget.value) widget.onChanged(_controller.text);
    });
  }

  @override
  void didUpdateWidget(_CompactField old) {
    super.didUpdateWidget(old);
    // Sync when the parent pushes a new value (e.g. generate-random).
    if (widget.value != _controller.text) {
      // Defer to avoid calling setState during build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.value != _controller.text) {
          _controller.text = widget.value;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        isDense: true,
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
