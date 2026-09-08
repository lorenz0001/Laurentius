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
  final List<InteractiveParameter> _effectiveParameters = [];
  final GrammarParser _parser = GrammarParser();

  static const Set<String> _reservedKeywords = {
    'sin', 'cos', 'tan', 'asin', 'acos', 'atan',
    'sinh', 'cosh', 'tanh', 'asinh', 'acosh', 'atanh',
    'log', 'ln', 'exp', 'sqrt', 'cbrt', 'root', 'pow',
    'abs', 'sgn', 'ceil', 'floor', 'round', 'trunc',
    'min', 'max', 'fact', 'e', 'pi', 'E', 'PI', 'inf', 'infinity',
  };

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

  /// Normalizza la sintassi delle equazioni per il GrammarParser (es. pow(a, b) -> a ^ b, log(x) -> ln(x))
  static String _normalizeEquation(String raw) {
    var eq = raw.trim();
    eq = eq.replaceAllMapped(
      RegExp(r'pow\s*\(\s*([^,]+)\s*,\s*([^)]+)\s*\)'),
      (m) => '((${m[1]}) ^ (${m[2]}))',
    );
    eq = eq.replaceAllMapped(
      RegExp(r'\blog\s*\('),
      (m) => 'ln(',
    );
    return eq;
  }

  /// Estrae i nomi delle variabili matematiche ignorando funzioni e costanti riservate
  static Set<String> _extractVariables(String rawEquation) {
    final normalized = _normalizeEquation(rawEquation);
    final regex = RegExp(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b');
    final matches = regex.allMatches(normalized);
    final vars = <String>{};
    for (final m in matches) {
      final word = m.group(0)!;
      if (!_reservedKeywords.contains(word)) {
        vars.add(word);
      }
    }
    return vars;
  }

  /// Inizializza i parametri con i valori di default o minimi forniti dal modello,
  /// integrando automaticamente eventuali variabili presenti nelle formule ma omesse nei metadati.
  void _initializeParameters() {
    _parameterValues.clear();
    _effectiveParameters.clear();

    final providedParams = widget.data.parameters ?? [];
    final knownNames = <String>{};

    for (final param in providedParams) {
      final name = param.variableName;
      if (name != null && name.isNotEmpty) {
        _effectiveParameters.add(param);
        knownNames.add(name);
        _parameterValues[name] = param.defaultValue ?? param.minValue ?? 1.0;
      }
    }

    // Auto-discovery di variabili presenti nell'equazione non censite nei parametri espliciti
    final equations = widget.data.equations;
    if (equations != null && equations.isNotEmpty) {
      for (final eq in equations) {
        final discoveredVars = _extractVariables(eq);
        for (final v in discoveredVars) {
          if (!knownNames.contains(v)) {
            knownNames.add(v);
            final isDenominatorOrBase = (v == 'b' && eq.contains('/')) || (v == 'b' && eq.contains('log'));
            final defVal = isDenominatorOrBase ? 2.0 : 2.0;
            final minVal = isDenominatorOrBase ? 1.0 : -10.0;
            final syntheticParam = InteractiveParameter()
              ..variableName = v
              ..label = 'Variabile ($v)'
              ..unit = ''
              ..minValue = minVal
              ..maxValue = 10.0
              ..defaultValue = defVal
              ..stepSize = 0.5;
            _effectiveParameters.add(syntheticParam);
            _parameterValues[v] = defVal;
          }
        }
      }
    }
  }

  /// Ricalcola l'equazione a runtime usando la libreria math_expressions con binding sicuro
  void _recalculate() {
    final equations = widget.data.equations;
    if (equations == null || equations.isEmpty) {
      setState(() {
        _computedResult = null;
        _calculationError = 'Nessuna equazione specificata.';
      });
      return;
    }

    final rawEquation = _normalizeEquation(equations.first);

    try {
      // Parsing della stringa matematica tramite GrammarParser
      final expression = _parser.parse(rawEquation);
      final contextModel = ContextModel();

      // Garantisce che ogni variabile presente nell'equazione sia vincolata
      final varsInEq = _extractVariables(rawEquation);
      for (final v in varsInEq) {
        _parameterValues.putIfAbsent(v, () => 1.0);
      }

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
      // Tentativo di auto-recovery se math_expressions segnala una variabile non vincolata
      if (e.toString().contains('Variable not bound:')) {
        final match = RegExp(r'Variable not bound:\s*([a-zA-Z0-9_]+)').firstMatch(e.toString());
        if (match != null) {
          final missingVar = match.group(1)!;
          _parameterValues[missingVar] = 1.0;
          try {
            final expression = _parser.parse(rawEquation);
            final contextModel = ContextModel();
            _parameterValues.forEach((varName, value) {
              contextModel.bindVariable(Variable(varName), Number(value));
            });
            final evaluator = RealEvaluator(contextModel);
            final evalResult = evaluator.evaluate(expression);
            setState(() {
              _computedResult = evalResult.toDouble();
              _calculationError = null;
            });
            return;
          } catch (_) {
            // Continua al catch finale se il recovery non ha esito positivo
          }
        }
      }

      setState(() {
        _computedResult = null;
        _calculationError = 'Impossibile calcolare l\'espressione: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final parameters = _effectiveParameters;
    final equation = widget.data.equations?.firstOrNull ?? '';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF191C20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D3238)),
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
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Color(0xFF60A5FA),
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
                        color: Color(0xFFEAECF0),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Muovi gli slider per osservare il comportamento in tempo reale',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
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
              color: Color(0xFF9CA3AF),
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
          color: const Color(0xFF450A0A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDC2626)),
        ),
        child: Text(
          _calculationError!,
          style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 13),
        ),
      );
    }

    final formattedResult = _computedResult != null
        ? (_computedResult! % 1 == 0
              ? _computedResult!.toStringAsFixed(0)
              : _computedResult!.toStringAsFixed(2))
        : '--';

    final resultUnit = widget.data.unit?.trim();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF101214),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D3238)),
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
                  color: Color(0xFF9CA3AF),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF34D399),
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
                  color: Color(0xFFF8FAFC),
                  letterSpacing: -1,
                ),
              ),
              if (resultUnit != null && resultUnit.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  resultUnit,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF60A5FA),
                  ),
                ),
              ],
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

    final badgeText = (param.unit != null && param.unit!.trim().isNotEmpty)
        ? '$formattedValue ${param.unit!.trim()}'.trim()
        : formattedValue;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF22262B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2D3238)),
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
                  color: Color(0xFFEAECF0),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2563EB)),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF93C5FD),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF3B82F6),
              inactiveTrackColor: const Color(0xFF374151),
              thumbColor: const Color(0xFF60A5FA),
              overlayColor: const Color(0x2960A5FA),
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
