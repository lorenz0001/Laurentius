import 'package:flutter/material.dart';

import '../../../domain/models/knowledge_node.dart';

/// Widget interattivo per la visualizzazione geometrica della Derivata e del Rapporto Incrementale.
/// Dimostra visivamente che per h -> 0 la retta secante passante per P(x₀, f(x₀))
/// e Q(x₀+h, f(x₀+h)) collassa esattamente sulla retta tangente con pendenza f'(x₀).
class DerivativeTangentWidget extends StatefulWidget {
  final InteractiveData? data;

  const DerivativeTangentWidget({super.key, this.data});

  @override
  State<DerivativeTangentWidget> createState() =>
      _DerivativeTangentWidgetState();
}

class _DerivativeTangentWidgetState extends State<DerivativeTangentWidget>
    with SingleTickerProviderStateMixin {
  double _x0 = 1.0;
  double _h = 1.2;
  bool _isAutoAnimating = false;

  late final AnimationController _limitAnimController;

  // Funzione parabolica di base f(x) = 0.5 * x^2
  double _f(double x) => 0.5 * x * x;

  // Derivata esatta f'(x) = x
  double _fPrime(double x) => x;

  @override
  void initState() {
    super.initState();
    _limitAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(_onLimitAnimTick);
  }

  void _onLimitAnimTick() {
    if (_isAutoAnimating) {
      setState(() {
        // h oscilla dolcemente tra 2.0 e 0.04 dimostrando il passaggio al limite
        final t = Curves.easeInOutCubic.transform(_limitAnimController.value);
        _h = 2.0 - t * 1.95;
      });
    }
  }

  void _toggleAutoAnimate() {
    setState(() {
      _isAutoAnimating = !_isAutoAnimating;
      if (_isAutoAnimating) {
        _limitAnimController.repeat(reverse: true);
      } else {
        _limitAnimController.stop();
      }
    });
  }

  @override
  void dispose() {
    _limitAnimController.removeListener(_onLimitAnimTick);
    _limitAnimController.dispose();
    super.dispose();
  }

  double get _fx0 => _f(_x0);
  double get _fx0PlusH => _f(_x0 + _h);

  // Rapporto incrementale: (f(x0 + h) - f(x0)) / h
  double get _differenceQuotient => (_fx0PlusH - _fx0) / _h;

  // Derivata teorica esatta
  double get _exactDerivative => _fPrime(_x0);

  // Errore tra secante e tangente
  double get _error => (_differenceQuotient - _exactDerivative).abs();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header con Titolo, Toggle Animazione e Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.show_chart_rounded,
                    color: Color(0xFF4F46E5),
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Rapporto Incrementale & Tangente',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isAutoAnimating
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_fill_rounded,
                    ),
                    color: const Color(0xFF4F46E5),
                    iconSize: 26,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: _isAutoAnimating
                        ? 'Pausa animazione limite'
                        : 'Anima limite h ➔ 0 a 60 FPS',
                    onPressed: _toggleAutoAnimate,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: Text(
                      'h = ${_h.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4338CA),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Canvas Grafico Secante / Tangente
          SizedBox(
            height: 240,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFF0F172A),
                child: CustomPaint(
                  painter: _DerivativeTangentPainter(
                    x0: _x0,
                    h: _h,
                    f: _f,
                    fPrime: _fPrime,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Confronto numerico istantaneo
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  label: 'Secante: Δy / h',
                  value: _differenceQuotient.toStringAsFixed(3),
                  color: const Color(0xFFF59E0B),
                  subtitle: 'Pendenza secante',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  label: 'Derivata: f\'(x₀)',
                  value: _exactDerivative.toStringAsFixed(3),
                  color: const Color(0xFF38BDF8),
                  subtitle: 'Pendenza tangente',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  label: 'Scostamento',
                  value: _error.toStringAsFixed(3),
                  color: _error < 0.1
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  subtitle: 'Errore residuo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Descrizione intuitiva
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _h < 0.2
                      ? Icons.check_circle_rounded
                      : Icons.info_outline_rounded,
                  size: 16,
                  color: _h < 0.2
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF475569),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _h < 0.2
                        ? 'h → 0: La secante coincide visivamente con la retta tangente!'
                        : 'Muovi lo slider di h verso 0 per vedere il collasso della secante.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _h < 0.2
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF334155),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Slider Incremento h
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Incremento h (tende a 0):',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              Text(
                'h = ${_h.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ],
          ),
          Slider(
            value: _h.clamp(0.05, 2.5),
            min: 0.05,
            max: 2.5,
            activeColor: const Color(0xFF4F46E5),
            inactiveColor: const Color(0xFFC7D2FE),
            onChanged: (val) {
              if (_isAutoAnimating) {
                setState(() {
                  _isAutoAnimating = false;
                  _limitAnimController.stop();
                });
              }
              setState(() {
                _h = val;
              });
            },
          ),
          // Slider Punto x0
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Punto base x₀:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              Text(
                'x₀ = ${_x0.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          Slider(
            value: _x0,
            min: -2.0,
            max: 2.0,
            activeColor: const Color(0xFF38BDF8),
            inactiveColor: const Color(0xFFBAE6FD),
            onChanged: (val) => setState(() => _x0 = val),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _DerivativeTangentPainter extends CustomPainter {
  final double x0;
  final double h;
  final double Function(double) f;
  final double Function(double) fPrime;

  _DerivativeTangentPainter({
    required this.x0,
    required this.h,
    required this.f,
    required this.fPrime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height * 0.75);
    const scaleX = 45.0;
    const scaleY = 40.0;

    Offset toScreen(double x, double y) =>
        Offset(origin.dx + x * scaleX, origin.dy - y * scaleY);

    // Griglia assi
    final axisPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(10, origin.dy),
      Offset(size.width - 10, origin.dy),
      axisPaint,
    );
    canvas.drawLine(
      Offset(origin.dx, 10),
      Offset(origin.dx, size.height - 10),
      axisPaint,
    );

    // Curva f(x)
    final curvePath = Path();
    bool started = false;
    for (double x = -3.5; x <= 3.5; x += 0.05) {
      final p = toScreen(x, f(x));
      if (!started) {
        curvePath.moveTo(p.dx, p.dy);
        started = true;
      } else {
        curvePath.lineTo(p.dx, p.dy);
      }
    }
    final curvePaint = Paint()
      ..color = const Color(0xFF818CF8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(curvePath, curvePaint);

    // Punti P(x0, f(x0)) e Q(x0+h, f(x0+h))
    final pP = toScreen(x0, f(x0));
    final pQ = toScreen(x0 + h, f(x0 + h));

    // Retta Tangente in P: y - f(x0) = f'(x0) * (x - x0)
    final mTan = fPrime(x0);
    final tanP1 = toScreen(x0 - 2.0, f(x0) - mTan * 2.0);
    final tanP2 = toScreen(x0 + 2.0, f(x0) + mTan * 2.0);
    final tanPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 2.0;
    canvas.drawLine(tanP1, tanP2, tanPaint);

    // Retta Secante per P e Q: y - f(x0) = mSec * (x - x0)
    final mSec = (f(x0 + h) - f(x0)) / h;
    final secP1 = toScreen(x0 - 1.5, f(x0) - mSec * 1.5);
    final secP2 = toScreen(x0 + h + 1.5, f(x0 + h) + mSec * 1.5);
    final secPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 2.0;
    canvas.drawLine(secP1, secP2, secPaint);

    // Tratteggi verticali e orizzontali per triangolo del rapporto incrementale
    final corner = toScreen(x0 + h, f(x0));
    final dashPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 1.0;
    canvas.drawLine(pP, corner, dashPaint);
    canvas.drawLine(corner, pQ, dashPaint);

    // Disegna punti P e Q
    canvas.drawCircle(pP, 5, Paint()..color = const Color(0xFF38BDF8));
    canvas.drawCircle(pP, 2, Paint()..color = Colors.white);

    canvas.drawCircle(pQ, 5, Paint()..color = const Color(0xFFF59E0B));
    canvas.drawCircle(pQ, 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _DerivativeTangentPainter oldDelegate) {
    return oldDelegate.x0 != x0 || oldDelegate.h != h;
  }
}
