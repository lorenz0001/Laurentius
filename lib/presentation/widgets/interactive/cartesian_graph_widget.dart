import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../../domain/models/knowledge_node.dart';

/// Widget per il tracciamento interattivo di grafici cartesiani 2D.
/// Permette la deformazione dinamica delle curve (parabole, sinusoidi, logaritmi)
/// tramite slider per ciascun coefficiente matematico.
class CartesianGraphWidget extends StatefulWidget {
  final InteractiveData? data;

  const CartesianGraphWidget({super.key, this.data});

  @override
  State<CartesianGraphWidget> createState() => _CartesianGraphWidgetState();
}

class _CartesianGraphWidgetState extends State<CartesianGraphWidget>
    with SingleTickerProviderStateMixin {
  final Map<String, double> _paramValues = {};
  final GrammarParser _parser = GrammarParser();

  String _equationString = 'a * x * x + b * x + c';
  bool _isAutoMorphing = false;
  late final AnimationController _graphAnimController;

  @override
  void initState() {
    super.initState();
    _initializeParams();
    _graphAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(_onGraphAnimTick);
  }

  void _onGraphAnimTick() {
    if (_isAutoMorphing) {
      setState(() {
        // Oscilla dolcemente il parametro principale per mostrare la deformazione
        final t = Curves.easeInOutSine.transform(_graphAnimController.value);
        if (_paramValues.containsKey('a')) {
          _paramValues['a'] = -2.0 + t * 4.0;
        } else if (_paramValues.isNotEmpty) {
          final firstKey = _paramValues.keys.first;
          _paramValues[firstKey] = -2.0 + t * 4.0;
        }
      });
    }
  }

  void _toggleAutoMorph() {
    setState(() {
      _isAutoMorphing = !_isAutoMorphing;
      if (_isAutoMorphing) {
        _graphAnimController.repeat(reverse: true);
      } else {
        _graphAnimController.stop();
      }
    });
  }

  @override
  void dispose() {
    _graphAnimController.removeListener(_onGraphAnimTick);
    _graphAnimController.dispose();
    super.dispose();
  }

  void _initializeParams() {
    _paramValues.clear();

    final eq = widget.data?.equations?.firstOrNull;
    if (eq != null && eq.isNotEmpty) {
      _equationString = eq;
    }

    final params = widget.data?.parameters;
    if (params != null && params.isNotEmpty) {
      for (final p in params) {
        final name = p.variableName;
        if (name != null && name.isNotEmpty) {
          _paramValues[name] = p.defaultValue ?? p.minValue ?? 1.0;
        }
      }
    } else {
      // Default per parabola y = a*x^2 + b*x + c
      _paramValues['a'] = 1.0;
      _paramValues['b'] = 0.0;
      _paramValues['c'] = -2.0;
    }
  }

  double _evaluateY(double x) {
    try {
      final expression = _parser.parse(_equationString);
      final contextModel = ContextModel();

      _paramValues.forEach((key, value) {
        contextModel.bindVariable(Variable(key), Number(value));
      });
      contextModel.bindVariable(Variable('x'), Number(x));

      final evaluator = RealEvaluator(contextModel);
      final res = evaluator.evaluate(expression);
      final val = res.toDouble();
      return val.isFinite ? val : 0.0;
    } catch (_) {
      // Fallback analitico standard per y = a*x^2 + b*x + c
      final a = _paramValues['a'] ?? 1.0;
      final b = _paramValues['b'] ?? 0.0;
      final c = _paramValues['c'] ?? 0.0;
      return a * x * x + b * x + c;
    }
  }

  @override
  Widget build(BuildContext context) {
    final params =
        widget.data?.parameters ??
        [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Curvatura (a)'
            ..minValue = -3.0
            ..maxValue = 3.0
            ..stepSize = 0.1
            ..defaultValue = 1.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Traslazione orizzontale (b)'
            ..minValue = -4.0
            ..maxValue = 4.0
            ..stepSize = 0.2
            ..defaultValue = 0.0,
          InteractiveParameter()
            ..variableName = 'c'
            ..label = 'Termine noto (c)'
            ..minValue = -5.0
            ..maxValue = 5.0
            ..stepSize = 0.5
            ..defaultValue = -2.0,
        ];

    // Rappresentazione testuale della formula con valori sostituiti
    final a = _paramValues['a'] ?? 1.0;
    final b = _paramValues['b'] ?? 0.0;
    final c = _paramValues['c'] ?? 0.0;
    final formulaText =
        'y = ${a.toStringAsFixed(1)}x² ${b >= 0 ? '+ ' : '- '}${b.abs().toStringAsFixed(1)}x ${c >= 0 ? '+ ' : '- '}${c.abs().toStringAsFixed(1)}';

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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B4B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  color: Color(0xFF818CF8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grafico Cartesiano Dinamico',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEAECF0),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Modifica i coefficienti per osservare la deformazione della curva',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _isAutoMorphing
                      ? Icons.pause_circle_rounded
                      : Icons.play_circle_fill_rounded,
                ),
                color: const Color(0xFF818CF8),
                iconSize: 28,
                tooltip: _isAutoMorphing
                    ? 'Pausa deformazione'
                    : 'Anima deformazione curva',
                onPressed: _toggleAutoMorph,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Canvas del Piano Cartesiano
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF090D16),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                painter: _CartesianPainter(
                  evaluateY: _evaluateY,
                  a: a,
                  b: b,
                  c: c,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Badge Formula con valori correnti
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF101214),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2D3238)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'EQUAZIONE CORRENTE:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                Text(
                  formulaText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF818CF8),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sliders dei Parametri
          const Text(
            'COEFFICIENTI DELLA FUNZIONE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 8),

          ...params.map((param) => _buildParamSlider(param)),
        ],
      ),
    );
  }

  Widget _buildParamSlider(InteractiveParameter param) {
    final varName = param.variableName ?? '';
    final label = param.label ?? 'Parametro $varName';
    final min = param.minValue ?? -5.0;
    final max = param.maxValue ?? 5.0;
    final step = param.stepSize ?? 0.1;
    final currentValue = _paramValues[varName] ?? min;

    int? divisions;
    if (step > 0 && max > min) {
      divisions = ((max - min) / step).round();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF22262B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2D3238)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEAECF0),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B4B),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF4338CA)),
                ),
                child: Text(
                  currentValue.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA5B4FC),
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF818CF8),
              inactiveTrackColor: const Color(0xFF374151),
              thumbColor: const Color(0xFF818CF8),
              overlayColor: const Color(0xFF818CF8).withValues(alpha: 0.15),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: currentValue.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: (val) {
                if (_isAutoMorphing) {
                  setState(() {
                    _isAutoMorphing = false;
                    _graphAnimController.stop();
                  });
                }
                setState(() {
                  _paramValues[varName] = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter per il disegno vettoriale del piano cartesiano con assi X/Y, griglia metrica e curva funzione
class _CartesianPainter extends CustomPainter {
  final double Function(double x) evaluateY;
  final double a;
  final double b;
  final double c;

  _CartesianPainter({
    required this.evaluateY,
    required this.a,
    required this.b,
    required this.c,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Origine degli assi al centro
    final origin = Offset(w / 2, h / 2);

    // Scala di visualizzazione: quanti pixel per 1 unità matematica
    const scale = 18.0;

    // 1. Griglia di sfondo millimetrata
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 0.8;

    // Linee verticali
    for (double x = origin.dx % scale; x < w; x += scale) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    // Linee orizzontali
    for (double y = origin.dy % scale; y < h; y += scale) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // 2. Assi Principali X e Y
    final axisPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 1.8;

    // Asse X
    canvas.drawLine(Offset(0, origin.dy), Offset(w, origin.dy), axisPaint);
    // Asse Y
    canvas.drawLine(Offset(origin.dx, 0), Offset(origin.dx, h), axisPaint);

    // Frecce degli assi
    _drawArrow(canvas, Offset(w, origin.dy), 0); // Verso destra (X)
    _drawArrow(canvas, Offset(origin.dx, 0), -1.57); // Verso l'alto (Y)

    // Etichette X e Y
    _drawText(canvas, 'x', Offset(w - 14, origin.dy + 4));
    _drawText(canvas, 'y', Offset(origin.dx + 6, 4));

    // 3. Tracciamento continuo della Curva Funzione
    final curvePath = Path();
    bool hasStarted = false;

    // Campionamento da X = -w/2 a +w/2
    const stepPx = 1.5;
    for (double px = 0; px <= w; px += stepPx) {
      final mathX = (px - origin.dx) / scale;
      final mathY = evaluateY(mathX);
      final py = origin.dy - (mathY * scale);

      // Clamp visivo entro i bordi per non sforare
      if (py >= -20 && py <= h + 20) {
        if (!hasStarted) {
          curvePath.moveTo(px, py);
          hasStarted = true;
        } else {
          curvePath.lineTo(px, py);
        }
      } else {
        hasStarted = false;
      }
    }

    // Alone luminoso della curva
    final glowPaint = Paint()
      ..color = const Color(0x556366F1)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(curvePath, glowPaint);

    // Curva principale ad alta visibilità
    final curvePaint = Paint()
      ..color =
          const Color(0xFF818CF8) // Viola / Indaco luminoso
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(curvePath, curvePaint);

    // 4. Evidenziazione Vertice (se a != 0)
    if (a.abs() > 0.001) {
      final vx = -b / (2 * a);
      final vy = a * vx * vx + b * vx + c;

      final vScreenX = origin.dx + vx * scale;
      final vScreenY = origin.dy - vy * scale;

      if (vScreenX >= 0 && vScreenX <= w && vScreenY >= 0 && vScreenY <= h) {
        final dotPaint = Paint()..color = const Color(0xFFF59E0B);
        canvas.drawCircle(Offset(vScreenX, vScreenY), 4.5, dotPaint);

        _drawText(
          canvas,
          'V(${vx.toStringAsFixed(1)}, ${vy.toStringAsFixed(1)})',
          Offset(vScreenX + 6, vScreenY - 12),
          color: const Color(0xFFFCD34D),
        );
      }
    }
  }

  void _drawArrow(Canvas canvas, Offset tip, double angle) {
    final arrowPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(tip.dx - 6, tip.dy - 3)
      ..lineTo(tip.dx - 6, tip.dy + 3)
      ..close();
    canvas.drawPath(path, arrowPaint);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset, {
    Color color = const Color(0xFF94A3B8),
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _CartesianPainter oldDelegate) {
    return oldDelegate.a != a || oldDelegate.b != b || oldDelegate.c != c;
  }
}
