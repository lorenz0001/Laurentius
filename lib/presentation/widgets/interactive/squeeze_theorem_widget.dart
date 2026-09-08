import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/models/knowledge_node.dart';

/// Widget di simulazione interattiva per il Teorema del Confronto (Teorema dei Carabinieri / Squeeze Theorem).
/// Dimostra visivamente come la funzione f(x) = sin(x)/x rimanga intrappolata tra
/// g(x) = cos(x) (carabiniere inferiore) e h(x) = 1 (carabiniere superiore),
/// stringendo l'intervallo a ampiezza zero per x -> 0, dimostrando che lim_{x->0} sin(x)/x = 1.
class SqueezeTheoremWidget extends StatefulWidget {
  final InteractiveData? data;

  const SqueezeTheoremWidget({super.key, this.data});

  @override
  State<SqueezeTheoremWidget> createState() => _SqueezeTheoremWidgetState();
}

class _SqueezeTheoremWidgetState extends State<SqueezeTheoremWidget>
    with SingleTickerProviderStateMixin {
  double _delta = 0.8; // Semiamplitude dell'intorno [-delta, delta]
  double _k = 1.0; // Fattore di frequenza
  double _probeX = 0.5; // Punto sonda all'interno dell'intorno
  bool _isPlaying = false; // Fermo di default per chiarezza didattica

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _loadInitialParameters();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(_onAnimTick);
  }

  @override
  void didUpdateWidget(covariant SqueezeTheoremWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _loadInitialParameters();
    }
  }

  void _loadInitialParameters() {
    _delta = 0.8;
    _k = 1.0;
    _probeX = 0.5;

    final params = widget.data?.parameters;
    if (params != null) {
      for (final p in params) {
        if (p.variableName == 'delta' && p.defaultValue != null) {
          _delta = p.defaultValue!;
        } else if (p.variableName == 'k' && p.defaultValue != null) {
          _k = p.defaultValue!;
        }
      }
    }
    _probeX = (_delta * 0.6).clamp(0.05, _delta);
  }

  void _onAnimTick() {
    if (_isPlaying) {
      setState(() {
        // Delta oscilla dolcemente tra 1.4 e 0.05 mostrando l'effetto schiacciamento
        final t = Curves.easeInOutSine.transform(_animController.value);
        _delta = 0.05 + (1.0 - t) * 1.35;
        _probeX = (_probeX).clamp(-_delta, _delta);
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
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

  // Funzione carabiniere inferiore: g(x) = cos(k * x)
  double _g(double x) => math.cos(_k * x);

  // Funzione intrappolata: f(x) = sin(k * x) / x con f(0) = k
  double _f(double x) {
    if (x.abs() < 1e-6) return _k;
    return math.sin(_k * x) / x;
  }

  // Funzione carabiniere superiore: h(x) = 1.0
  double _h(double x) => 1.0;

  @override
  Widget build(BuildContext context) {
    final gx = _g(_probeX);
    final fx = _f(_probeX);
    final hx = _h(_probeX);
    final corridorWidth = (hx - gx).abs();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderDark),
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
          // Header con Titolo, Icona e Toggle Animazione
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.compress_rounded,
                      color: Color(0xFF818CF8),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Teorema del Confronto (Carabinieri)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
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
                      _isPlaying
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_fill_rounded,
                    ),
                    color: const Color(0xFF818CF8),
                    iconSize: 26,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: _isPlaying
                        ? 'Pausa convergenza'
                        : 'Anima convergenza δ ➔ 0 a 60 FPS',
                    onPressed: _togglePlayPause,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B4B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF4338CA)),
                    ),
                    child: Text(
                      'δ = ±${_delta.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFA5B4FC),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Canvas Grafico Interattivo
          SizedBox(
            height: 240,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFF0F172A),
                child: CustomPaint(
                  painter: _SqueezeTheoremPainter(
                    delta: _delta,
                    k: _k,
                    probeX: _probeX,
                    g: _g,
                    f: _f,
                    h: _h,
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
                  title: 'INF: g(x) = cos(x)',
                  value: gx.toStringAsFixed(3),
                  formula: 'g(x) ≤ f(x)',
                  color: const Color(0xFFF59E0B),
                  icon: Icons.south_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTelemetryBox(
                  title: 'TRAPPOLA: sin(x)/x',
                  value: fx.toStringAsFixed(3),
                  formula: 'lim x➔0 = 1',
                  color: const Color(0xFF38BDF8),
                  icon: Icons.grain_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTelemetryBox(
                  title: 'SUP: h(x) = 1',
                  value: hx.toStringAsFixed(3),
                  formula: 'f(x) ≤ h(x)',
                  color: const Color(0xFF10B981),
                  icon: Icons.north_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTelemetryBox(
                  title: 'SPAZIO BANDA |h - g|',
                  value: corridorWidth.toStringAsFixed(3),
                  formula: 'Ampiezza ➔ 0',
                  color: const Color(0xFFA855F7),
                  icon: Icons.unfold_less_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Riquadro Teorema Formale
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderDark),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: AppTheme.accentGreenBright,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'cos(x) ≤ sin(x)/x ≤ 1   ∀ x ∈ [-δ, δ] \\ {0}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Per x ➔ 0: lim cos(x) = 1 e lim 1 = 1  ⇒  per il teorema dei due carabinieri  lim (sin x)/x = 1',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Slider per Delta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ampiezza intorno di convergenza (δ):',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                'δ = ${_delta.toStringAsFixed(2)} rad',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF818CF8),
                ),
              ),
            ],
          ),
          Slider(
            value: _delta.clamp(0.05, 1.5),
            min: 0.05,
            max: 1.5,
            divisions: 29,
            activeColor: const Color(0xFF818CF8),
            inactiveColor: const Color(0xFF312E81),
            onChanged: (val) {
              if (_isPlaying) {
                setState(() {
                  _isPlaying = false;
                  _animController.stop();
                });
              }
              setState(() {
                _delta = val;
                _probeX = _probeX.clamp(-val, val);
              });
            },
          ),

          // Slider per Punto Sonda x
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Punto sonda interno x:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                'x = ${_probeX.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF38BDF8),
                ),
              ),
            ],
          ),
          Slider(
            value: _probeX.clamp(-_delta, _delta),
            min: -_delta,
            max: _delta,
            divisions: 40,
            activeColor: const Color(0xFF38BDF8),
            inactiveColor: const Color(0xFF0C4A6E),
            onChanged: (val) {
              if (_isPlaying) {
                setState(() {
                  _isPlaying = false;
                  _animController.stop();
                });
              }
              setState(() {
                _probeX = val;
              });
            },
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
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
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.2,
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
              fontSize: 15,
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
              color: AppTheme.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// CustomPainter che disegna l'inviluppo di schiacciamento, le 3 curve e la sonda di convergenza.
class _SqueezeTheoremPainter extends CustomPainter {
  final double delta;
  final double k;
  final double probeX;
  final double Function(double) g;
  final double Function(double) f;
  final double Function(double) h;

  _SqueezeTheoremPainter({
    required this.delta,
    required this.k,
    required this.probeX,
    required this.g,
    required this.f,
    required this.h,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const xMin = -2.4;
    const xMax = 2.4;
    const yMin = -0.1;
    const yMax = 1.35;

    Offset toPixel(double x, double y) {
      final px = (x - xMin) / (xMax - xMin) * size.width;
      final py = size.height - (y - yMin) / (yMax - yMin) * size.height;
      return Offset(px, py);
    }

    // 1. Griglia cartesiana
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 0.8;

    for (double gx = -2.0; gx <= 2.0; gx += 1.0) {
      canvas.drawLine(toPixel(gx, yMin), toPixel(gx, yMax), gridPaint);
    }
    for (double gy = 0.0; gy <= 1.2; gy += 0.5) {
      canvas.drawLine(toPixel(xMin, gy), toPixel(xMax, gy), gridPaint);
    }

    // Assi cartesiani
    final axisPaint = Paint()
      ..color = const Color(0xFF475569)
      ..strokeWidth = 1.4;

    canvas.drawLine(toPixel(xMin, 0), toPixel(xMax, 0), axisPaint);
    canvas.drawLine(toPixel(0, yMin), toPixel(0, yMax), axisPaint);

    // 2. Corridoio di schiacciamento (Squeeze Envelope Shading) tra g(x) e h(x) per x in [-delta, delta]
    final envelopePath = Path();
    final dStart = -delta;
    final dEnd = delta;
    const steps = 40;

    // Linea superiore lungo h(x) da -delta a +delta
    envelopePath.moveTo(toPixel(dStart, h(dStart)).dx, toPixel(dStart, h(dStart)).dy);
    for (int i = 1; i <= steps; i++) {
      final x = dStart + (dEnd - dStart) * (i / steps);
      final pt = toPixel(x, h(x));
      envelopePath.lineTo(pt.dx, pt.dy);
    }

    // Ritorno lungo g(x) da +delta a -delta
    for (int i = steps; i >= 0; i--) {
      final x = dStart + (dEnd - dStart) * (i / steps);
      final pt = toPixel(x, g(x));
      envelopePath.lineTo(pt.dx, pt.dy);
    }
    envelopePath.close();

    final envelopePaint = Paint()
      ..color = const Color(0x336366F1) // Indigo traslucido
      ..style = PaintingStyle.fill;
    canvas.drawPath(envelopePath, envelopePaint);

    // Delimitatori verticali tratteggiati dell'intorno x = -delta e x = +delta
    final boundPaint = Paint()
      ..color = const Color(0x88A5B4FC)
      ..strokeWidth = 1.2;

    _drawDashedLine(
      canvas,
      toPixel(-delta, 0),
      toPixel(-delta, h(-delta)),
      boundPaint,
    );
    _drawDashedLine(
      canvas,
      toPixel(delta, 0),
      toPixel(delta, h(delta)),
      boundPaint,
    );

    _drawLabel(canvas, '-δ', Offset(toPixel(-delta, 0).dx - 8, toPixel(-delta, 0).dy + 4), const Color(0xFFA5B4FC));
    _drawLabel(canvas, '+δ', Offset(toPixel(delta, 0).dx - 2, toPixel(delta, 0).dy + 4), const Color(0xFFA5B4FC));

    // 3. Curve Funzioni
    // Curva h(x) = 1 (Carabiniere Superiore: Verde Smeraldo)
    final hPath = Path();
    hPath.moveTo(toPixel(xMin, 1.0).dx, toPixel(xMin, 1.0).dy);
    hPath.lineTo(toPixel(xMax, 1.0).dx, toPixel(xMax, 1.0).dy);
    canvas.drawPath(
      hPath,
      Paint()
        ..color = const Color(0xFF10B981)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke,
    );

    // Curva g(x) = cos(x) (Carabiniere Inferiore: Ambra)
    final gPath = Path();
    bool firstG = true;
    for (double px = 0; px <= size.width; px += 2.0) {
      final x = xMin + (px / size.width) * (xMax - xMin);
      final pt = toPixel(x, g(x));
      if (firstG) {
        gPath.moveTo(pt.dx, pt.dy);
        firstG = false;
      } else {
        gPath.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(
      gPath,
      Paint()
        ..color = const Color(0xFFF59E0B)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke,
    );

    // Curva f(x) = sin(x)/x (Funzione Trappola: Celeste Chiaro)
    final fPath = Path();
    bool firstF = true;
    for (double px = 0; px <= size.width; px += 2.0) {
      final x = xMin + (px / size.width) * (xMax - xMin);
      final pt = toPixel(x, f(x));
      if (firstF) {
        fPath.moveTo(pt.dx, pt.dy);
        firstF = false;
      } else {
        fPath.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(
      fPath,
      Paint()
        ..color = const Color(0xFF38BDF8)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // 4. Punto Limite Comune (0, 1) con alone
    final limitPoint = toPixel(0.0, 1.0);
    final limitGlow = Paint()
      ..color = const Color(0x6638BDF8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(limitPoint, 8.0, limitGlow);
    canvas.drawCircle(limitPoint, 5.0, Paint()..color = const Color(0xFF38BDF8));
    canvas.drawCircle(limitPoint, 2.0, Paint()..color = Colors.white);
    _drawLabel(
      canvas,
      'Limite L = 1',
      Offset(limitPoint.dx + 8, limitPoint.dy - 12),
      const Color(0xFF38BDF8),
      fontSize: 10,
      fontWeight: FontWeight.w700,
    );

    // 5. Linea Sonda a probeX che connette g(x), f(x), h(x)
    final ptProbeG = toPixel(probeX, g(probeX));
    final ptProbeF = toPixel(probeX, f(probeX));
    final ptProbeH = toPixel(probeX, h(probeX));

    final probeLinePaint = Paint()
      ..color = const Color(0xCCF43F5E)
      ..strokeWidth = 1.6;

    // Segmento verticale sonda tra g e h
    canvas.drawLine(ptProbeG, ptProbeH, probeLinePaint);

    // Punti sonda sulle 3 curve
    canvas.drawCircle(ptProbeG, 4.0, Paint()..color = const Color(0xFFF59E0B));
    canvas.drawCircle(ptProbeF, 4.5, Paint()..color = const Color(0xFF38BDF8));
    canvas.drawCircle(ptProbeH, 4.0, Paint()..color = const Color(0xFF10B981));

    // Etichette curve
    _drawLabel(canvas, 'h(x) = 1', Offset(toPixel(1.5, 1.0).dx, toPixel(1.5, 1.0).dy - 14), const Color(0xFF10B981));
    _drawLabel(canvas, 'g(x) = cos(x)', Offset(toPixel(1.4, g(1.4)).dx, toPixel(1.4, g(1.4)).dy + 8), const Color(0xFFF59E0B));
    _drawLabel(canvas, 'f(x) = sin(x)/x', Offset(toPixel(-2.1, f(-2.1)).dx, toPixel(-2.1, f(-2.1)).dy - 16), const Color(0xFF38BDF8));
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
  bool shouldRepaint(covariant _SqueezeTheoremPainter oldDelegate) {
    return oldDelegate.delta != delta ||
        oldDelegate.k != k ||
        oldDelegate.probeX != probeX;
  }
}
