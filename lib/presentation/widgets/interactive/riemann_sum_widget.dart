import 'package:flutter/material.dart';

import '../../../domain/models/knowledge_node.dart';

/// Widget interattivo per la dimostrazione visiva dell'Integrale di Riemann e Somme di Rettangoli.
/// Permette di variare il numero di partizioni N nell'intervallo [a, b].
/// Mostra in tempo reale la convergenza dell'area a gradini all'area esatta sottesa
/// dalla curva (calcolata con la Formula Fondamentale del Calcolo di Barrow).
class RiemannSumWidget extends StatefulWidget {
  final InteractiveData? data;

  const RiemannSumWidget({super.key, this.data});

  @override
  State<RiemannSumWidget> createState() => _RiemannSumWidgetState();
}

class _RiemannSumWidgetState extends State<RiemannSumWidget>
    with SingleTickerProviderStateMixin {
  int _nRectangles = 6;
  final double _a = 0.0;
  final double _b = 2.0;
  bool _isAutoPartitioning = false;

  late final AnimationController _partitionAnimController;

  @override
  void initState() {
    super.initState();
    _partitionAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(_onPartitionTick);
  }

  void _onPartitionTick() {
    if (_isAutoPartitioning) {
      setState(() {
        // N varia dolcemente da 2 a 40 partizioni dimostrando la convergenza dell'area
        final t = Curves.easeInOutCubic.transform(_partitionAnimController.value);
        _nRectangles = (2 + t * 38).round();
      });
    }
  }

  void _toggleAutoPartition() {
    setState(() {
      _isAutoPartitioning = !_isAutoPartitioning;
      if (_isAutoPartitioning) {
        _partitionAnimController.repeat(reverse: true);
      } else {
        _partitionAnimController.stop();
      }
    });
  }

  @override
  void dispose() {
    _partitionAnimController.removeListener(_onPartitionTick);
    _partitionAnimController.dispose();
    super.dispose();
  }

  // Curva di prova: f(x) = 0.75 * x^2 + 0.5
  double _f(double x) => 0.75 * x * x + 0.5;

  // Primitiva F(x) = 0.25 * x^3 + 0.5 * x
  double _fPrimitive(double x) => 0.25 * x * x * x + 0.5 * x;

  // Integrale definito esatto (Formula di Barrow): F(b) - F(a)
  double get _exactIntegral => _fPrimitive(_b) - _fPrimitive(_a);

  // Somma di Riemann (punto medio dei rettangoli)
  double get _riemannSum {
    final dx = (_b - _a) / _nRectangles;
    double sum = 0.0;
    for (int i = 0; i < _nRectangles; i++) {
      final xMid = _a + (i + 0.5) * dx;
      sum += _f(xMid) * dx;
    }
    return sum;
  }

  double get _error => (_riemannSum - _exactIntegral).abs();

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
          // Header con Titolo, Play/Pausa e Badge N
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.view_column_rounded,
                    color: Color(0xFF2563EB),
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Integrale di Riemann',
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
                      _isAutoPartitioning
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_fill_rounded,
                    ),
                    color: const Color(0xFF2563EB),
                    iconSize: 26,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: _isAutoPartitioning
                        ? 'Pausa convergenza'
                        : 'Anima convergenza N ➔ 40',
                    onPressed: _toggleAutoPartition,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      'N = $_nRectangles Rettangoli',
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
          const SizedBox(height: 16),

          // Canvas Somme di Riemann
          SizedBox(
            height: 240,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFF0F172A),
                child: CustomPaint(
                  painter: _RiemannPainter(
                    nRectangles: _nRectangles,
                    a: _a,
                    b: _b,
                    f: _f,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Telemetria di convergenza
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  label: 'Somma Riemann: Σ',
                  value: _riemannSum.toStringAsFixed(3),
                  color: const Color(0xFF38BDF8),
                  subtitle: 'Area rettangoli',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  label: 'Integrale Esatto: ∫',
                  value: _exactIntegral.toStringAsFixed(3),
                  color: const Color(0xFF4ADE80),
                  subtitle: 'Formula di Barrow',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  label: 'Errore |Σ - ∫|',
                  value: _error.toStringAsFixed(4),
                  color: _error < 0.05
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                  subtitle: 'Convergenza',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Messaggio educativo
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
                  _nRectangles >= 20
                      ? Icons.check_circle_rounded
                      : Icons.insights_rounded,
                  size: 16,
                  color: _nRectangles >= 20
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF475569),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _nRectangles >= 20
                        ? 'Per N → ∞, la somma dei rettangoli coincide con l\'integrale definito!'
                        : 'Aumenta N per infittire i rettangoli e ridurre l\'errore residuo.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _nRectangles >= 20
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

          // Slider Rettangoli N
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Partizione intervallo (N rettangoli):',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              Text(
                'N = $_nRectangles (Δx = ${((_b - _a) / _nRectangles).toStringAsFixed(3)})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          Slider(
            value: _nRectangles.toDouble(),
            min: 2,
            max: 40,
            divisions: 38,
            activeColor: const Color(0xFF2563EB),
            inactiveColor: const Color(0xFFBFDBFE),
            onChanged: (val) {
              if (_isAutoPartitioning) {
                setState(() {
                  _isAutoPartitioning = false;
                  _partitionAnimController.stop();
                });
              }
              setState(() => _nRectangles = val.round());
            },
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

class _RiemannPainter extends CustomPainter {
  final int nRectangles;
  final double a;
  final double b;
  final double Function(double) f;

  _RiemannPainter({
    required this.nRectangles,
    required this.a,
    required this.b,
    required this.f,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width * 0.15, size.height * 0.85);
    final plotWidth = size.width * 0.75;
    final plotHeight = size.height * 0.70;

    final scaleX = plotWidth / (b - a + 0.5);
    final scaleY = plotHeight / 4.0;

    Offset toScreen(double x, double y) =>
        Offset(origin.dx + x * scaleX, origin.dy - y * scaleY);

    // Griglia e assi
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

    final dx = (b - a) / nRectangles;

    // Disegna rettangoli di Riemann
    final rectPaint = Paint()
      ..color = const Color(0x6638BDF8)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < nRectangles; i++) {
      final xLeft = a + i * dx;
      final xMid = a + (i + 0.5) * dx;
      final height = f(xMid);

      final pTopLeft = toScreen(xLeft, height);
      final pBottomRight = toScreen(xLeft + dx, 0);

      final rect = Rect.fromPoints(pTopLeft, pBottomRight);
      canvas.drawRect(rect, rectPaint);
      canvas.drawRect(rect, borderPaint);
    }

    // Curva continua f(x)
    final curvePath = Path();
    bool started = false;
    for (double x = 0.0; x <= b + 0.3; x += 0.04) {
      final p = toScreen(x, f(x));
      if (!started) {
        curvePath.moveTo(p.dx, p.dy);
        started = true;
      } else {
        curvePath.lineTo(p.dx, p.dy);
      }
    }
    final curvePaint = Paint()
      ..color = const Color(0xFFF43F5E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(curvePath, curvePaint);
  }

  @override
  bool shouldRepaint(covariant _RiemannPainter oldDelegate) {
    return oldDelegate.nRectangles != nRectangles ||
        oldDelegate.a != a ||
        oldDelegate.b != b;
  }
}
