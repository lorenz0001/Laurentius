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
      duration: const Duration(seconds: 10),
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
      _toggleAutoRotate();
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
          // Header con Titolo, Badge Angolo e Auto-Rotazione
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.radar_rounded, color: Color(0xFFD946EF), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Circonferenza Goniometrica',
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
                  // Auto-rotazione continua
                  IconButton(
                    icon: Icon(
                      _isAutoRotating
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_fill_rounded,
                    ),
                    color: const Color(0xFFC026D3),
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
                      color: const Color(0xFFFDF4FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFF5D0FE)),
                    ),
                    child: Text(
                      'θ = ${_angleDeg.toStringAsFixed(1)}° (${(_angleRad / math.pi).toStringAsFixed(2)}π)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFC026D3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Canvas Cerchio Goniometrico con Touch/Drag Diretto
          LayoutBuilder(
            builder: (context, constraints) {
              final canvasSize = Size(constraints.maxWidth, 260);
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
                      height: 260,
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
                  value: _cosVal.abs() < 0.005
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
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 16,
                  color: Color(0xFF16A34A),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'sin²(θ) + cos²(θ) = ${(_sinVal * _sinVal + _cosVal * _cosVal).toStringAsFixed(3)} = 1 (Identità Fondamentale)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
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
              Text(
                'Regola l\'angolo θ (da 0 a 2π):',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '${_angleDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC026D3),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFD946EF),
              inactiveTrackColor: const Color(0xFFF5D0FE),
              thumbColor: const Color(0xFFC026D3),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
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
            color: isSelected ? Colors.white : const Color(0xFF475569),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFFD946EF),
        backgroundColor: const Color(0xFFF1F5F9),
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
    final radius = math.min(size.width, size.height) * 0.36;

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
    final isAsymptote = cosVal.abs() < 0.02;

    if (isAsymptote) {
      // Se siamo nei pressi di π/2 o 3π/2: linea asintotica rossa tratteggiata
      final asympPaint = Paint()
        ..color = const Color(0xFFF43F5E)
        ..strokeWidth = 2.0;
      canvas.drawLine(
        Offset(tanLineX - 1, 10),
        Offset(tanLineX - 1, size.height - 10),
        asympPaint,
      );
      final textP = TextPainter(
        text: const TextSpan(
          text: 'Asintoto (tan θ ➔ ±∞)',
          style: TextStyle(
            color: Color(0xFFF43F5E),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textP.paint(canvas, Offset(center.dx - textP.width / 2, 20));
    } else {
      // Tangente calcolata
      final tanVal = math.tan(angleRad);
      final rawTanY = center.dy - tanVal * radius;

      // Limiti visivi del canvas con margini
      const topMargin = 16.0;
      final bottomMargin = size.height - 16.0;
      final isClampedTop = rawTanY < topMargin;
      final isClampedBottom = rawTanY > bottomMargin;

      final double clampedTanY = rawTanY.clamp(topMargin, bottomMargin);

      // Prolungamento secante dall'origine o attraverso il punto P
      final secantPaint = Paint()
        ..color = const Color(0x55FBBF24)
        ..strokeWidth = 1.2;

      // Disegna la retta passante per l'origine e P fino alla retta x = 1
      canvas.drawLine(
        center,
        Offset(tanLineX, clampedTanY),
        secantPaint,
      );

      // Segmento della tangente lungo la retta x = 1 (da (1,0) a (1, tan θ))
      final tanSegPaint = Paint()
        ..color = const Color(0xFFFBBF24)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(tanLineX, center.dy),
        Offset(tanLineX, clampedTanY),
        tanSegPaint,
      );

      // Se non è clippata, disegna il punto di intersezione T(1, tan θ)
      if (!isClampedTop && !isClampedBottom) {
        // Punto T
        canvas.drawCircle(
          Offset(tanLineX, clampedTanY),
          5.0,
          Paint()..color = const Color(0xFFFBBF24),
        );
        canvas.drawCircle(
          Offset(tanLineX, clampedTanY),
          2.0,
          Paint()..color = Colors.white,
        );
      } else {
        // Disegna freccia direzionale verso ±∞
        final arrowPaint = Paint()
          ..color = const Color(0xFFFBBF24)
          ..style = PaintingStyle.fill;

        final arrowPath = Path();
        if (isClampedTop) {
          // Freccia verso l'alto +∞
          arrowPath.moveTo(tanLineX, topMargin - 4);
          arrowPath.lineTo(tanLineX - 5, topMargin + 6);
          arrowPath.lineTo(tanLineX + 5, topMargin + 6);
          arrowPath.close();

          final tp = TextPainter(
            text: const TextSpan(
              text: 'tan θ ➔ +∞',
              style: TextStyle(
                color: Color(0xFFFBBF24),
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, Offset(tanLineX - tp.width - 6, topMargin - 2));
        } else {
          // Freccia verso il basso -∞
          arrowPath.moveTo(tanLineX, bottomMargin + 4);
          arrowPath.lineTo(tanLineX - 5, bottomMargin - 6);
          arrowPath.lineTo(tanLineX + 5, bottomMargin - 6);
          arrowPath.close();

          final tp = TextPainter(
            text: const TextSpan(
              text: 'tan θ ➔ -∞',
              style: TextStyle(
                color: Color(0xFFFBBF24),
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, Offset(tanLineX - tp.width - 6, bottomMargin - 8));
        }
        canvas.drawPath(arrowPath, arrowPaint);
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

  @override
  bool shouldRepaint(covariant _TrigCirclePainter oldDelegate) {
    return oldDelegate.angleRad != angleRad;
  }
}
