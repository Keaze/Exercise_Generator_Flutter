import 'package:flutter/material.dart';
import 'package:aufgabengenerator_flutter/l10n/app_localizations.dart';

class OutputSection extends StatelessWidget {
  const OutputSection({
    super.key,
    required this.text,
    required this.onCopy,
    this.onReroll,
    this.expanded = false,
  });

  final String text;
  final VoidCallback onCopy;
  /// When non-null, a re-roll button is shown (for random transformations).
  final VoidCallback? onReroll;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isEmpty = text.isEmpty;

    final outputBox = Container(
      width: double.infinity,
      constraints: expanded
          ? const BoxConstraints()
          : const BoxConstraints(minHeight: 140),
      decoration: BoxDecoration(
        color: isEmpty
            ? colorScheme.surfaceContainerLowest
            : colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEmpty
              ? colorScheme.outlineVariant
              : colorScheme.primary.withValues(alpha: 0.4),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: isEmpty
          ? Center(
              child: Text(
                '—',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            )
          : SelectableText(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.6,
                  ),
            ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.output_rounded, size: 20, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.outputLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (onReroll != null) ...[
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: l10n.rerollTooltip,
                onPressed: isEmpty ? null : onReroll,
              ),
              const SizedBox(width: 4),
            ],
            FilledButton.tonalIcon(
              onPressed: isEmpty ? null : onCopy,
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text(l10n.copyButton),
            ),
          ],
        ),
        const SizedBox(height: 8),
        expanded
            ? Expanded(child: SingleChildScrollView(child: outputBox))
            : outputBox,
      ],
    );
  }
}
