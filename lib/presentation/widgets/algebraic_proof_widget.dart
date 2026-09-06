import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../domain/models/knowledge_node.dart';

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

  @override
  Widget build(BuildContext context) {
    if (widget.proofSteps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Nessuna dimostrazione algebrica disponibile.',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }

    final totalSteps = widget.proofSteps.length;
    final isCompleted = currentStepIndex >= totalSteps - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Intestazione sezione con indicatore di progresso
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Dimostrazione Step-by-Step',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Text(
                '${currentStepIndex + 1} / $totalSteps',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D4ED8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Lista dei passaggi sbloccati
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: currentStepIndex + 1,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final step = widget.proofSteps[index];
            return _buildProofStepCard(index + 1, step);
          },
        ),

        const SizedBox(height: 20),

        // Pulsante di avanzamento o messaggio di completamento
        if (!isCompleted)
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                if (currentStepIndex < totalSteps - 1) {
                  currentStepIndex++;
                }
              });
            },
            icon: const Icon(Icons.arrow_downward, size: 20),
            label: const Text(
              'Passaggio Successivo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 22),
                SizedBox(width: 8),
                Text(
                  'Dimostrazione completata!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge del passaggio
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'PASSAGGIO $stepNumber',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: Color(0xFF475569),
              ),
            ),
          ),

          // Descrizione del passaggio
          if (step.description != null && step.description!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              step.description!,
              style: const TextStyle(
                fontSize: 15,
                height: 1.45,
                color: Color(0xFF334155),
              ),
            ),
          ],

          // Equazione LaTeX renderizzata
          if (step.latexEquation != null && step.latexEquation!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Math.tex(
                    step.latexEquation!,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Insight o intuizione didattica
          if (step.insight != null && step.insight!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEFCE8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFEF08A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 18,
                    color: Color(0xFFCA8A04),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step.insight!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                        color: Color(0xFF854D0E),
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
