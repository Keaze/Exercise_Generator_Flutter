import 'package:flutter/material.dart';
import 'package:aufgabengenerator_flutter/l10n/app_localizations.dart';
import '../transformation_options.dart';

class OptionsSection extends StatelessWidget {
  const OptionsSection({
    super.key,
    required this.config,
    required this.onChanged,
    required this.showReplace,
    required this.onShowReplaceChanged,
  });

  final TransformationConfig config;
  final ValueChanged<TransformationConfig> onChanged;

  /// Whether the replace-letters panel is currently visible.
  /// Kept outside [TransformationConfig] because it is a UI concern.
  final bool showReplace;
  final ValueChanged<bool> onShowReplaceChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.optionsSectionTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _OptionChip(
                  label: l10n.optionShuffleWords,
                  icon: Icons.shuffle_rounded,
                  selected: config.shuffleWords,
                  onSelected: (v) => onChanged(config.copyWith(shuffleWords: v)),
                ),
                _OptionChip(
                  label: l10n.optionScramble,
                  icon: Icons.font_download_outlined,
                  selected: config.scramble,
                  onSelected: (v) => onChanged(config.copyWith(scramble: v)),
                ),
                _OptionChip(
                  label: l10n.optionRemoveSpaces,
                  icon: Icons.space_bar_rounded,
                  selected: config.removeSpaces,
                  onSelected: (v) => onChanged(config.copyWith(removeSpaces: v)),
                ),
                _OptionChip(
                  label: l10n.optionMirrorWords,
                  icon: Icons.swap_horiz_rounded,
                  selected: config.mirrorWords,
                  onSelected: (v) => onChanged(config.copyWith(mirrorWords: v)),
                ),
                _OptionChip(
                  label: l10n.optionMirror,
                  icon: Icons.flip_rounded,
                  selected: config.mirror,
                  onSelected: (v) => onChanged(config.copyWith(mirror: v)),
                ),
                // Replace chip controls panel visibility, not the pipeline.
                // The pipeline activates when lettersToReplace and
                // replacementSymbols are non-empty (set via the panel).
                _OptionChip(
                  label: l10n.optionReplaceLetters,
                  icon: Icons.find_replace_rounded,
                  selected: showReplace,
                  onSelected: onShowReplaceChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _CaseSelector(
              caseMode: config.caseMode,
              onChanged: (v) => onChanged(config.copyWith(caseMode: v)),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
    );
  }
}

class _CaseSelector extends StatelessWidget {
  const _CaseSelector({required this.caseMode, required this.onChanged});

  final CaseMode caseMode;
  final ValueChanged<CaseMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SegmentedButton<CaseMode>(
      segments: [
        ButtonSegment(
          value: CaseMode.none,
          label: Text(l10n.caseNone),
          icon: const Icon(Icons.text_fields_rounded),
        ),
        ButtonSegment(
          value: CaseMode.lowercase,
          label: Text(l10n.optionLowercase),
          icon: const Icon(Icons.text_decrease_rounded),
        ),
        ButtonSegment(
          value: CaseMode.uppercase,
          label: Text(l10n.optionUppercase),
          icon: const Icon(Icons.text_increase_rounded),
        ),
      ],
      selected: {caseMode},
      onSelectionChanged: (selection) => onChanged(selection.first),
      style: const ButtonStyle(
        visualDensity: VisualDensity.comfortable,
      ),
    );
  }
}
