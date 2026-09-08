import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/models/knowledge_node.dart';

/// Widget interattivo per la Geometria del Triangolo e Teoremi di Pitagora / Carnot.
/// Permette di variare i lati a, b e l'angolo compreso γ.
/// Dimostra visivamente che quando γ = 90°, la formula di Carnot collassa
/// esattamente nel Teorema di Pitagora (c² = a² + b²).
class TriangleSolverWidget extends StatefulWidget {
  final InteractiveData? data;

  const TriangleSolverWidget({super.key, this.data});

  @override
  State<TriangleSolverWidget> createState() => _TriangleSolverWidgetState();
}

class _TriangleSolverWidgetState extends State<TriangleSolverWidget>
    with SingleTickerProviderStateMixin {
  double _sideA = 3.0;
  double _sideB = 4.0;
  double _angleGammaDeg = 90.0;
  bool _isAutoTransforming = false;

  late final AnimationController _triangleAnimController;

  @override
  void initState() {
    super.initState();
    _triangleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(_onTriangleAnimTick);
  }

  void _onTriangleAnimTick() {
    if (_isAutoTransforming) {
      setState(() {
        // Oscilla fluidamente tra 40° e 135°, passando per 90° (Pitagora)
        final t = Curves.easeInOutCubic.transform(_triangleAnimController.value);
        _angleGammaDeg = 40.0 + t * 95.0;
      });
    }
  }

  void _toggleAutoTransform() {
    setState(() {
      _isAutoTransforming = !_isAutoTransforming;
      if (_isAutoTransforming) {
        _triangleAnimController.repeat(reverse: true);
      } else {
        _triangleAnimController.stop();
      }
    });
  }

  @override
  void dispose() {
    _triangleAnimController.removeListener(_onTriangleAnimTick);
    _triangleAnimController.dispose();
    super.dispose();
  }

  double get _gammaRad => _angleGammaDeg * math.pi / 180.0;

  // Teorema del Coseno (Carnot): c² = a² + b² - 2ab cos(γ)
  double get _sideCSquared =>
      _sideA * _sideA +
      _sideB * _sideB -
      2 * _sideA * _sideB * math.cos(_gammaRad);

  double get _sideC => math.sqrt(math.max(0.001, _sideCSquared));

  // Area del triangolo: A = 0.5 * a * b * sin(γ)
  double get _area => 0.5 * _sideA * _sideB * math.sin(_gammaRad);

  bool get _isRightTriangle => (_angleGammaDeg - 90.0).abs() < 1.0;

  // Altezza h del triangolo rispetto alla base b: h = a * sin(γ)
  double get _altitudeH => _sideA * math.sin(_gammaRad);

  // Proiezione ortogonale p del lato a sulla base b: p = a * cos(γ)
  double get _projectionP => _sideA * math.cos(_gammaRad);

  // Base residua del triangolo rettangolo con ipotenusa c: |b - a·cos(γ)|
  double get _baseMinusP => (_sideB - _projectionP).abs();

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
          // Intestazione
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
                    Icon(
                      Icons.change_history_rounded,
                      color: Color(0xFFFB7185),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Geometria del Triangolo & Carnot',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF8FAFC),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _isAutoTransforming
                      ? Icons.pause_circle_rounded
                      : Icons.play_circle_fill_rounded,
                ),
                color: const Color(0xFFFB7185),
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: _isAutoTransforming
                    ? 'Pausa deformazione'
                    : 'Anima trasformazione triangolo',
                onPressed: _toggleAutoTransform,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _isRightTriangle
                    ? const Color(0xFF1E293B)
                    : const Color(0xFF3B1219),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isRightTriangle
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFFBE123C),
                ),
              ),
              child: Text(
                _isRightTriangle ? 'Pitagora (γ = 90°)' : 'Carnot Generico',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _isRightTriangle
                      ? const Color(0xFF60A5FA)
                      : const Color(0xFFFB7185),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Canvas Triangolo
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFF0F172A),
                child: CustomPaint(
                  painter: _TrianglePainter(
                    sideA: _sideA,
                    sideB: _sideB,
                    gammaRad: _gammaRad,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Telemetria Lati & Area
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  label: 'Lato a',
                  value: _sideA.toStringAsFixed(1),
                  color: const Color(0xFF38BDF8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  label: 'Lato b',
                  value: _sideB.toStringAsFixed(1),
                  color: const Color(0xFF4ADE80),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  label: 'Terzo Lato c',
                  value: _sideC.toStringAsFixed(2),
                  color: const Color(0xFFF43F5E),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  label: 'Area',
                  value: _area.toStringAsFixed(2),
                  color: const Color(0xFFFBBF24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Riquadro Corollario / Verifica Formula & Dimostrazione Geometrica
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF14171A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2D3238)),
            ),
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isRightTriangle
                            ? Icons.check_circle_rounded
                            : Icons.calculate_rounded,
                        size: 16,
                        color: _isRightTriangle
                            ? const Color(0xFF4ADE80)
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isRightTriangle
                            ? 'c² = a² + b² = ${_sideA.toStringAsFixed(1)}² + ${_sideB.toStringAsFixed(1)}² = ${_sideCSquared.toStringAsFixed(2)}'
                            : 'c² = a² + b² - 2ab·cos(${_angleGammaDeg.toStringAsFixed(0)}°) = ${_sideCSquared.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF8FAFC),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Dimostrazione geometrica di Carnot: scomposizione con altezza e proiezione
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Dimostrazione via Pitagora su △BHA:  h = a·sin(γ) = ${_altitudeH.toStringAsFixed(2)},  p = a·cos(γ) = ${_projectionP.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF93C5FD),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'c² = h² + (b - a·cos γ)² = ${_altitudeH.toStringAsFixed(2)}² + ${_baseMinusP.toStringAsFixed(2)}² = ${_sideCSquared.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFB7185),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (_isRightTriangle)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Pitagora è il corollario di Carnot quando cos(90°) = 0',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF4ADE80),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Slider Angolo γ
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                'Angolo γ compreso: ${_angleGammaDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_isAutoTransforming) {
                    setState(() {
                      _isAutoTransforming = false;
                      _triangleAnimController.stop();
                    });
                  }
                  setState(() {
                    _angleGammaDeg = 90.0;
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  visualDensity: VisualDensity.compact,
                  foregroundColor: const Color(0xFFFB7185),
                ),
                child: const Text(
                  'Imposta 90° (Pitagora)',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          Slider(
            value: _angleGammaDeg.clamp(15.0, 160.0),
            min: 15.0,
            max: 160.0,
            divisions: 145,
            activeColor: const Color(0xFFFB7185),
            inactiveColor: const Color(0xFF334155),
            onChanged: (val) {
              if (_isAutoTransforming) {
                setState(() {
                  _isAutoTransforming = false;
                  _triangleAnimController.stop();
                });
              }
              setState(() {
                _angleGammaDeg = val;
              });
            },
          ),

          // Slider Lati a e b
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Lato a: ${_sideA.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    Slider(
                      value: _sideA,
                      min: 1.5,
                      max: 6.0,
                      activeColor: const Color(0xFF38BDF8),
                      inactiveColor: const Color(0xFF334155),
                      onChanged: (val) => setState(() => _sideA = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Lato b: ${_sideB.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    Slider(
                      value: _sideB,
                      min: 1.5,
                      max: 6.0,
                      activeColor: const Color(0xFF4ADE80),
                      inactiveColor: const Color(0xFF334155),
                      onChanged: (val) => setState(() => _sideB = val),
                    ),
                  ],
                ),
              ),
            ],
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
                fontSize: 10,
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
}

class _TrianglePainter extends CustomPainter {
  final double sideA;
  final double sideB;
  final double gammaRad;

  _TrianglePainter({
    required this.sideA,
    required this.sideB,
    required this.gammaRad,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Vertice C (angolo gamma) posto in basso al centro-sinistra
    final originC = Offset(size.width * 0.35, size.height * 0.70);
    final scale = size.height * 0.11;

    // Vertice A lungo l'asse orizzontale (lato b)
    final vertexA = Offset(originC.dx + sideB * scale, originC.dy);

    // Vertice B inclinato di gamma rispetto all'orizzontale (lato a)
    final vertexB = Offset(
      originC.dx + sideA * scale * math.cos(-gammaRad),
      originC.dy + sideA * scale * math.sin(-gammaRad),
    );

    // Piede dell'altezza H perpendicolare alla retta contenente la base CA
    final footH = Offset(vertexB.dx, originC.dy);

    // 1. Riempimento del triangolo principale △ABC
    final trianglePath = Path()
      ..moveTo(originC.dx, originC.dy)
      ..lineTo(vertexA.dx, vertexA.dy)
      ..lineTo(vertexB.dx, vertexB.dy)
      ..close();

    final fillPaint = Paint()
      ..color = const Color(0x22E11D48)
      ..style = PaintingStyle.fill;
    canvas.drawPath(trianglePath, fillPaint);

    // 2. Prolungamento tratteggiato della base se γ > 90° (H cade a sinistra di C)
    if (footH.dx < originC.dx) {
      final extPaint = Paint()
        ..color = const Color(0x664ADE80)
        ..strokeWidth = 2.0;
      _drawDashedLine(canvas, originC, footH, extPaint);
    }

    // 3. Altezza tratteggiata BH
    final altitudePaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 2.0;
    _drawDashedLine(canvas, vertexB, footH, altitudePaint);

    // 4. Marcatore angolo retto a 90° nel punto H
    const markerSize = 8.0;
    final isRightOfH = vertexA.dx >= footH.dx;
    final squarePath = Path()
      ..moveTo(footH.dx, footH.dy - markerSize)
      ..lineTo(
        footH.dx + (isRightOfH ? markerSize : -markerSize),
        footH.dy - markerSize,
      )
      ..lineTo(
        footH.dx + (isRightOfH ? markerSize : -markerSize),
        footH.dy,
      );
    canvas.drawPath(
      squarePath,
      Paint()
        ..color = const Color(0xFFF59E0B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawCircle(
      Offset(
        footH.dx + (isRightOfH ? markerSize / 2 : -markerSize / 2),
        footH.dy - markerSize / 2,
      ),
      1.2,
      Paint()..color = const Color(0xFFF59E0B),
    );

    // 5. Bordi del triangolo △ABC
    // Lato b (da C ad A): verde
    canvas.drawLine(
      originC,
      vertexA,
      Paint()
        ..color = const Color(0xFF4ADE80)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // Lato a (da C a B): azzurro
    canvas.drawLine(
      originC,
      vertexB,
      Paint()
        ..color = const Color(0xFF38BDF8)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // Lato c (da B ad A): fucsia
    canvas.drawLine(
      vertexB,
      vertexA,
      Paint()
        ..color = const Color(0xFFF43F5E)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // 6. Arco per l'angolo gamma in C
    final arcPaint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawArc(
      Rect.fromCircle(center: originC, radius: 20),
      0,
      -gammaRad,
      false,
      arcPaint,
    );

    // 7. Evidenziazione proiezione p = a·cos(γ) lungo la base
    if ((originC.dx - footH.dx).abs() > 4.0) {
      final pLinePaint = Paint()
        ..color = const Color(0xFF38BDF8)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(originC.dx, originC.dy + 8),
        Offset(footH.dx, footH.dy + 8),
        pLinePaint,
      );
      final pMidX = (originC.dx + footH.dx) / 2 - 18;
      _drawLabel(
        canvas,
        'p = a·cos γ',
        Offset(pMidX, originC.dy + 11),
        const Color(0xFF38BDF8),
        fontSize: 9,
      );
    }

    // 8. Etichette e vertici
    // Vertici
    final vertexPaint = Paint()..color = Colors.white;
    canvas.drawCircle(originC, 4, vertexPaint);
    canvas.drawCircle(vertexA, 4, vertexPaint);
    canvas.drawCircle(vertexB, 4, vertexPaint);

    // Vertice H
    canvas.drawCircle(
      footH,
      3.5,
      Paint()..color = const Color(0xFFF59E0B),
    );

    // Etichette vertici
    _drawLabel(canvas, 'C', Offset(originC.dx - 14, originC.dy + 2), const Color(0xFFFBBF24));
    _drawLabel(canvas, 'A', Offset(vertexA.dx + 6, vertexA.dy - 4), const Color(0xFF4ADE80));
    _drawLabel(canvas, 'B', Offset(vertexB.dx - 6, vertexB.dy - 16), const Color(0xFF38BDF8));
    _drawLabel(canvas, 'H', Offset(footH.dx - 4, footH.dy + 4), const Color(0xFFF59E0B));

    // Etichetta altezza h = a·sin(γ)
    final altLabelX = vertexB.dx < originC.dx ? vertexB.dx - 54 : vertexB.dx + 6;
    final altLabelY = (vertexB.dy + footH.dy) / 2 - 6;
    _drawLabel(
      canvas,
      'h = a·sin γ',
      Offset(altLabelX, altLabelY),
      const Color(0xFFF59E0B),
      fontSize: 9,
      fontWeight: FontWeight.w700,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 3.0;
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

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset offset,
    Color color, {
    double fontSize = 10,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.sideA != sideA ||
        oldDelegate.sideB != sideB ||
        oldDelegate.gammaRad != gammaRad;
  }
}
