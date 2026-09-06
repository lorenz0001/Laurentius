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
  bool _isAutoTransforming = true; // Attivo di default per mostrare la deformazione geometrica

  late final AnimationController _triangleAnimController;

  @override
  void initState() {
    super.initState();
    _triangleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(_onTriangleAnimTick);

    _triangleAnimController.repeat(reverse: true);
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
          // Intestazione
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.change_history_rounded,
                      color: Color(0xFFE11D48),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Geometria del Triangolo & Carnot',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isAutoTransforming
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_fill_rounded,
                    ),
                    color: const Color(0xFFE11D48),
                    iconSize: 26,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: _isAutoTransforming
                        ? 'Pausa deformazione'
                        : 'Anima trasformazione triangolo',
                    onPressed: _toggleAutoTransform,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _isRightTriangle
                          ? const Color(0xFFEFF6FF)
                          : const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isRightTriangle
                            ? const Color(0xFFBFDBFE)
                            : const Color(0xFFFECDD3),
                      ),
                    ),
                    child: Text(
                      _isRightTriangle ? 'Pitagora (γ = 90°)' : 'Carnot Generico',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _isRightTriangle
                            ? const Color(0xFF1D4ED8)
                            : const Color(0xFFE11D48),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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

          // Riquadro Corollario / Verifica Formula
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isRightTriangle
                          ? Icons.check_circle_rounded
                          : Icons.calculate_rounded,
                      size: 16,
                      color: _isRightTriangle
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF475569),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _isRightTriangle
                            ? 'c² = a² + b² = ${_sideA.toStringAsFixed(1)}² + ${_sideB.toStringAsFixed(1)}² = ${_sideCSquared.toStringAsFixed(2)}'
                            : 'c² = a² + b² - 2ab·cos(${_angleGammaDeg.toStringAsFixed(0)}°) = ${_sideCSquared.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                if (_isRightTriangle)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Pitagora è il corollario di Carnot quando cos(90°) = 0',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Slider Angolo γ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Angolo γ compreso: ${_angleGammaDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
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
            activeColor: const Color(0xFFE11D48),
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
                    Text(
                      'Lato a: ${_sideA.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: _sideA,
                      min: 1.5,
                      max: 6.0,
                      activeColor: const Color(0xFF38BDF8),
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
                    Text(
                      'Lato b: ${_sideB.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: _sideB,
                      min: 1.5,
                      max: 6.0,
                      activeColor: const Color(0xFF4ADE80),
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
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
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
    // Vertice C (angolo gamma) posto in basso al centro
    final originC = Offset(size.width * 0.35, size.height * 0.75);
    final scale = size.height * 0.11;

    // Vertice A lungo l'asse orizzontale (lato b)
    final vertexA = Offset(originC.dx + sideB * scale, originC.dy);

    // Vertice B inclinato di gamma rispetto all'orizzontale (lato a)
    final vertexB = Offset(
      originC.dx + sideA * scale * math.cos(-gammaRad),
      originC.dy + sideA * scale * math.sin(-gammaRad),
    );

    // Triangolo riempimento
    final trianglePath = Path()
      ..moveTo(originC.dx, originC.dy)
      ..lineTo(vertexA.dx, vertexA.dy)
      ..lineTo(vertexB.dx, vertexB.dy)
      ..close();

    final fillPaint = Paint()
      ..color = const Color(0x33E11D48)
      ..style = PaintingStyle.fill;
    canvas.drawPath(trianglePath, fillPaint);

    // Bordi colorati per ciascun lato
    // Lato b (da C ad A): verde
    canvas.drawLine(
      originC,
      vertexA,
      Paint()
        ..color = const Color(0xFF4ADE80)
        ..strokeWidth = 3.5,
    );

    // Lato a (da C a B): azzurro
    canvas.drawLine(
      originC,
      vertexB,
      Paint()
        ..color = const Color(0xFF38BDF8)
        ..strokeWidth = 3.5,
    );

    // Lato c (da B ad A): fucsia
    canvas.drawLine(
      vertexB,
      vertexA,
      Paint()
        ..color = const Color(0xFFF43F5E)
        ..strokeWidth = 3.5,
    );

    // Arco per l'angolo gamma in C
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

    // Vertici
    final vertexPaint = Paint()..color = Colors.white;
    canvas.drawCircle(originC, 4, vertexPaint);
    canvas.drawCircle(vertexA, 4, vertexPaint);
    canvas.drawCircle(vertexB, 4, vertexPaint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.sideA != sideA ||
        oldDelegate.sideB != sideB ||
        oldDelegate.gammaRad != gammaRad;
  }
}
