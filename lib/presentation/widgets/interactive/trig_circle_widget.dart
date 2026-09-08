import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/models/knowledge_node.dart';

/// Widget interattivo a 60fps per l'esplorazione della Circonferenza Goniometrica.
/// Mostra in tempo reale il raggio vettore, il punto P(cos θ, sin θ), le proiezioni
/// ortogonali di seno (verde), coseno (azzurro), la retta tangente continua (ambra)
/// su tutti e 4 i quadranti con asintoti e frecce direzionali all'infinito,
/// drag diretto touch sul canvas e auto-rotazione continua.
class TrigCircleWidget extends StatefulWidget {
  final InteractiveData? data;

  const TrigCircleWidget({super.key, this.data});

  @override
  State<TrigCircleWidget> createState() => _TrigCircleWidgetState();
}

class _TrigCircleWidgetState extends State<TrigCircleWidget>
    with TickerProviderStateMixin {
  double _angleRad = math.pi / 4; // 45° default
  bool _isAutoRotating = false;

  late final AnimationController _autoRotateController;
  AnimationController? _chipAnimController;
  Animation<double>? _chipAnimation;

  double get _angleDeg => _angleRad * 180 / math.pi;
  double get _cosVal => math.cos(_angleRad);
  double get _sinVal => math.sin(_angleRad);
  double get _tanVal => math.tan(_angleRad);

  @override
  void initState() {
    super.initState();
    _autoRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..addListener(_onAutoRotateTick);
  }

  void _onAutoRotateTick() {
    if (_isAutoRotating) {
      setState(() {
        _angleRad = (_autoRotateController.value * 2 * math.pi) % (2 * math.pi);
      });
    }
  }

  void _toggleAutoRotate() {
    setState(() {
      _isAutoRotating = !_isAutoRotating;
      if (_isAutoRotating) {
        _autoRotateController.forward(
          from: (_angleRad % (2 * math.pi)) / (2 * math.pi),
        );
        _autoRotateController.repeat();
      } else {
        _autoRotateController.stop();
      }
    });
  }

  void _animateToAngle(double targetRad) {
    if (_isAutoRotating) {
      setState(() {
        _isAutoRotating = false;
        _autoRotateController.stop();
      });
    }

    _chipAnimController?.dispose();
    _chipAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    final startAngle = _angleRad;
    _chipAnimation = Tween<double>(
      begin: startAngle,
      end: targetRad,
    ).animate(CurvedAnimation(
      parent: _chipAnimController!,
      curve: Curves.easeOutCubic,
    ))..addListener(() {
      setState(() {
        _angleRad = _chipAnimation!.value;
      });
    });

    _chipAnimController!.forward();
  }

  void _updateAngleFromOffset(Offset localPos, Size size) {
    if (_isAutoRotating) {
      _toggleAutoRotate();
    }
    final center = Offset(size.width / 2, size.height / 2);
    final dx = localPos.dx - center.dx;
    final dy = -(localPos.dy - center.dy); // Inverti Y per cartesiano standard
    double angle = math.atan2(dy, dx);
    if (angle < 0) {
      angle += 2 * math.pi;
    }
    setState(() {
      _angleRad = angle;
    });
  }

  @override
  void dispose() {
    _autoRotateController.removeListener(_onAutoRotateTick);
    _autoRotateController.dispose();
    _chipAnimController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          // Header con Titolo, Badge Angolo e Auto-Rotazione
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
                    Icon(Icons.radar_rounded, color: Color(0xFFD946EF), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Circonferenza Goniometrica',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF8FAFC),
                      ),
                    ),
                  ],
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Auto-rotazione continua
                    IconButton(
                      icon: Icon(
                        _isAutoRotating
                            ? Icons.pause_circle_rounded
                            : Icons.play_circle_fill_rounded,
                      ),
                      color: const Color(0xFFE879F9),
                      iconSize: 26,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: _isAutoRotating
                          ? 'Ferma rotazione'
                          : 'Auto-rotazione continua 60 FPS',
                      onPressed: _toggleAutoRotate,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B123B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFC026D3)),
                      ),
                      child: Text(
                        'θ = ${_angleDeg.toStringAsFixed(1)}° (${(_angleRad / math.pi).toStringAsFixed(2)}π)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF5D0FE),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Canvas Cerchio Goniometrico con Touch/Drag Diretto
          LayoutBuilder(
            builder: (context, constraints) {
              final canvasSize = Size(constraints.maxWidth, 280);
              return Stack(
                children: [
                  GestureDetector(
                    onPanStart: (details) =>
                        _updateAngleFromOffset(details.localPosition, canvasSize),
                    onPanUpdate: (details) =>
                        _updateAngleFromOffset(details.localPosition, canvasSize),
                    onTapDown: (details) =>
                        _updateAngleFromOffset(details.localPosition, canvasSize),
                    child: SizedBox(
                      height: 280,
                      width: constraints.maxWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: const Color(0xFF0F172A), // Dark elegant canvas
                          child: CustomPaint(
                            painter: _TrigCirclePainter(angleRad: _angleRad),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x99000000),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            size: 11,
                            color: Color(0xFF94A3B8),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Trascina sul cerchio',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFFCBD5E1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Telemetria trigonometrica istantanea
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  label: 'cos(θ)',
                  value: _cosVal.toStringAsFixed(3),
                  color: const Color(0xFF38BDF8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  label: 'sin(θ)',
                  value: _sinVal.toStringAsFixed(3),
                  color: const Color(0xFF4ADE80),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  label: 'tan(θ)',
                  value: _cosVal.abs() < 0.015
                      ? '±∞ (non def)'
                      : _tanVal.toStringAsFixed(3),
                  color: const Color(0xFFFBBF24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Verifica identità fondamentale
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF14171A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2D3238)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 16,
                  color: Color(0xFF4ADE80),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'sin²(θ) + cos²(θ) = ${(_sinVal * _sinVal + _cosVal * _cosVal).toStringAsFixed(3)} = 1 (Identità Fondamentale)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE2E8F0),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Slider per l'angolo θ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Regola l\'angolo θ (da 0 a 2π):',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_angleDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE879F9),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFD946EF),
              inactiveTrackColor: const Color(0xFF334155),
              thumbColor: const Color(0xFFE879F9),
              trackHeight: 4,
            ),
            child: Slider(
              value: _angleRad,
              min: 0.0,
              max: 2 * math.pi,
              onChanged: (val) {
                if (_isAutoRotating) {
                  _toggleAutoRotate();
                }
                setState(() {
                  _angleRad = val;
                });
              },
            ),
          ),

          // Scorciatoie animate per angoli notevoli
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAngleChip('0°', 0),
                _buildAngleChip('30° (π/6)', math.pi / 6),
                _buildAngleChip('45° (π/4)', math.pi / 4),
                _buildAngleChip('60° (π/3)', math.pi / 3),
                _buildAngleChip('90° (π/2)', math.pi / 2),
                _buildAngleChip('120° (2π/3)', 2 * math.pi / 3),
                _buildAngleChip('135° (3π/4)', 3 * math.pi / 4),
                _buildAngleChip('180° (π)', math.pi),
                _buildAngleChip('270° (3π/2)', 3 * math.pi / 2),
                _buildAngleChip('360° (2π)', 2 * math.pi),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF14171A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2D3238)),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFFF8FAFC),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAngleChip(String label, double rad) {
    final isSelected = (_angleRad - rad).abs() < 0.04;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFF86198F),
        backgroundColor: const Color(0xFF14171A),
        side: BorderSide(
          color: isSelected ? const Color(0xFFD946EF) : const Color(0xFF2D3238),
        ),
        onSelected: (_) {
          _animateToAngle(rad);
        },
      ),
    );
  }
}

