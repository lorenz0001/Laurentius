import 'package:flutter/material.dart';

import '../../core/services/ai_tutor_service.dart';
import '../../domain/models/exercise_model.dart';
import '../../domain/models/knowledge_node.dart';

/// Schermata per la risoluzione interattiva di esercizi generati dall'AI Tutor (stile Brilliant).
class ExerciseScreen extends StatefulWidget {
  final KnowledgeNode node;

  const ExerciseScreen({
    super.key,
    required this.node,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final AITutorService _aiService = AITutorService();
  late Future<ExerciseModel> _exerciseFuture;

  String? _selectedOption;
  final TextEditingController _numericController = TextEditingController();

  bool _hasChecked = false;
  bool _isCorrect = false;
  bool _showExplanation = false;

  @override
  void initState() {
    super.initState();
    _fetchExercise();
  }

  @override
  void dispose() {
    _numericController.dispose();
    super.dispose();
  }

  void _fetchExercise() {
    setState(() {
      _selectedOption = null;
      _numericController.clear();
      _hasChecked = false;
      _isCorrect = false;
      _showExplanation = false;
      _exerciseFuture = _aiService.generateExercise(widget.node);
    });
  }

  void _verifyAnswer(ExerciseModel exercise) {
    if (_hasChecked) return;

    final String userAnswer = exercise.type == 'numeric'
        ? _numericController.text.trim()
        : (_selectedOption ?? '').trim();

    if (userAnswer.isEmpty) return;

    final bool correct =
        userAnswer.toLowerCase() == exercise.correctAnswer.trim().toLowerCase();

    setState(() {
      _hasChecked = true;
      _isCorrect = correct;
      if (correct) {
        _showExplanation = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
        title: Text(
          widget.node.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Genera un altro esercizio',
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
            onPressed: _fetchExercise,
          ),
        ],
      ),
      body: FutureBuilder<ExerciseModel>(
        future: _exerciseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF2563EB)),
                  SizedBox(height: 18),
                  Text(
                    'L\'AI Tutor sta preparando l\'esercizio...',
                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Adattamento basato sui tuoi prerequisiti',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Impossibile caricare l\'esercizio: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchExercise,
                      child: const Text('Riprova'),
                    ),
                  ],
                ),
              ),
            );
          }

          final exercise = snapshot.data!;
          return _buildExerciseContent(exercise);
        },
      ),
    );
  }

  Widget _buildExerciseContent(ExerciseModel exercise) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Badge Categoria e Tipo Esercizio
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.node.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    exercise.type == 'numeric' ? 'CALCOLO NUMERICO' : 'SCELTA MULTIPLA',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card della Domanda
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'QUESITO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    exercise.question,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sezione Risposta: Scelta Multipla o Numerico
            if (exercise.type == 'numeric')
              _buildNumericInput(exercise)
            else
              _buildMultipleChoiceOptions(exercise),

            const SizedBox(height: 24),

            // Pulsante di Verifica / Azione
            if (!_hasChecked)
              ElevatedButton(
                onPressed: () => _verifyAnswer(exercise),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Verifica Risposta',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),

            // Sezione Feedback e Spiegazione
            if (_hasChecked) ...[
              _buildFeedbackCard(exercise),
              const SizedBox(height: 20),
            ],

            if (_showExplanation) ...[
              _buildExplanationCard(exercise),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchExercise,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text(
                  'Prossimo Esercizio',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Opzioni a scelta multipla con feedback visivo a colori pastello
  Widget _buildMultipleChoiceOptions(ExerciseModel exercise) {
    final options = exercise.options ?? [];

    return Column(
      children: options.map((opt) {
        final isSelected = _selectedOption == opt;
        final isCorrectOption =
            opt.trim().toLowerCase() == exercise.correctAnswer.trim().toLowerCase();

        Color bgColor = Colors.white;
        Color borderColor = const Color(0xFFE2E8F0);
        Color textColor = const Color(0xFF1E293B);
        Widget? trailingIcon;

        if (_hasChecked) {
          if (isCorrectOption) {
            bgColor = const Color(0xFFDCFCE7);
            borderColor = const Color(0xFF86EFAC);
            textColor = const Color(0xFF15803D);
            trailingIcon = const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 20);
          } else if (isSelected && !_isCorrect) {
            bgColor = const Color(0xFFFEE2E2);
            borderColor = const Color(0xFFFCA5A5);
            textColor = const Color(0xFFB91C1C);
            trailingIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626), size: 20);
          }
        } else if (isSelected) {
          bgColor = const Color(0xFFEFF6FF);
          borderColor = const Color(0xFF3B82F6);
          textColor = const Color(0xFF1D4ED8);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _hasChecked
                  ? null
                  : () {
                      setState(() {
                        _selectedOption = opt;
                      });
                    },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                    ?trailingIcon,
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Input per domande di tipo numerico
  Widget _buildNumericInput(ExerciseModel exercise) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inserisci il valore numerico:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _numericController,
            enabled: !_hasChecked,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: InputDecoration(
              hintText: 'Es. 42',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// Scheda con il risultato immediato (Corretto o Errato)
  Widget _buildFeedbackCard(ExerciseModel exercise) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isCorrect ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: _isCorrect ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _isCorrect ? 'Ottimo lavoro, risposta esatta!' : 'Risposta non corretta.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _isCorrect ? const Color(0xFF15803D) : const Color(0xFF991B1B),
                  ),
                ),
              ),
            ],
          ),
          if (!_isCorrect && !_showExplanation) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _hasChecked = false;
                        _selectedOption = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F172A),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Riprova'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showExplanation = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Mostra Soluzione'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Spiegazione dettagliata della soluzione
  Widget _buildExplanationCard(ExerciseModel exercise) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFCA8A04), size: 20),
              SizedBox(width: 8),
              Text(
                'Spiegazione e Intuizione',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            exercise.explanation,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Risposta Corretta: ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                ),
                Text(
                  exercise.correctAnswer,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF16A34A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
