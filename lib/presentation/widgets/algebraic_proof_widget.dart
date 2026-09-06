import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../domain/models/knowledge_node.dart';

/// Widget per la visualizzazione interattiva step-by-step di dimostrazioni logiche,
/// passaggi algebrici e derivazione esplicita di corollari.
class AlgebraicProofWidget extends StatefulWidget {
  final List<ProofStep> proofSteps;

  const AlgebraicProofWidget({
    super.key,
    required this.proofSteps,
  });

  @override
  State<AlgebraicProofWidget> createState() => _AlgebraicProofWidgetState();
}

class _AlgebraicProofWidgetState extends State<AlgebraicProofWidget> {
  int currentStepIndex = 0;
  bool _showAllSteps = false;

  @override
  Widget build(BuildContext context) {
    if (widget.proofSteps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Nessuna dimostrazione algebrica disponibile.',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ),
      );
    }

    final totalSteps = widget.proofSteps.length;
    final displayedCount = _showAllSteps ? totalSteps : (currentStepIndex + 1).clamp(1, totalSteps);
    final isCompleted = displayedCount >= totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Intestazione con progresso e toggle "Mostra Tutti"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_stories_rounded, size: 18, color: Color(0xFF0F172A)),
                SizedBox(width: 8),
                Text(
                  'Dimostrazione & Corollari',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllSteps = !_showAllSteps;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    _showAllSteps ? 'Passo-passo' : 'Mostra tutti',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Text(
                    '$displayedCount / $totalSteps',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Lista dei passaggi visualizzati
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedCount,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final step = widget.proofSteps[index];
            return _buildProofStepCard(index + 1, step);
          },
        ),

        const SizedBox(height: 18),

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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
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
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_rounded, color: Color(0xFF16A34A), size: 18),
                SizedBox(width: 8),
                Text(
                  'Dimostrazione e corollari verificati',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF15803D),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProofStepCard(int stepNumber, ProofStep step) {
    final desc = step.description ?? '';
    final isCorollary = desc.trim().toLowerCase().startsWith('corollario') ||
        desc.toLowerCase().contains('corollario:');

    final borderColor = isCorollary ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0);
    final cardBg = isCorollary ? const Color(0xFFFFFBEB) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isCorollary ? 1.5 : 1.0),
        boxShadow: [
          BoxShadow(
            color: isCorollary ? const Color(0x14F59E0B) : const Color(0x08000000),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge del passaggio / Corollario
          Row(
            children: [
              if (isCorollary) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, size: 13, color: Color(0xFFD97706)),
                      SizedBox(width: 4),
                      Text(
                        'COROLLARIO DEDOTTO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCorollary ? Colors.white : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PASSAGGIO $stepNumber',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),

          // Descrizione del passaggio algebrico
          if (desc.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              desc,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                fontWeight: isCorollary ? FontWeight.w600 : FontWeight.w400,
                color: isCorollary ? const Color(0xFF78350F) : const Color(0xFF334155),
              ),
            ),
          ],

          // Equazione LaTeX renderizzata
          if (step.latexEquation != null && step.latexEquation!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCorollary ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Math.tex(
                    step.latexEquation!,
                    textStyle: TextStyle(
                      fontSize: isCorollary ? 22 : 19,
                      fontWeight: isCorollary ? FontWeight.w700 : FontWeight.w500,
                      color: const Color(0xFF0F172A),
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
                color: isCorollary ? const Color(0xFFFEF9C3) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCorollary ? const Color(0xFFFEF08A) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: isCorollary ? const Color(0xFFB45309) : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step.insight!,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                        color: isCorollary ? const Color(0xFF854D0E) : const Color(0xFF475569),
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
