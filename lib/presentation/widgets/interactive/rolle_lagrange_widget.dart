import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../domain/models/knowledge_node.dart';

/// Laboratorio didattico interattivo per i Teoremi del Calcolo Differenziale:
/// Teorema del Valor Medio di Lagrange e Teorema di Rolle.
/// Visualizza la curva cubica f(x) = x³/3 - x, la corda secante tra (a, f(a)) e (b, f(b)),
/// e individua in tempo reale il punto c ∈ (a, b) con retta tangente parallela (f'(c) = m).
class RolleLagrangeWidget extends StatefulWidget {
  final InteractiveData? data;

  const RolleLagrangeWidget({super.key, this.data});

  @override
  State<RolleLagrangeWidget> createState() => _RolleLagrangeWidgetState();
}

enum TheoremMode { lagrange, rolle }

class _RolleLagrangeWidgetState extends State<RolleLagrangeWidget>
    with SingleTickerProviderStateMixin {
  TheoremMode _mode = TheoremMode.lagrange;
  double _a = -1.8;
  double _b = 1.4;
  bool _isAutoAnimating = false;

  late final AnimationController _animController;

  // Funzione polinomiale f(x) = x^3 / 3 - x
  double _f(double x) => (x * x * x) / 3.0 - x;

  // Derivata prima f'(x) = x^2 - 1
  double _fPrime(double x) => x * x - 1.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..addListener(_onAnimTick);
  }

  void _onAnimTick() {
    if (_isAutoAnimating) {
      final t = Curves.easeInOutSine.transform(_animController.value);
      setState(() {
        if (_mode == TheoremMode.lagrange) {
          // Varia l'estremo b per mostrare il movimento parallelo della tangente
          _a = -2.0 + t * 0.5; // [-2.0, -1.5]
          _b = 0.8 + t * 1.2;  // [0.8, 2.0]
        } else {
          // In modalità Rolle manteniamo f(a) = f(b) = 0 attorno alle radici [-√3, √3]
          final span = 1.2 + t * 0.532; // oscilla fino a sqrt(3) ~ 1.732
          _a = -span;
          _b = span;
        }
      });
    }
  }

  void _toggleAutoAnimate() {
    setState(() {
      _isAutoAnimating = !_isAutoAnimating;
      if (_isAutoAnimating) {
        _animController.repeat(reverse: true);
      } else {
        _animController.stop();
      }
    });
  }

  @override
  void dispose() {
    _animController.removeListener(_onAnimTick);
    _animController.dispose();
    super.dispose();
  }

  // Pendenza della retta secante passante per (a, f(a)) e (b, f(b))
  double get _secantSlope {
    final dx = _b - _a;
    if (dx.abs() < 1e-4) return 0.0;
    return (_f(_b) - _f(_a)) / dx;
  }

  // Calcolo del punto interno c ∈ (a, b) tale che f'(c) = secantSlope
  // Per f'(c) = c^2 - 1 = m => c^2 = m + 1 => c = ±√(m + 1)
  double get _interiorPointC {
    final m = _secantSlope;
    final val = m + 1.0;
    if (val < 0) {
      // Fallback a punto medio se non reale
      return (_a + _b) / 2.0;
    }
    final cPos = math.sqrt(val);
    final cNeg = -math.sqrt(val);

    // Seleziona il punto che cade effettivamente nell'intervallo aperto (a, b)
    if (cPos > _a && cPos < _b) {
      return cPos;
    }
    if (cNeg > _a && cNeg < _b) {
      return cNeg;
    }
    return (_a + _b) / 2.0;
  }

  bool get _isRolleConditionMet => (_f(_a) - _f(_b)).abs() < 0.08;

  @override
  Widget build(BuildContext context) {
    final m = _secantSlope;
    final c = _interiorPointC;
    final fPrimeC = _fPrime(c);
    final isRolle = _mode == TheoremMode.rolle;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF191C20),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2D3238)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header con Titolo, Selector Teorema e Toggle Animazione
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.insights_rounded,
                      color: Color(0xFF60A5FA),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Teoremi del Valor Medio & Rolle',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF8FAFC),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isAutoAnimating
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_fill_rounded,
                    ),
                    color: const Color(0xFF60A5FA),
                    iconSize: 26,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: _isAutoAnimating
                        ? 'Pausa simulazione'
                        : 'Avvia animazione a 60 FPS',
                    onPressed: _toggleAutoAnimate,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isRolle
                          ? const Color(0xFF3B2D12)
                          : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isRolle
                            ? const Color(0xFFB45309)
                            : const Color(0xFF3B82F6),
                      ),
                    ),
                    child: Text(
                      isRolle ? 'Rolle: f\'(c) = 0' : 'Lagrange: f\'(c) = m',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isRolle
                            ? const Color(0xFFFCD34D)
                            : const Color(0xFF60A5FA),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Segmented Buttons per alternare Teorema di Lagrange / Teorema di Rolle
          Row(
            children: [
              Expanded(
                child: _buildModeTab(
                  mode: TheoremMode.lagrange,
                  label: 'Teorema di Lagrange',
                  subLabel: 'Secante || Tangente',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeTab(
                  mode: TheoremMode.rolle,
                  label: 'Teorema di Rolle',
                  subLabel: 'f(a) = f(b) ⇒ Tangente Orizzontale',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Canvas Grafico Interattivo
          SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFF0F172A), // Dark Canvas elegante
                child: CustomPaint(
                  painter: _RolleLagrangePainter(
                    a: _a,
                    b: _b,
                    c: c,
                    f: _f,
                    secantSlope: m,
                    isRolle: isRolle,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Telemetria in Tempo Reale
          Row(
            children: [
              Expanded(
                child: _buildTelemetryBox(
                  title: 'PENDENZA SECANTE',
                  value: m.toStringAsFixed(3),
                  formula: 'm = [f(b)-f(a)] / (b-a)',
                  color: const Color(0xFFF59E0B),
                  icon: Icons.timeline_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTelemetryBox(
                  title: isRolle ? "DERIVATE f'(c)" : 'DERIVATA TANGENTE',
                  value: isRolle ? '0.000' : fPrimeC.toStringAsFixed(3),
                  formula: isRolle ? "f'(±1) = 0" : "f'(c) = c² - 1",
                  color: const Color(0xFF10B981),
                  icon: Icons.trending_up_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTelemetryBox(
                  title: isRolle ? 'STAZIONARI c₁, c₂' : 'PUNTO INTERNO c',
                  value: isRolle ? 'c₁=-1, c₂=+1' : c.toStringAsFixed(2),
                  formula: isRolle ? 'y = ±2/3' : 'c ∈ (a, b)',
                  color: const Color(0xFF6366F1),
                  icon: Icons.gps_fixed_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Insight Didattico e Corollario Visivo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF14171A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2D3238)),
            ),
            child: Row(
              children: [
                Icon(
                  isRolle && _isRolleConditionMet
                      ? Icons.check_circle_rounded
                      : Icons.lightbulb_rounded,
                  size: 16,
                  color: isRolle && _isRolleConditionMet
                      ? const Color(0xFF4ADE80)
                      : const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isRolle
                        ? (_isRolleConditionMet
                            ? 'Condizione di Rolle verificata: f(a) ≈ f(b) = ${_f(_a).toStringAsFixed(2)}. Entrambi i punti stazionari c₁ = -1 (y = +2/3) e c₂ = +1 (y = -2/3) hanno tangente orizzontale parallela alla secante!'
                            : 'Regola a e b affinché f(a) = f(b) per visualizzare le tangenti orizzontali.')
                        : 'La retta tangente verde nel punto c = ${c.toStringAsFixed(2)} è parallela alla corda secante arancione: le due pendenze coincidono (m = ${m.toStringAsFixed(3)})!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isRolle && _isRolleConditionMet
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sliders di Controllo Intervallo [a, b]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estremo sinistro intervallo (a):',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                'a = ${_a.toStringAsFixed(2)}  [f(a) = ${_f(_a).toStringAsFixed(2)}]',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFBBF24),
                ),
              ),
            ],
          ),
          Slider(
            value: _a.clamp(-2.4, -0.2),
            min: -2.4,
            max: -0.2,
            divisions: 44,
            activeColor: const Color(0xFFF59E0B),
            inactiveColor: const Color(0xFF334155),
            onChanged: (val) {
              if (_isAutoAnimating) {
                setState(() {
                  _isAutoAnimating = false;
                  _animController.stop();
                });
              }
              setState(() {
                _a = val;
                if (_mode == TheoremMode.rolle) {
                  // In modalità Rolle sincronizza l'estremo per uguagliare f(a) = f(b)
                  _b = -val;
                }
              });
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estremo destro intervallo (b):',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                'b = ${_b.toStringAsFixed(2)}  [f(b) = ${_f(_b).toStringAsFixed(2)}]',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFBBF24),
                ),
              ),
            ],
          ),
          Slider(
            value: _b.clamp(0.2, 2.4),
            min: 0.2,
            max: 2.4,
            divisions: 44,
            activeColor: const Color(0xFFF59E0B),
            inactiveColor: const Color(0xFF334155),
            onChanged: (val) {
              if (_isAutoAnimating) {
                setState(() {
                  _isAutoAnimating = false;
                  _animController.stop();
                });
              }
              setState(() {
                _b = val;
                if (_mode == TheoremMode.rolle) {
                  _a = -val;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab({
    required TheoremMode mode,
    required String label,
    required String subLabel,
  }) {
    final isSelected = _mode == mode;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          _mode = mode;
          if (mode == TheoremMode.rolle) {
            _a = -math.sqrt(3);
            _b = math.sqrt(3);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF14171A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF2D3238),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? const Color(0xFF60A5FA)
                    : const Color(0xFFCBD5E1),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF93C5FD)
                    : const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryBox({
    required String title,
    required String value,
    required String formula,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            formula,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// CustomPainter per il tracciamento della curva cubica, della retta secante e della tangente parallela
class _RolleLagrangePainter extends CustomPainter {
  final double a;
  final double b;
  final double c;
  final double Function(double) f;
  final double secantSlope;
  final bool isRolle;

  _RolleLagrangePainter({
    required this.a,
    required this.b,
    required this.c,
    required this.f,
    required this.secantSlope,
    required this.isRolle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const xMin = -2.8;
    const xMax = 2.8;
    const yMin = -2.2;
    const yMax = 2.2;

    Offset toPixel(double x, double y) {
      final px = (x - xMin) / (xMax - xMin) * size.width;
      final py = size.height - (y - yMin) / (yMax - yMin) * size.height;
      return Offset(px, py);
    }

    // Griglia cartesiana di sfondo
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 0.8;

    for (double gx = -2.0; gx <= 2.0; gx += 1.0) {
      canvas.drawLine(toPixel(gx, yMin), toPixel(gx, yMax), gridPaint);
    }
    for (double gy = -2.0; gy <= 2.0; gy += 1.0) {
      canvas.drawLine(toPixel(xMin, gy), toPixel(xMax, gy), gridPaint);
    }

    // Assi Cartesiani X e Y
    final axisPaint = Paint()
      ..color = const Color(0xFF475569)
      ..strokeWidth = 1.4;

    canvas.drawLine(toPixel(xMin, 0), toPixel(xMax, 0), axisPaint);
    canvas.drawLine(toPixel(0, yMin), toPixel(0, yMax), axisPaint);

    // 1. Tracciamento Curva Funzione f(x) = x³/3 - x
    final curvePath = Path();
    bool first = true;
    for (double px = 0; px <= size.width; px += 2.0) {
      final x = xMin + (px / size.width) * (xMax - xMin);
      final y = f(x);
      final pt = toPixel(x, y);
      if (first) {
        curvePath.moveTo(pt.dx, pt.dy);
        first = false;
      } else {
        curvePath.lineTo(pt.dx, pt.dy);
      }
    }

    final curvePaint = Paint()
      ..color = const Color(0xFF38BDF8) // Celeste brillante
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(curvePath, curvePaint);

    // Coordinate dei punti chiave
    final fa = f(a);
    final fb = f(b);
    final fc = f(c);

    final ptA = toPixel(a, fa);
    final ptB = toPixel(b, fb);
    final ptC = toPixel(c, fc);

    // Linee guida tratteggiate verticali verso l'asse X per A e B
    final dashPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 1.0;

    _drawDashedLine(canvas, toPixel(a, 0), ptA, dashPaint);
    _drawDashedLine(canvas, toPixel(b, 0), ptB, dashPaint);

    // 2. Retta Secante AB prolungata (Arancione)
    final secantPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Equazione secante prolungata: y - fa = m * (x - a)
    final secantLeft = toPixel(xMin, fa + secantSlope * (xMin - a));
    final secantRight = toPixel(xMax, fa + secantSlope * (xMax - a));
    canvas.drawLine(secantLeft, secantRight, secantPaint);

    // Punti A e B evidenziati
    final endPointPaint = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawCircle(ptA, 5.5, endPointPaint);
    canvas.drawCircle(ptB, 5.5, endPointPaint);

    // Etichette A e B
    _drawLabel(canvas, 'A(a, f(a))', Offset(ptA.dx - 12, ptA.dy - 18), const Color(0xFFFDE68A));
    _drawLabel(canvas, 'B(b, f(b))', Offset(ptB.dx - 12, ptB.dy - 18), const Color(0xFFFDE68A));

    // 3. Retta/e Tangente/i parallela/e alla secante (Smeraldo)
    final tangentPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final centerPaint = Paint()..color = const Color(0xFF10B981);

    if (isRolle) {
      // In modalità Rolle: mostra entrambi i punti stazionari c₁ = -1, c₂ = +1
      // e le tangenti orizzontali y = +2/3 e y = -2/3 se contenuti nell'intervallo [a, b]
      const c1 = -1.0;
      const fc1 = 2.0 / 3.0;
      final hasC1 = c1 >= a && c1 <= b;

      const c2 = 1.0;
      const fc2 = -2.0 / 3.0;
      final hasC2 = c2 >= a && c2 <= b;

      if (hasC1) {
        final ptC1 = toPixel(c1, fc1);
        _drawDashedLine(canvas, toPixel(c1, 0), ptC1, dashPaint..color = const Color(0xFF10B981));
        // Tangente orizzontale y = +2/3
        canvas.drawLine(toPixel(xMin, fc1), toPixel(xMax, fc1), tangentPaint);
        // Punto C1 con alone luminoso
        canvas.drawCircle(ptC1, 7.0, Paint()..color = const Color(0x6610B981));
        canvas.drawCircle(ptC1, 4.5, centerPaint);
        _drawLabel(canvas, 'C₁(-1, ⅔)', Offset(ptC1.dx - 22, ptC1.dy - 18), const Color(0xFF6EE7B7));
        _drawLabel(canvas, 'y = +⅔', Offset(toPixel(xMax - 0.7, fc1).dx, toPixel(xMax, fc1).dy - 14), const Color(0xAA10B981));
      }

      if (hasC2) {
        final ptC2 = toPixel(c2, fc2);
        _drawDashedLine(canvas, toPixel(c2, 0), ptC2, dashPaint..color = const Color(0xFF10B981));
        // Tangente orizzontale y = -2/3
        canvas.drawLine(toPixel(xMin, fc2), toPixel(xMax, fc2), tangentPaint);
        // Punto C2 con alone luminoso
        canvas.drawCircle(ptC2, 7.0, Paint()..color = const Color(0x6610B981));
        canvas.drawCircle(ptC2, 4.5, centerPaint);
        _drawLabel(canvas, 'C₂(1, -⅔)', Offset(ptC2.dx - 22, ptC2.dy + 10), const Color(0xFF6EE7B7));
        _drawLabel(canvas, 'y = -⅔', Offset(toPixel(xMax - 0.7, fc2).dx, toPixel(xMax, fc2).dy + 4), const Color(0xAA10B981));
      }

      if (!hasC1 && !hasC2) {
        // Fallback sul punto interno calcolato
        _drawDashedLine(canvas, toPixel(c, 0), ptC, dashPaint..color = const Color(0xFF10B981));
        final tangentLeft = toPixel(xMin, fc + secantSlope * (xMin - c));
        final tangentRight = toPixel(xMax, fc + secantSlope * (xMax - c));
        canvas.drawLine(tangentLeft, tangentRight, tangentPaint);
        canvas.drawCircle(ptC, 7.0, Paint()..color = const Color(0x6610B981));
        canvas.drawCircle(ptC, 4.5, centerPaint);
        _drawLabel(canvas, 'C(c, f(c))', Offset(ptC.dx - 14, ptC.dy + 10), const Color(0xFF6EE7B7));
      }
    } else {
      // In modalità Lagrange: punto c interno e retta tangente parallela alla corda secante
      _drawDashedLine(canvas, toPixel(c, 0), ptC, dashPaint..color = const Color(0xFF10B981));
      final tangentLeft = toPixel(xMin, fc + secantSlope * (xMin - c));
      final tangentRight = toPixel(xMax, fc + secantSlope * (xMax - c));
      canvas.drawLine(tangentLeft, tangentRight, tangentPaint);

      // Punto di tangenza C evidenziato con doppio cerchio luminoso
      canvas.drawCircle(ptC, 7.0, Paint()..color = const Color(0x6610B981));
      canvas.drawCircle(ptC, 4.5, centerPaint);
      _drawLabel(canvas, 'C(c, f(c))', Offset(ptC.dx - 14, ptC.dy + 10), const Color(0xFF6EE7B7));
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 3.0;
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    if (distance == 0) return;

    final unitX = dx / distance;
    final unitY = dy / distance;
    double current = 0.0;

    while (current < distance) {
      final start = Offset(p1.dx + unitX * current, p1.dy + unitY * current);
      final endDistance = math.min(current + dashWidth, distance);
      final end = Offset(p1.dx + unitX * endDistance, p1.dy + unitY * endDistance);
      canvas.drawLine(start, end, paint);
      current += dashWidth + dashSpace;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _RolleLagrangePainter oldDelegate) {
    return oldDelegate.a != a ||
        oldDelegate.b != b ||
        oldDelegate.c != c ||
        oldDelegate.secantSlope != secantSlope ||
        oldDelegate.isRolle != isRolle;
  }
}
