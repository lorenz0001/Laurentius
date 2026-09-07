import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/models/knowledge_node.dart';

/// Widget di simulazione fisica per la cinematica e il moto rettilineo (MRU / MRUA).
/// Visualizza un tracciato stradale con vettura animata a 60/120 fps, ruote rotanti, vettore velocità dinamico,
/// controlli Play/Pausa/Reset, telemetria in tempo reale e collegamento al Corollario di Torricelli.
class KinematicsSimulationWidget extends StatefulWidget {
  final InteractiveData? data;

  const KinematicsSimulationWidget({super.key, this.data});

  @override
  State<KinematicsSimulationWidget> createState() =>
      _KinematicsSimulationWidgetState();
}

class _KinematicsSimulationWidgetState extends State<KinematicsSimulationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  double _v0 = 5.0; // Velocità iniziale (m/s)
  double _a = 2.0; // Accelerazione (m/s²)
  double _elapsedTime = 0.0; // Tempo simulato in secondi
  bool _isPlaying = true;

  double _lastAnimValue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadInitialParameters();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_onTick);

    _lastAnimValue = _animController.value;
    _animController.repeat();
  }

  @override
  void didUpdateWidget(covariant KinematicsSimulationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _loadInitialParameters();
    }
  }

  void _loadInitialParameters() {
    _v0 = 5.0;
    _a = 2.0;
    final params = widget.data?.parameters;
    if (params != null) {
      for (final p in params) {
        if (p.variableName == 'v0' && p.defaultValue != null) {
          _v0 = p.defaultValue!;
        } else if (p.variableName == 'a' && p.defaultValue != null) {
          _a = p.defaultValue!;
        }
      }
    }
  }

  double? _finishedTime;

  void _onTick() {
    double delta = _animController.value - _lastAnimValue;
    if (delta < 0) {
      delta += 1.0;
    }
    _lastAnimValue = _animController.value;
    final dt = delta;

    if (_isPlaying && dt > 0) {
      setState(() {
        _elapsedTime += dt;
        // Traguardo a 100m o arresto per decelerazione: pausa di 1.2s e riavvio fluido
        if (_position >= 100.0 || (_a < 0 && _velocity <= 0 && _elapsedTime > 0.5)) {
          _finishedTime ??= _elapsedTime;
          if (_elapsedTime - _finishedTime! > 1.2) {
            _elapsedTime = 0.0;
            _finishedTime = null;
          }
        } else if (_elapsedTime > 15.0) {
          _elapsedTime = 0.0;
          _finishedTime = null;
        }
      });
    }
  }

  @override
  void dispose() {
    _animController.removeListener(_onTick);
    _animController.dispose();
    super.dispose();
  }

  // Tempo effettivo per il calcolo del moto (la vettura si arresta se v=0 durante frenata con a<0)
  double get _effectiveTime {
    if (_a < 0) {
      final tStop = _v0 / (-_a);
      return math.min(_elapsedTime, tStop);
    }
    return _elapsedTime;
  }

  // Calcolo posizione istantanea x(t) = v0*t + 0.5*a*t^2
  double get _position =>
      (_v0 * _effectiveTime + 0.5 * _a * _effectiveTime * _effectiveTime).clamp(
        0.0,
        1000.0,
      );

  // Calcolo velocità istantanea v(t) = v0 + a*t
  double get _velocity => (_v0 + _a * _effectiveTime).clamp(0.0, 150.0);

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _lastAnimValue = _animController.value;
        _animController.repeat();
      } else {
        _animController.stop();
      }
    });
  }

  void _resetSimulation() {
    setState(() {
      _elapsedTime = 0.0;
      _finishedTime = null;
      _lastAnimValue = _animController.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final position = _position;
    final velocity = _velocity;

    final v0Param = widget.data?.parameters
        ?.where((p) => p.variableName == 'v0')
        .firstOrNull;
    final aParam = widget.data?.parameters
        ?.where((p) => p.variableName == 'a')
        .firstOrNull;
    final v0Unit = v0Param?.unit ?? 'm/s';
    final aUnit = aParam?.unit ?? 'm/s²';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
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
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: Color(0xFFD97706),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Simulatore Cinematica (MRUA)',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Moto rettilineo, vettori velocità e spazio percorso',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              // Controlli Play/Pausa e Reset
              IconButton(
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                ),
                color: const Color(0xFF2563EB),
                iconSize: 28,
                tooltip: _isPlaying ? 'Pausa' : 'Avvia',
                onPressed: _togglePlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.replay_rounded),
                color: const Color(0xFF64748B),
                iconSize: 22,
                tooltip: 'Ricomincia da t = 0s',
                onPressed: _resetSimulation,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Canvas Strada e Vettura
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                painter: _RoadPainter(
                  position: position,
                  velocity: velocity,
                  elapsedTime: _elapsedTime,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Telemetria in Tempo Reale
          Row(
            children: [
              Expanded(
                child: _buildTelemetryPill(
                  title: 'SPAZIO (x)',
                  value: '${position.toStringAsFixed(1)} m',
                  formula: 'x = v₀t + ½at²',
                  color: const Color(0xFF0284C7),
                  icon: Icons.straighten_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTelemetryPill(
                  title: 'VELOCITÀ (v)',
                  value: (v0Unit.trim().isNotEmpty)
                      ? '${velocity.toStringAsFixed(1)} ${v0Unit.trim()}'.trim()
                      : velocity.toStringAsFixed(1),
                  formula: 'v = v₀ + at',
                  color: const Color(0xFF16A34A),
                  icon: Icons.speed_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTelemetryPill(
                  title: 'TEMPO (t)',
                  value: '${_elapsedTime.toStringAsFixed(1)} s',
                  formula: 'Δt reale',
                  color: const Color(0xFF7C3AED),
                  icon: Icons.timer_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Slider v0 e a
          const Text(
            'PARAMETRI CINEMATICI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),

          _buildSlider(
            label: v0Param?.label ?? 'Velocità Iniziale (v₀)',
            value: _v0,
            unit: v0Unit,
            min: v0Param?.minValue ?? 0.0,
            max: v0Param?.maxValue ?? 30.0,
            divisions: (v0Param?.stepSize != null &&
                    v0Param!.stepSize! > 0 &&
                    (v0Param.maxValue ?? 30.0) > (v0Param.minValue ?? 0.0))
                ? (((v0Param.maxValue ?? 30.0) - (v0Param.minValue ?? 0.0)) /
                        v0Param.stepSize!)
                    .round()
                : 30,
            color: const Color(0xFF0284C7),
            onChanged: (val) {
              setState(() {
                _v0 = val;
              });
            },
          ),
          const SizedBox(height: 8),

          _buildSlider(
            label: aParam?.label ?? 'Accelerazione (a)',
            value: _a,
            unit: aUnit,
            min: aParam?.minValue ?? -5.0,
            max: aParam?.maxValue ?? 10.0,
            divisions: (aParam?.stepSize != null &&
                    aParam!.stepSize! > 0 &&
                    (aParam.maxValue ?? 10.0) > (aParam.minValue ?? -5.0))
                ? (((aParam.maxValue ?? 10.0) - (aParam.minValue ?? -5.0)) /
                        aParam.stepSize!)
                    .round()
                : 30,
            color: const Color(0xFF16A34A),
            onChanged: (val) {
              setState(() {
                _a = val;
              });
            },
          ),
          const SizedBox(height: 12),

          // Card Collegamento Corollario di Torricelli
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFD97706),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Corollario di Torricelli: eliminando il tempo t dal sistema ottieni '
                    'v² = v₀² + 2a·Δx. Puoi calcolare la velocità raggiunta dalla vettura '
                    'in funzione unicamente dello spazio percorso!',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryPill({
    required String title,
    required String value,
    required String formula,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.4,
            ),
          ),
          Text(
            formula,
            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required String unit,
    required double min,
    required double max,
    required int divisions,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                unit.trim().isNotEmpty
                    ? '${value.toStringAsFixed(1)} ${unit.trim()}'.trim()
                    : value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.15),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter per il rendering grafico della corsia stradale, della vettura animata e del vettore velocità
class _RoadPainter extends CustomPainter {
  final double position;
  final double velocity;
  final double elapsedTime;

  _RoadPainter({
    required this.position,
    required this.velocity,
    required this.elapsedTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final roadY = h * 0.65;
    const roadHeight = 36.0;

    // 1. Disegno dell'asfalto
    final asphaltPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawRect(Rect.fromLTWH(0, roadY, w, roadHeight), asphaltPaint);

    // 2. Linee di demarcazione tratteggiate
    final dashPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 2.0;

    const dashWidth = 14.0;
    const dashSpace = 12.0;
    double startX = 0.0;
    while (startX < w) {
      canvas.drawLine(
        Offset(startX, roadY + roadHeight / 2),
        Offset(startX + dashWidth, roadY + roadHeight / 2),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }

    // 3. Indicatori metrici lungo la corsia (0m, 25m, 50m, 100m)
    _drawDistanceMarker(canvas, 20.0, roadY + roadHeight + 4, '0m');
    _drawDistanceMarker(canvas, w * 0.35, roadY + roadHeight + 4, '25m');
    _drawDistanceMarker(canvas, w * 0.65, roadY + roadHeight + 4, '50m');
    _drawDistanceMarker(canvas, w - 40.0, roadY + roadHeight + 4, '100m');

    // Linea del traguardo a scacchi (Checkered finish line a 100m)
    final finishX = w - 36.0;
    const checkSize = 4.0;
    for (double cy = roadY; cy < roadY + roadHeight; cy += checkSize) {
      for (double cx = finishX; cx < finishX + 8.0; cx += checkSize) {
        final isWhite = ((cx - finishX) / checkSize).floor() % 2 ==
            ((cy - roadY) / checkSize).floor() % 2;
        canvas.drawRect(
          Rect.fromLTWH(cx, cy, checkSize, checkSize),
          Paint()..color = isWhite ? Colors.white : Colors.black,
        );
      }
    }

    // 4. Posizione normalizzata della vettura su schermo (0 - 100m) senza salti/teletrasporti
    final normPos = (position.clamp(0.0, 100.0)) / 100.0;
    final carX = 20.0 + normPos * (w - 74.0);
    final carY = roadY - 14.0;

    // 5. Disegno della vettura
    _drawCar(canvas, Offset(carX, carY), velocity, elapsedTime);

    // 6. Disegno del Vettore Velocità (Freccia verde dinamica)
    _drawVelocityVector(canvas, Offset(carX + 28, carY + 8), velocity);

    // Se il traguardo è stato raggiunto, mostra banner di arrivo
    if (position >= 100.0) {
      final finishBanner = TextPainter(
        text: const TextSpan(
          text: '🏁 TRAGUARDO 100m',
          style: TextStyle(
            fontSize: 10,
            color: Color(0xFFFBBF24),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      finishBanner.paint(canvas, Offset(w - finishBanner.width - 16, roadY - 24));
    }
  }

  void _drawDistanceMarker(Canvas canvas, double x, double y, String text) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF64748B),
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x, y));
  }

  void _drawCar(Canvas canvas, Offset pos, double v, double t) {
    final x = pos.dx;
    final y = pos.dy;

    // Scia luminosa / motion trail se la velocità è sostenuta
    if (v > 10.0) {
      final trailPaint = Paint()
        ..shader = LinearGradient(
          colors: [const Color(0x6638BDF8), Colors.transparent],
        ).createShader(Rect.fromLTWH(x - 30, y + 4, 30, 10));
      canvas.drawRect(Rect.fromLTWH(x - 30, y + 4, 30, 10), trailPaint);
    }

    // Corpo vettura (aerodinamico, colore azzurro elettrico)
    final bodyPaint = Paint()..color = const Color(0xFF0284C7);
    final bodyPath = Path()
      ..moveTo(x - 14, y + 14)
      ..lineTo(x + 22, y + 14)
      ..lineTo(x + 26, y + 8)
      ..lineTo(x + 14, y + 2)
      ..lineTo(x - 4, y + 2)
      ..lineTo(x - 14, y + 8)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Parabrezza / finestrini
    final windowPaint = Paint()..color = const Color(0xFFE0F2FE);
    final windowPath = Path()
      ..moveTo(x - 2, y + 4)
      ..lineTo(x + 12, y + 4)
      ..lineTo(x + 18, y + 8)
      ..lineTo(x - 4, y + 8)
      ..close();
    canvas.drawPath(windowPath, windowPaint);

    // Faro anteriore
    final lightPaint = Paint()..color = const Color(0xFFFDE047);
    canvas.drawCircle(Offset(x + 24, y + 10), 2.5, lightPaint);

    // Ruote rotanti
    final wheelAngle = (t * v * 0.8) % (2 * math.pi);
    _drawWheel(canvas, Offset(x - 6, y + 16), wheelAngle);
    _drawWheel(canvas, Offset(x + 16, y + 16), wheelAngle);
  }

  void _drawWheel(Canvas canvas, Offset center, double angle) {
    // Pneumatico
    final tirePaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(center, 5.0, tirePaint);

    // Cerchione
    final rimPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, 3.5, rimPaint);

    // Raggio ruota per evidenziare la rotazione
    final spokePaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1.0;
    canvas.drawLine(
      center,
      Offset(
        center.dx + 3.5 * math.cos(angle),
        center.dy + 3.5 * math.sin(angle),
      ),
      spokePaint,
    );
  }

  void _drawVelocityVector(Canvas canvas, Offset origin, double v) {
    if (v < 0.5) return;

    // Lunghezza proporzionale a v
    final arrowLength = (v * 1.6).clamp(12.0, 50.0);

    final arrowPaint = Paint()
      ..color =
          const Color(0xFF22C55E) // Verde vivace per la velocità
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final end = Offset(origin.dx + arrowLength, origin.dy);
    canvas.drawLine(origin, end, arrowPaint);

    // Punta della freccia
    final tipPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(end.dx - 6, end.dy - 4)
      ..lineTo(end.dx - 6, end.dy + 4)
      ..close();
    canvas.drawPath(tipPath, Paint()..color = const Color(0xFF22C55E));

    // Etichetta "v"
    final tp = TextPainter(
      text: const TextSpan(
        text: 'v',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Color(0xFF22C55E),
          fontStyle: FontStyle.italic,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(end.dx + 4, end.dy - 6));
  }

  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.velocity != velocity ||
        oldDelegate.elapsedTime != elapsedTime;
  }
}
