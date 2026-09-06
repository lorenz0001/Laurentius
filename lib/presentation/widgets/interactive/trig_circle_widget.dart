import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../domain/models/knowledge_node.dart';

/// Widget interattivo a 60fps per l'esplorazione della Circonferenza Goniometrica.
/// Mostra in tempo reale il raggio vettore, il punto P(cos θ, sin θ), le proiezioni
/// ortogonali di seno (verde), coseno (blu), la retta tangente (ambra) e la verifica
/// dell'identità fondamentale sin²θ + cos²θ = 1.
class TrigCircleWidget extends StatefulWidget {
  final InteractiveData? data;

  const TrigCircleWidget({super.key, this.data});

  @override
  State<TrigCircleWidget> createState() => _TrigCircleWidgetState();
}

class _TrigCircleWidgetState extends State<TrigCircleWidget> {
  double _angleRad = math.pi / 4; // 45° default

  double get _angleDeg => _angleRad * 180 / math.pi;
  double get _cosVal => math.cos(_angleRad);
  double get _sinVal => math.sin(_angleRad);
  double get _tanVal => math.tan(_angleRad);

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
          // Header
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          const SizedBox(height: 16),

          // Canvas Cerchio Goniometrico
          SizedBox(
            height: 250,
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
                  value: _cosVal.abs() < 0.001 ? '∞' : _tanVal.toStringAsFixed(3),
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
                const Icon(Icons.check_circle_outline_rounded, size: 16, color: Color(0xFF16A34A)),
                const SizedBox(width: 6),
                Text(
                  'sin²(θ) + cos²(θ) = ${(_sinVal * _sinVal + _cosVal * _cosVal).toStringAsFixed(3)} = 1 (Identità Fondamentale)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Slider per l'angolo θ
          Text(
            'Regola l\'angolo θ (da 0 a 2π):',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
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
                setState(() {
                  _angleRad = val;
                });
              },
            ),
          ),

          // Scorciatoie per angoli notevoli
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAngleChip('0°', 0),
                _buildAngleChip('30° (π/6)', math.pi / 6),
                _buildAngleChip('45° (π/4)', math.pi / 4),
                _buildAngleChip('60° (π/3)', math.pi / 3),
                _buildAngleChip('90° (π/2)', math.pi / 2),
                _buildAngleChip('180° (π)', math.pi),
                _buildAngleChip('270° (3π/2)', 3 * math.pi / 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({required String label, required String value, required Color color}) {
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
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }

  Widget _buildAngleChip(String label, double rad) {
    final isSelected = (_angleRad - rad).abs() < 0.05;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : const Color(0xFF475569))),
        selected: isSelected,
        selectedColor: const Color(0xFFD946EF),
        backgroundColor: const Color(0xFFF1F5F9),
        onSelected: (_) {
          setState(() {
            _angleRad = rad;
          });
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
    final radius = math.min(size.width, size.height) * 0.38;

    final axisPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.0;

    final circlePaint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Assi cartesiani
    canvas.drawLine(Offset(10, center.dy), Offset(size.width - 10, center.dy), axisPaint);
    canvas.drawLine(Offset(center.dx, 10), Offset(center.dx, size.height - 10), axisPaint);

    // Cerchio unitario
    canvas.drawCircle(center, radius, circlePaint);

    // Coordinate punto P
    final cosVal = math.cos(angleRad);
    final sinVal = math.sin(angleRad);
    final pPoint = Offset(center.dx + cosVal * radius, center.dy - sinVal * radius);
    final cosPoint = Offset(center.dx + cosVal * radius, center.dy);

    // Vettore coseno (orizzontale azzurro)
    final cosPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 3.0;
    canvas.drawLine(center, cosPoint, cosPaint);

    // Vettore seno (verticale verde)
    final sinPaint = Paint()
      ..color = const Color(0xFF4ADE80)
      ..strokeWidth = 3.0;
    canvas.drawLine(cosPoint, pPoint, sinPaint);

    // Raggio vettore unitario (bianco/fucsia)
    final radiusPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;
    canvas.drawLine(center, pPoint, radiusPaint);

    // Tratteggio raggio fino alla tangente
    final tanPaint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..strokeWidth = 2.5;

    // Retta tangente x = 1
    final tanLineX = center.dx + radius;
    final tanVal = math.tan(angleRad);
    final tanY = center.dy - tanVal * radius;

    // Disegna la tangente solo se non spara fuori scala
    if (tanY >= 0 && tanY <= size.height && cosVal > 0) {
      canvas.drawLine(Offset(tanLineX, center.dy), Offset(tanLineX, tanY), tanPaint);
      canvas.drawLine(center, Offset(tanLineX, tanY), Paint()..color = const Color(0x66FBBF24)..strokeWidth = 1.0);
    }

    // Arco angolo θ
    final arcPaint = Paint()
      ..color = const Color(0xFFE879F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 24),
      0,
      -angleRad,
      false,
      arcPaint,
    );

    // Punto P(cos θ, sin θ)
    final pointPaint = Paint()..color = const Color(0xFFF43F5E);
    canvas.drawCircle(pPoint, 5.0, pointPaint);
    canvas.drawCircle(pPoint, 2.0, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _TrigCirclePainter oldDelegate) {
    return oldDelegate.angleRad != angleRad;
  }
}
