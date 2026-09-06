import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../../domain/models/knowledge_node.dart';

/// Widget per la visualizzazione e il calcolo dinamico di formule interattive.
/// Implementa slider per ciascun parametro e ricalcola il risultato in tempo reale.
class LiveEquationWidget extends StatefulWidget {
  final InteractiveData data;

  const LiveEquationWidget({super.key, required this.data});

  @override
  State<LiveEquationWidget> createState() => _LiveEquationWidgetState();
}

class _LiveEquationWidgetState extends State<LiveEquationWidget> {
  // Mappa che memorizza i valori correnti associati al nome di ciascuna variabile
  final Map<String, double> _parameterValues = {};
  final GrammarParser _parser = GrammarParser();

  double? _computedResult;
  String? _calculationError;

  @override
  void initState() {
    super.initState();
    _initializeParameters();
    _recalculate();
  }

  @override
  void didUpdateWidget(covariant LiveEquationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _initializeParameters();
      _recalculate();
    }
  }

  /// Inizializza i parametri con i valori di default o minimi forniti dal modello
  void _initializeParameters() {
    _parameterValues.clear();
    final parameters = widget.data.parameters ?? [];
    for (final param in parameters) {
      final name = param.variableName;
      if (name != null && name.isNotEmpty) {
        _parameterValues[name] = param.defaultValue ?? param.minValue ?? 0.0;
      }
    }
  }

  /// Ricalcola l'equazione a runtime usando la libreria math_expressions
  void _recalculate() {
    final equations = widget.data.equations;
    if (equations == null || equations.isEmpty) {
      setState(() {
        _computedResult = null;
        _calculationError = 'Nessuna equazione specificata.';
      });
      return;
    }

    final rawEquation = equations.first;

    try {
      // Parsing della stringa matematica tramite GrammarParser
      final expression = _parser.parse(rawEquation);
      final contextModel = ContextModel();

      // Binding delle variabili con i valori correnti degli slider
      _parameterValues.forEach((varName, value) {
        contextModel.bindVariable(Variable(varName), Number(value));
      });

      // Valutazione numerica nel contesto reale tramite RealEvaluator
      final evaluator = RealEvaluator(contextModel);
      final evalResult = evaluator.evaluate(expression);

      setState(() {
        _computedResult = evalResult.toDouble();
        _calculationError = null;
      });
    } catch (e) {
      setState(() {
        _computedResult = null;
        _calculationError = 'Impossibile calcolare l\'espressione: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final parameters = widget.data.parameters ?? [];
    final equation = widget.data.equations?.firstOrNull ?? '';

    return Container(
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header sezione interattiva
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Laboratorio Interattivo',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Muovi gli slider per osservare il comportamento in tempo reale',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Box del Risultato in Tempo Reale
          _buildResultDisplay(equation),

          const SizedBox(height: 24),

          // Intestazione parametri
          const Text(
            'PARAMETRI VARIABILI',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 12),

          // Lista degli slider dinamici
          ...parameters.map((param) => _buildParameterSlider(param)),
        ],
      ),
    );
  }

  /// Costruisce il riquadro centrale che mostra il risultato dinamico
  Widget _buildResultDisplay(String equation) {
    if (_calculationError != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Text(
          _calculationError!,
          style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
        ),
      );
    }

    final formattedResult = _computedResult != null
        ? (_computedResult! % 1 == 0
              ? _computedResult!.toStringAsFixed(0)
              : _computedResult!.toStringAsFixed(2))
        : '--';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Formula: $equation',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF15803D),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formattedResult,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'V',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Costruisce il singolo elemento slider per ciascun parametro
  Widget _buildParameterSlider(InteractiveParameter param) {
    final varName = param.variableName ?? '';
    final label = param.label ?? varName;
    final min = param.minValue ?? 0.0;
    final max = param.maxValue ?? 100.0;
    final step = param.stepSize;
    final currentValue = _parameterValues[varName] ?? min;

    int? divisions;
    if (step != null && step > 0 && max > min) {
      divisions = ((max - min) / step).round();
    }

    final formattedValue = currentValue % 1 == 0
        ? currentValue.toStringAsFixed(0)
        : currentValue.toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Text(
                  formattedValue,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF2563EB),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFF2563EB),
              overlayColor: const Color(0x292563EB),
              trackHeight: 5,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
            ),
            child: Slider(
              value: currentValue.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: (newValue) {
                setState(() {
                  _parameterValues[varName] = newValue;
                  _recalculate();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
