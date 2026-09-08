import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/knowledge_node.dart';

/// Widget per la visualizzazione interattiva step-by-step di dimostrazioni logiche,
/// passaggi algebrici e derivazione esplicita di corollari in stile Wikipedia Dark Mode.
class AlgebraicProofWidget extends StatefulWidget {
  final List<ProofStep> proofSteps;
  final String? initialGroup;
  final int? initialStepIndex;
  final bool initialShowAll;
  final String? targetCorollary;

  const AlgebraicProofWidget({
    super.key,
    required this.proofSteps,
    this.initialGroup,
    this.initialStepIndex,
    this.initialShowAll = false,
    this.targetCorollary,
  });

  @override
  State<AlgebraicProofWidget> createState() => _AlgebraicProofWidgetState();
}

class _AlgebraicProofWidgetState extends State<AlgebraicProofWidget> {
  int currentStepIndex = 0;
  bool _showAllSteps = false;
  String? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _showAllSteps = widget.initialShowAll;
    currentStepIndex = widget.initialStepIndex ?? 0;
    if (widget.initialGroup != null) {
      _selectedGroup = widget.initialGroup;
    }

    if (widget.targetCorollary != null &&
        widget.targetCorollary!.trim().isNotEmpty) {
      final target = widget.targetCorollary!.trim().toLowerCase();
      for (final step in widget.proofSteps) {
        final desc = (step.description ?? '').toLowerCase();
        final ins = (step.insight ?? '').toLowerCase();
        final corTitle = (step.corollaryTitle ?? '').toLowerCase();
        if (desc.contains(target) ||
            ins.contains(target) ||
            corTitle.contains(target)) {
          final g = step.groupName;
          if (g != null) {
            _selectedGroup = g;
          }
          _showAllSteps = true;
          break;
        }
      }
    }
  }

  List<String> get _groups {
    final groups = <String>[];
    bool hasUngrouped = false;
    for (final step in widget.proofSteps) {
      final desc = step.description ?? '';
      final match = RegExp(r'^\[(.*?)\]').firstMatch(desc);
      if (match != null) {
        final g = match.group(1)!.trim();
        if (g.isNotEmpty && !groups.contains(g)) {
          groups.add(g);
        }
      } else {
        hasUngrouped = true;
      }
    }
    if (hasUngrouped && groups.isNotEmpty) {
      groups.insert(0, 'Dimostrazione Principale');
    }
    return groups;
  }

  List<ProofStep> get _currentSteps {
    final allGroups = _groups;
    if (allGroups.isEmpty) {
      return widget.proofSteps;
    }
    final activeGroup = _selectedGroup ?? allGroups.first;
    if (activeGroup == 'Dimostrazione Principale') {
      final filtered = widget.proofSteps.where((s) {
        final desc = s.description ?? '';
        return !desc.startsWith('[');
      }).toList();
      return filtered.isNotEmpty ? filtered : widget.proofSteps;
    }
    final filtered = widget.proofSteps.where((s) {
      final desc = s.description ?? '';
      return desc.startsWith('[$activeGroup]');
    }).toList();
    return filtered.isNotEmpty ? filtered : widget.proofSteps;
  }

  @override
  void didUpdateWidget(covariant AlgebraicProofWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.proofSteps != widget.proofSteps ||
        oldWidget.initialGroup != widget.initialGroup ||
        oldWidget.targetCorollary != widget.targetCorollary ||
        oldWidget.initialStepIndex != widget.initialStepIndex ||
        oldWidget.initialShowAll != widget.initialShowAll) {
      currentStepIndex = widget.initialStepIndex ?? 0;
      _showAllSteps = widget.initialShowAll;
      _selectedGroup = widget.initialGroup;

      if (widget.targetCorollary != null &&
          widget.targetCorollary!.trim().isNotEmpty) {
        final target = widget.targetCorollary!.trim().toLowerCase();
        for (final step in widget.proofSteps) {
          final desc = (step.description ?? '').toLowerCase();
          final ins = (step.insight ?? '').toLowerCase();
          final corTitle = (step.corollaryTitle ?? '').toLowerCase();
          if (desc.contains(target) ||
              ins.contains(target) ||
              corTitle.contains(target)) {
            final g = step.groupName;
            if (g != null) {
              _selectedGroup = g;
            }
            _showAllSteps = true;
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.proofSteps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderDark),
        ),
        child: const Center(
          child: Text(
            'Nessuna dimostrazione algebrica disponibile.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    final steps = _currentSteps;
    final totalSteps = steps.length;
    final displayedCount = _showAllSteps
        ? totalSteps
        : (currentStepIndex + 1).clamp(1, totalSteps);
    final isCompleted = displayedCount >= totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Intestazione con progresso e toggle "Mostra Tutti"
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_stories_rounded,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Dimostrazione & Corollari',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllSteps = !_showAllSteps;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    _showAllSteps ? 'Passo-passo' : 'Mostra tutti',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentBlueBright,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlueDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1D4ED8), width: 0.8),
                  ),
                  child: Text(
                    '$displayedCount / $totalSteps',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentBlueBright,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Selettore a Chip per dimostrazioni multiple
        if (_groups.isNotEmpty) ...[
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _groups.map((group) {
                final isSelected = (_selectedGroup ?? _groups.first) == group;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildGroupChip(group, isSelected),
                );
              }).toList(),
            ),
          ),
        ],

        const SizedBox(height: 14),

        // Lista dei passaggi visualizzati
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedCount,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final step = steps[index];
            return _buildProofStepCard(index + 1, step);
          },
        ),

        const SizedBox(height: 16),

        // Pulsante di avanzamento se non completato
        if (!_showAllSteps && !isCompleted)
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                if (currentStepIndex < totalSteps - 1) {
                  currentStepIndex++;
                }
              });
            },
            icon: const Icon(Icons.arrow_downward_rounded, size: 18),
            label: Text(
              'Sblocca Passaggio ${currentStepIndex + 2}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF064E3B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF059669), width: 0.8),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color: Color(0xFF34D399),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Dimostrazione e corollari verificati',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF34D399),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGroupChip(String group, bool isSelected) {
    final isCorollaryGroup = group.toLowerCase().contains('corollario');
    return FilterChip(
      avatar: isCorollaryGroup
          ? const Icon(
              Icons.star_rounded,
              size: 16,
              color: Color(0xFFFBBF24),
            )
          : null,
      label: Text(group),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedGroup = group;
          currentStepIndex = 0;
          _showAllSteps = false;
        });
      },
      selectedColor: isCorollaryGroup
          ? const Color(0xFF451A03)
          : const Color(0xFF1E3A8A),
      checkmarkColor: isCorollaryGroup
          ? const Color(0xFFFBBF24)
          : AppTheme.accentBlueBright,
      backgroundColor: AppTheme.surfaceElevated,
      side: BorderSide(
        color: isSelected
            ? (isCorollaryGroup
                ? const Color(0xFFFBBF24)
                : AppTheme.accentBlueBright)
            : (isCorollaryGroup
                ? const Color(0xFF78350F)
                : AppTheme.borderDark),
        width: isSelected ? 1.4 : 0.9,
      ),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected
            ? (isCorollaryGroup
                ? const Color(0xFFFEF3C7)
                : Colors.white)
            : (isCorollaryGroup
                ? const Color(0xFFFDE68A)
                : AppTheme.textSecondary),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildProofStepCard(int stepNumber, ProofStep step) {
    final cleanDesc = step.cleanDescription;
    final isCorollary = step.isCorollary ||
        cleanDesc.trim().toLowerCase().startsWith('corollario') ||
        cleanDesc.toLowerCase().contains('corollario:');

    final borderColor = isCorollary
        ? const Color(0xFFB45309)
        : AppTheme.borderDark;
    final cardBg = isCorollary ? const Color(0xFF251C08) : AppTheme.surfaceDark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isCorollary ? 1.4 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge del passaggio / Corollario
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (isCorollary)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF451A03),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF92400E)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Color(0xFFFBBF24),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'COROLLARIO DEDOTTO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Color(0xFFFBBF24),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCorollary ? const Color(0xFF33230A) : AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isCorollary ? const Color(0xFF78350F) : AppTheme.borderDark,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  'PASSAGGIO $stepNumber',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: isCorollary ? const Color(0xFFFDE68A) : AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          // Descrizione del passaggio algebrico
          if (cleanDesc.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              cleanDesc,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                fontWeight: isCorollary ? FontWeight.w600 : FontWeight.w400,
                color: isCorollary
                    ? const Color(0xFFFDE68A)
                    : AppTheme.textPrimary,
              ),
            ),
          ],

          // Equazione LaTeX renderizzata ad alto contrasto
          if (step.latexEquation != null && step.latexEquation!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: isCorollary ? const Color(0xFF181204) : AppTheme.bgDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCorollary
                      ? const Color(0xFF78350F)
                      : AppTheme.borderDark,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Math.tex(
                    step.latexEquation!,
                    textStyle: TextStyle(
                      fontSize: isCorollary ? 21 : 18,
                      fontWeight: isCorollary
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Intuizione logico-algebrica (Insight)
          if (step.insight != null && step.insight!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isCorollary
                    ? const Color(0xFF33230A)
                    : AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCorollary
                      ? const Color(0xFF78350F)
                      : AppTheme.borderDark,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: isCorollary
                        ? const Color(0xFFFBBF24)
                        : AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step.insight!,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                        color: isCorollary
                            ? const Color(0xFFFDE68A)
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
