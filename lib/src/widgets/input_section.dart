import 'package:flutter/material.dart';
import 'package:aufgabengenerator_flutter/l10n/app_localizations.dart';

class InputSection extends StatelessWidget {
  const InputSection({super.key, required this.controller});

  /// The controller to attach to the text field.
  /// Owned and disposed by the caller — [InputSection] never disposes it.
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.edit_note_rounded, size: 20, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              l10n.inputLabel,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 7,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: l10n.inputHint,
            filled: true,
            fillColor: colorScheme.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }
}