class _TrigCirclePainter extends CustomPainter {
  final double angleRad;

  _TrigCirclePainter({required this.angleRad});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width * 0.35, size.height * 0.26).clamp(65.0, 75.0);

    final axisPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.0;

    final circlePaint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 1. Assi cartesiani principali
    canvas.drawLine(
      Offset(12, center.dy),
      Offset(size.width - 12, center.dy),
      axisPaint,
    );
    canvas.drawLine(
      Offset(center.dx, 12),
      Offset(center.dx, size.height - 12),
      axisPaint,
    );

    // Cerchio unitario
    canvas.drawCircle(center, radius, circlePaint);

    // Coordinate punto P sul cerchio unitario
    final cosVal = math.cos(angleRad);
    final sinVal = math.sin(angleRad);
    final pPoint = Offset(
      center.dx + cosVal * radius,
      center.dy - sinVal * radius,
    );
    final cosPoint = Offset(center.dx + cosVal * radius, center.dy);

    // 2. Retta tangente verticale di riferimento x = 1
    final tanLineX = center.dx + radius;
    final refLinePaint = Paint()
      ..color = const Color(0x33FBBF24)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    
    // Disegna asse delle tangenti tratteggiato verticale x = 1
    const dashHeight = 6.0;
    const dashGap = 4.0;
    double currentY = 10.0;
    while (currentY < size.height - 10.0) {
      canvas.drawLine(
        Offset(tanLineX, currentY),
        Offset(tanLineX, currentY + dashHeight),
        refLinePaint,
      );
      currentY += dashHeight + dashGap;
    }

    // Etichetta asse tangente x = 1
    final tanLabelPainter = TextPainter(
      text: const TextSpan(
        text: 'x = 1',
        style: TextStyle(
          color: Color(0x88FBBF24),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tanLabelPainter.paint(canvas, Offset(tanLineX + 4, 12));

    // Marker punto di tangenza base (1, 0)
    canvas.drawCircle(
      Offset(tanLineX, center.dy),
      2.5,
      Paint()..color = const Color(0xFFFBBF24),
    );

    // 3. Calcolo e disegno della Tangente su tutti e 4 i quadranti
    // L'asintoto si verifica ESCLUSIVAMENTE a θ = π/2 o 3π/2 (|cos θ| < 0.015, circa entro 1° da 90° e 270°)
    final isExactAsymptote = cosVal.abs() < 0.015;

    if (isExactAsymptote) {
      // All'asintoto (cos θ ~ 0, θ ~ π/2 o 3π/2):
      // Il raggio vettore è verticale e parallelo alla retta x = 1 (nessuna intersezione, tan θ non definita)
      final asympPaint = Paint()
        ..color = const Color(0xFFF43F5E)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      _drawDashedLine(
        canvas,
        Offset(tanLineX, 6),
        Offset(tanLineX, size.height - 6),
        asympPaint,
        dashWidth: 6.0,
        dashSpace: 4.0,
      );

      final deg = (angleRad * 180 / math.pi).round();
      final textP = TextPainter(
        text: TextSpan(
          text: 'θ ≈ $deg°: retta parallela a x = 1 (nessuna intersezione, tan θ non definita)',
          style: const TextStyle(
            color: Color(0xFFF43F5E),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textP.paint(canvas, Offset(center.dx - textP.width / 2, 14));
    } else {
      // Per TUTTI gli angoli non all'asintoto (es. 30°, 45°, 60°, 120°, 135°, ecc.):
      // Calcola l'esatto punto di intersezione T(1, tan θ) sulla retta x = 1
      final tanVal = math.tan(angleRad);
      final rawTanY = center.dy - tanVal * radius;

      // Verifica se il punto T è all'interno della finestra visibile
      final isPointInside = rawTanY >= 8.0 && rawTanY <= size.height - 8.0;
      final clampedTanY = rawTanY.clamp(0.0, size.height);

      // Calcolo del punto target della secante
      Offset secantTarget;
      if (isPointInside) {
        secantTarget = Offset(tanLineX, rawTanY);
      } else {
        final exitY = rawTanY < 8.0 ? 0.0 : size.height;
        final exitX = center.dx - (exitY - center.dy) / tanVal;
        secantTarget = Offset(exitX, exitY);
      }

      final secantPaint = Paint()
        ..color = const Color(0x77FBBF24)
        ..strokeWidth = 1.5;

      // Collinearità su tutti e 4 i quadranti:
      // Se cos(θ) >= 0 (Q1 e Q4): il raggio secante esce direttamente verso il semipiano destro (x = 1)
      // Se cos(θ) < 0 (Q2 e Q3): prolungamento all'indietro tratteggiato attraverso l'origine verso x = 1
      if (cosVal >= 0) {
        canvas.drawLine(center, secantTarget, secantPaint);
      } else {
        _drawDashedLine(
          canvas,
          center,
          secantTarget,
          secantPaint,
          dashWidth: 4.0,
          dashSpace: 3.0,
        );
      }

      // Segmento della tangente lungo la retta x = 1 da (1, 0) a T(1, tan θ)
      final tanSegPaint = Paint()
        ..color = const Color(0xFFFBBF24)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(tanLineX, center.dy),
        Offset(tanLineX, clampedTanY),
        tanSegPaint,
      );

      if (isPointInside) {
        // Disegna il punto T(1, tan θ) reale
        canvas.drawCircle(
          Offset(tanLineX, rawTanY),
          5.5,
          Paint()..color = const Color(0xFFFBBF24),
        );
        canvas.drawCircle(
          Offset(tanLineX, rawTanY),
          2.0,
          Paint()..color = Colors.white,
        );

        // Etichetta coordinata T
        final tLabel = TextPainter(
          text: TextSpan(
            text: 'T(1, ${tanVal.toStringAsFixed(2)})',
            style: const TextStyle(
              color: Color(0xFFFBBF24),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final labelY = (rawTanY - tLabel.height / 2).clamp(10.0, size.height - 20.0);
        tLabel.paint(canvas, Offset(tanLineX + 8, labelY));
      } else {
        // Se il punto T supera la finestra visiva ma non siamo all'asintoto,
        // disegna un piccolo marcatore sul bordo senza frecce o diciture di infinito fuorvianti
        canvas.drawCircle(
          Offset(tanLineX, clampedTanY),
          3.0,
          Paint()..color = const Color(0xFFFBBF24),
        );
      }
    }

    // 4. Vettore coseno (orizzontale azzurro)
    final cosPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, cosPoint, cosPaint);

    // 5. Vettore seno (verticale verde)
    final sinPaint = Paint()
      ..color = const Color(0xFF4ADE80)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(cosPoint, pPoint, sinPaint);

    // 6. Raggio vettore unitario (bianco candido)
    final radiusPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, pPoint, radiusPaint);

    // 7. Arco angolo θ
    final arcPaint = Paint()
      ..color = const Color(0xFFE879F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 26),
      0,
      -angleRad,
      false,
      arcPaint,
    );

    // 8. Punto P(cos θ, sin θ) con alone luminoso
    final glowPaint = Paint()
      ..color = const Color(0x55F43F5E)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(pPoint, 8.0, glowPaint);

    final pointPaint = Paint()..color = const Color(0xFFF43F5E);
    canvas.drawCircle(pPoint, 5.5, pointPaint);
    canvas.drawCircle(pPoint, 2.0, Paint()..color = Colors.white);
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint, {
    double dashWidth = 4.0,
    double dashSpace = 3.0,
  }) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    if (distance <= 0) return;

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

  @override
  bool shouldRepaint(covariant _TrigCirclePainter oldDelegate) {
    return oldDelegate.angleRad != angleRad;
  }
}
