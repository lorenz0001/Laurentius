import 'package:flutter/material.dart';

import '../../../domain/models/knowledge_node.dart';

/// Widget di simulazione interattiva fisica della Legge di Ohm e conduzione elettrica.
/// Visualizza un circuito chiuso animato con flusso continuo di elettroni (velocità proporzionale a I = V/R),
/// surriscaldamento visivo del resistore (effetto Joule) e slider reattivi per Tensione e Resistenza.
class OhmCircuitSimulationWidget extends StatefulWidget {
  final InteractiveData? data;

  const OhmCircuitSimulationWidget({super.key, this.data});

  @override
  State<OhmCircuitSimulationWidget> createState() =>
      _OhmCircuitSimulationWidgetState();
}

class _OhmCircuitSimulationWidgetState extends State<OhmCircuitSimulationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  // Parametri di stato del circuito
  double _voltage = 12.0; // Volt
  double _resistance = 6.0; // Ohm
  bool _showElectronFlow = true; // True = moto reale elettroni (- a +), False = corrente convenzionale (+ a -)
  bool _isPlaying = false;

  // Accumulatore di fase per variare la velocità in modo continuo e fluido
  double _phase = 0.0;
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
  }

  @override
  void didUpdateWidget(covariant OhmCircuitSimulationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _loadInitialParameters();
    }
  }

  void _loadInitialParameters() {
    _voltage = 12.0;
    _resistance = 6.0;
    final params = widget.data?.parameters;
    if (params != null) {
      for (final p in params) {
        if (p.variableName == 'V' && p.defaultValue != null) {
          _voltage = p.defaultValue!;
        } else if (p.variableName == 'R' && p.defaultValue != null) {
          _resistance = p.defaultValue!;
        }
      }
    }
  }

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

  void _onTick() {
    double delta = _animController.value - _lastAnimValue;
    if (delta < 0) {
      delta += 1.0;
    }
    _lastAnimValue = _animController.value;
    final dt = delta;

    if (_isPlaying && dt > 0) {
      // Calcolo corrente istantanea
      final current = _current;

      // La velocità di deriva degli elettroni è proporzionale all'intensità di corrente
      // Base speed factor regolato per fluidità visiva a 60/120fps
      final speed = (current * 0.12).clamp(0.01, 1.8);

      setState(() {
        _phase = (_phase + speed * dt) % 1.0;
      });
    }
  }

  @override
  void dispose() {
    _animController.removeListener(_onTick);
    _animController.dispose();
    super.dispose();
  }

  double get _current => _resistance > 0 ? (_voltage / _resistance) : 0.0;
  double get _power => _voltage * _current;

  @override
  Widget build(BuildContext context) {
    final current = _current;
    final power = _power;

    final vParam = widget.data?.parameters
        ?.where((p) => p.variableName == 'V')
        .firstOrNull;
    final rParam = widget.data?.parameters
        ?.where((p) => p.variableName == 'R')
        .firstOrNull;
    final vUnit = vParam?.unit ?? 'V';
    final rUnit = rParam?.unit ?? 'Ω';

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
          // Header del Laboratorio
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.electric_bolt_rounded,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Simulazione Dinamica del Circuito',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Flusso di cariche ed effetto termico in tempo reale',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              // Pulsante Play / Pausa animazione elettroni
              IconButton(
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                ),
                color: const Color(0xFF2563EB),
                iconSize: 28,
                tooltip: _isPlaying ? 'Pausa flusso' : 'Avvia flusso',
                onPressed: _togglePlayPause,
              ),
              const SizedBox(width: 4),
              // Switch per alternare Flusso Elettroni e Flusso Convenzionale
              Tooltip(
                message: _showElectronFlow
                    ? 'Modalità: Flusso reale degli elettroni (da - a +)'
                    : 'Modalità: Verso convenzionale della corrente (da + a -)',
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    backgroundColor: const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _showElectronFlow = !_showElectronFlow;
                    });
                  },
                  icon: Icon(
                    _showElectronFlow
                        ? Icons.scatter_plot_rounded
                        : Icons.swap_horiz_rounded,
                    size: 14,
                    color: const Color(0xFF334155),
                  ),
                  label: Text(
                    _showElectronFlow ? 'e⁻ Reale' : 'I Conv.',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Canvas di Disegno del Circuito Interattivo
          Container(
            height: 230,
            decoration: BoxDecoration(
              color: const Color(
                0xFF090D16,
              ), // Dark canvas ad alto contrasto educational
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                painter: _CircuitPainter(
                  voltage: _voltage,
                  resistance: _resistance,
                  current: current,
                  power: power,
                  phase: _phase,
                  showElectronFlow: _showElectronFlow,
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
                  title: 'CORRENTE (I)',
                  value: '${current.toStringAsFixed(2)} A',
                  formula: 'I = V / R',
                  color: const Color(0xFF0284C7),
                  icon: Icons.speed_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTelemetryBox(
                  title: 'POTENZA (P)',
                  value: '${power.toStringAsFixed(1)} W',
                  formula: 'P = V · I',
                  color: const Color(0xFFEA580C),
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Sliders di Controllo Parametri
          const Text(
            'REGOLAZIONE PARAMETRI FISICI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),

          // Slider Tensione V
          _buildParamSlider(
            label: vParam?.label ?? 'Tensione del Generatore (V)',
            value: _voltage,
            unit: vUnit,
            min: vParam?.minValue ?? 1.0,
            max: vParam?.maxValue ?? 48.0,
            divisions: (vParam?.stepSize != null &&
                    vParam!.stepSize! > 0 &&
                    (vParam.maxValue ?? 48.0) > (vParam.minValue ?? 1.0))
                ? (((vParam.maxValue ?? 48.0) - (vParam.minValue ?? 1.0)) /
                        vParam.stepSize!)
                    .round()
                : 47,
            accentColor: const Color(0xFF2563EB),
            onChanged: (val) {
              setState(() {
                _voltage = val;
              });
            },
          ),

          const SizedBox(height: 10),

          // Slider Resistenza R
          _buildParamSlider(
            label: rParam?.label ?? 'Resistenza del Carico (R)',
            value: _resistance,
            unit: rUnit,
            min: rParam?.minValue ?? 1.0,
            max: rParam?.maxValue ?? 48.0,
            divisions: (rParam?.stepSize != null &&
                    rParam!.stepSize! > 0 &&
                    (rParam.maxValue ?? 48.0) > (rParam.minValue ?? 1.0))
                ? (((rParam.maxValue ?? 48.0) - (rParam.minValue ?? 1.0)) /
                        rParam.stepSize!)
                    .round()
                : 47,
            accentColor: const Color(0xFF7C3AED),
            onChanged: (val) {
              setState(() {
                _resistance = val;
              });
            },
          ),

          const SizedBox(height: 12),

          // Insight pedagogico stile Brilliant
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFFD97706),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'All\'aumentare di V il campo elettrico accelera le cariche (I cresce). '
                    'All\'aumentare di R gli elettroni collidono più frequentemente col reticolo atomico, '
                    'rallentando e dissipando calore per effetto Joule.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Colors.blueGrey.shade800,
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

  Widget _buildTelemetryBox({
    required String title,
    required String value,
    required String formula,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            formula,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParamSlider({
    required String label,
    required double value,
    required String unit,
    required double min,
    required double max,
    required int divisions,
    required Color accentColor,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Text(
                  unit.trim().isNotEmpty
                      ? '${value.toStringAsFixed(0)} ${unit.trim()}'.trim()
                      : value.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: accentColor,
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: accentColor,
              overlayColor: accentColor.withValues(alpha: 0.15),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
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

/// CustomPainter per il disegno vettoriale del circuito, generatore, resistore con gradiente termico
/// e particelle degli elettroni in moto continuo lungo il perimetro.
class _CircuitPainter extends CustomPainter {
  final double voltage;
  final double resistance;
  final double current;
  final double power;
  final double phase; // 0.0 -> 1.0
  final bool showElectronFlow;

  _CircuitPainter({
    required this.voltage,
    required this.resistance,
    required this.current,
    required this.power,
    required this.phase,
    required this.showElectronFlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Coordinate perimetrali del circuito rettangolare con margini proporzionati
    const marginX = 40.0;
    const marginY = 32.0;

    final left = marginX;
    final right = w - marginX;
    final top = marginY;
    final bottom = h - marginY;

    // 1. Tracciamento del percorso del circuito (Wire)
    final wirePaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final circuitPath = Path()
      ..moveTo(left, top)
      ..lineTo(right, top)
      ..lineTo(right, bottom)
      ..lineTo(left, bottom)
      ..close();

    canvas.drawPath(circuitPath, wirePaint);

    // 2. Disegno del Generatore di Tensione (Ramo Sinistro: X = left)
    _drawBattery(canvas, Offset(left, (top + bottom) / 2), voltage);

    // 3. Disegno del Resistore con Surriscaldamento Termico (Ramo Destro: X = right)
    _drawResistor(canvas, Offset(right, (top + bottom) / 2), resistance, power);

    // 4. Disegno dell'Amperometro (Ramo Superiore: Y = top)
    _drawAmmeter(canvas, Offset((left + right) / 2, top), current);

    // 5. Animazione delle particelle (Elettroni o Portatori di Carica)
    _drawParticles(canvas, left, right, top, bottom);
  }

  /// Disegna la batteria / generatore DC
  void _drawBattery(Canvas canvas, Offset center, double v) {
    const batHeight = 44.0;
    final x = center.dx;
    final y = center.dy;

    // Cancella il filo sottostante
    final clearPaint = Paint()..color = const Color(0xFF090D16);
    canvas.drawRect(
      Rect.fromCenter(center: center, width: 20, height: batHeight + 8),
      clearPaint,
    );

    final linePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Piastra Positiva (+) Superiore: Lunga e sottile (colore rosso/ambra)
    linePaint
      ..color = const Color(0xFFEF4444)
      ..strokeWidth = 4.0;
    canvas.drawLine(Offset(x - 16, y - 8), Offset(x + 16, y - 8), linePaint);

    // Piastra Negativa (-) Inferiore: Corta e spessa (colore azzurro/grigio)
    linePaint
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 6.0;
    canvas.drawLine(Offset(x - 9, y + 8), Offset(x + 9, y + 8), linePaint);

    // Simboli + e -
    _drawText(
      canvas,
      '+',
      Offset(x - 26, y - 16),
      const Color(0xFFEF4444),
      14,
      FontWeight.w800,
    );
    _drawText(
      canvas,
      '-',
      Offset(x - 24, y + 2),
      const Color(0xFF38BDF8),
      16,
      FontWeight.w800,
    );
    _drawText(
      canvas,
      '${v.toStringAsFixed(0)}V',
      Offset(x + 22, y - 6),
      Colors.white70,
      11,
      FontWeight.w700,
    );
  }

  /// Disegna il resistore con rettangolo a spirale ed effetto termico proporzionale alla potenza dissipata
  void _drawResistor(Canvas canvas, Offset center, double r, double p) {
    const resH = 56.0;
    const resW = 20.0;
    final x = center.dx;
    final y = center.dy;

    // Cancella il filo sottostante
    final clearPaint = Paint()..color = const Color(0xFF090D16);
    canvas.drawRect(
      Rect.fromCenter(center: center, width: resW + 12, height: resH + 6),
      clearPaint,
    );

    // Fattore di surriscaldamento (0.0 -> 1.0)
    final heatFactor = (p / 250.0).clamp(0.0, 1.0);

    // Alone termico luminoso se dissipa potenza
    if (heatFactor > 0.05) {
      final glowColor = Color.lerp(
        const Color(0x33F59E0B),
        const Color(0x99EF4444),
        heatFactor,
      )!;

      final glowPaint = Paint()
        ..color = glowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12.0 * heatFactor + 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: resW + 16, height: resH + 12),
          const Radius.circular(8),
        ),
        glowPaint,
      );
    }

    // Corpo del resistore
    final resistorBodyColor = Color.lerp(
      const Color(0xFF1E293B),
      const Color(0xFF7F1D1D),
      heatFactor,
    )!;

    final bodyPaint = Paint()
      ..color = resistorBodyColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: resW, height: resH),
        const Radius.circular(6),
      ),
      bodyPaint,
    );

    // Bordo del resistore
    final borderPaint = Paint()
      ..color = Color.lerp(
        const Color(0xFF64748B),
        const Color(0xFFF97316),
        heatFactor,
      )!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: resW, height: resH),
        const Radius.circular(6),
      ),
      borderPaint,
    );

    // Strisce del resistore (Bande di codice colore stilizzate)
    final stripePaint = Paint()..strokeWidth = 2.5;
    final stripeColors = [
      const Color(0xFF94A3B8),
      const Color(0xFFCBD5E1),
      const Color(0xFFE2E8F0),
    ];
    for (int i = 0; i < 3; i++) {
      final sy = y - 14 + (i * 14.0);
      stripePaint.color = stripeColors[i];
      canvas.drawLine(
        Offset(x - (resW / 2) + 2, sy),
        Offset(x + (resW / 2) - 2, sy),
        stripePaint,
      );
    }

    // Etichetta del valore di resistenza
    _drawText(
      canvas,
      '${r.toStringAsFixed(0)}Ω',
      Offset(x + 18, y - 6),
      const Color(0xFFE2E8F0),
      11,
      FontWeight.w700,
    );
  }

  /// Disegna l'amperometro circolare inline sul filo
  void _drawAmmeter(Canvas canvas, Offset center, double i) {
    final x = center.dx;
    final y = center.dy;

    // Cancella il filo sottostante
    final clearPaint = Paint()..color = const Color(0xFF090D16);
    canvas.drawCircle(center, 18, clearPaint);

    // Sfondo amperometro
    final bgPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 16, bgPaint);

    // Bordo amperometro
    final borderPaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, 16, borderPaint);

    // Testo "A" e valore
    _drawText(
      canvas,
      'A',
      Offset(x - 5, y - 7),
      const Color(0xFF38BDF8),
      11,
      FontWeight.w900,
    );
  }

  /// Disegna le particelle animate distribuite uniformemente lungo il perimetro rettangolare
  void _drawParticles(
    Canvas canvas,
    double left,
    double right,
    double top,
    double bottom,
  ) {
    final perimeter = 2 * (right - left) + 2 * (bottom - top);
    if (perimeter <= 0) return;

    // 28 particelle distribuite equamente
    const int particleCount = 28;

    final particlePaint = Paint()
      ..color =
          const Color(0xFF00F0FF) // Cyan brillante ad alta visibilità
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = const Color(0x6600F0FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);

    for (int i = 0; i < particleCount; i++) {
      // Offset relativo (0.0 -> 1.0)
      double t = (i / particleCount + phase) % 1.0;

      // Inverti direzione se mostriamo il moto reale degli elettroni (da - a +) vs convenzionale
      if (showElectronFlow) {
        t = (1.0 - t) % 1.0;
      }

      final pos = _getPointOnPerimeter(t, left, right, top, bottom, perimeter);

      // Salta il disegno se la particella si sovrappone esattamente ai componenti opachi
      if (_isInsideComponent(pos, left, right, (top + bottom) / 2)) {
        continue;
      }

      // Disegna alone luminoso e nucleo della particella
      canvas.drawCircle(pos, 4.0, glowPaint);
      canvas.drawCircle(pos, 2.2, particlePaint);
    }
  }

  /// Calcola le coordinate X, Y lungo il perimetro rettangolare per un valore t in [0.0, 1.0]
  Offset _getPointOnPerimeter(
    double t,
    double left,
    double right,
    double top,
    double bottom,
    double perimeter,
  ) {
    final dist = t * perimeter;

    final segTop = right - left;
    final segRight = bottom - top;
    final segBottom = right - left;

    if (dist < segTop) {
      // Bordo Superiore: da sinistra a destra
      return Offset(left + dist, top);
    } else if (dist < segTop + segRight) {
      // Bordo Destro: dall'alto verso il basso
      return Offset(right, top + (dist - segTop));
    } else if (dist < segTop + segRight + segBottom) {
      // Bordo Inferiore: da destra verso sinistra
      return Offset(right - (dist - segTop - segRight), bottom);
    } else {
      // Bordo Sinistro: dal basso verso l'alto
      return Offset(left, bottom - (dist - segTop - segRight - segBottom));
    }
  }

  /// Verifica se un punto si trova all'interno della sagoma della batteria o del resistore
  bool _isInsideComponent(Offset p, double left, double right, double midY) {
    // Generatore (sinistra)
    if ((p.dx - left).abs() < 12 && (p.dy - midY).abs() < 24) return true;
    // Resistore (destra)
    if ((p.dx - right).abs() < 14 && (p.dy - midY).abs() < 30) return true;
    return false;
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    Color color,
    double fontSize,
    FontWeight weight,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: weight,
          letterSpacing: -0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _CircuitPainter oldDelegate) {
    return oldDelegate.voltage != voltage ||
        oldDelegate.resistance != resistance ||
        oldDelegate.current != current ||
        oldDelegate.phase != phase ||
        oldDelegate.showElectronFlow != showElectronFlow;
  }
}
