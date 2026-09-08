import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/models/knowledge_node.dart';

/// Widget di simulazione e dimostrazione visiva della formula quadratica.
/// Offre due modalità didattiche:
/// 1. "Completamento del Quadrato": dissezione geometrica 2D step-by-step (al-Khwarizmi),
///    mostrando come il quadrato x², le due ali b/(2a)*x e il tassello d'angolo b²/(4a²)
///    formino il grande quadrato perfetto di lato (x + b/(2a)) con area Δ/(4a²).
/// 2. "Parabola & Simmetria": vista cartesiana della parabola, con asse di simmetria
///    x = -b/(2a) e semidistanza simmetrica ±√Δ/(2a) che genera le due radici.
class QuadraticVisualProofWidget extends StatefulWidget {
  final InteractiveData? data;

  const QuadraticVisualProofWidget({super.key, this.data});

  @override
  State<QuadraticVisualProofWidget> createState() =>
      _QuadraticVisualProofWidgetState();
}

class _QuadraticVisualProofWidgetState extends State<QuadraticVisualProofWidget>
    with SingleTickerProviderStateMixin {
  // Parametri dell'equazione ax² + bx + c = 0
  double _a = 1.0;
  double _b = 4.0;
  double _c = -5.0;
  double _baseX = 2.5; // Valore geometrico del lato x per la dissezione 2D

  // Modalità visiva: 0 = Completamento Geometrico, 1 = Parabola & Simmetria
  int _visualMode = 0;

  // Step della dimostrazione geometrica (da 0 a 4, ovvero Step 1 a 5)
  int _proofStep = 0;

  // Autoplay fermo di default (R1)
  bool _isPlaying = false;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _loadInitialParameters();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(_onAnimTick);
  }

  void _loadInitialParameters() {
    final params = widget.data?.parameters;
    if (params != null) {
      for (final p in params) {
        if (p.variableName == 'a' && p.defaultValue != null) {
          _a = p.defaultValue!;
        } else if (p.variableName == 'b' && p.defaultValue != null) {
          _b = p.defaultValue!;
        } else if (p.variableName == 'c' && p.defaultValue != null) {
          _c = p.defaultValue!;
        }
      }
    }
  }

  @override
  void didUpdateWidget(covariant QuadraticVisualProofWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _loadInitialParameters();
    }
  }

  void _onAnimTick() {
    if (_isPlaying) {
      final stepFrac = _animController.value * 5.0;
      final newStep = stepFrac.floor().clamp(0, 4);
      if (newStep != _proofStep) {
        setState(() {
          _proofStep = newStep;
        });
      }
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _animController.repeat();
      } else {
        _animController.stop();
      }
    });
  }

  void _nextStep() {
    setState(() {
      if (_proofStep < 4) {
        _proofStep++;
      } else {
        _proofStep = 0;
      }
    });
  }

  void _prevStep() {
    setState(() {
      if (_proofStep > 0) {
        _proofStep--;
      } else {
        _proofStep = 4;
      }
    });
  }

  @override
  void dispose() {
    _animController.removeListener(_onAnimTick);
    _animController.dispose();
    super.dispose();
  }

  // Calcoli algebrici
  double get _delta => _b * _b - 4 * _a * _c;
  double get _axisX => -_b / (2 * _a);
  double get _cornerPieceWidth => _b.abs() / (2 * _a.abs());

  double? get _root1 => _delta >= 0 ? (-_b + math.sqrt(_delta)) / (2 * _a) : null;
  double? get _root2 => _delta >= 0 ? (-_b - math.sqrt(_delta)) / (2 * _a) : null;

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(),
          const SizedBox(height: 14),
          _buildModeSelector(),
          const SizedBox(height: 14),
          if (_visualMode == 0) _buildStepNavigator(),
          const SizedBox(height: 14),
          _buildCanvasArea(),
          const SizedBox(height: 14),
          _buildTelemetryAndFormulaCard(),
          const SizedBox(height: 16),
          _buildSliders(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Row(
            children: [
              Icon(
                Icons.square_foot_rounded,
                color: Color(0xFF818CF8), // Indigo
                size: 22,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dimostrazione Visiva: Formula Quadratica',
                  style: TextStyle(
                    fontSize: 15,
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
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: const Color(0xFF818CF8),
                size: 26,
              ),
              tooltip: _isPlaying ? 'Metti in pausa' : 'Riproduci passaggi',
              onPressed: _togglePlayPause,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeSelector() {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment<int>(
          value: 0,
          label: Text('Completamento del Quadrato'),
          icon: Icon(Icons.grid_view_rounded, size: 16),
        ),
        ButtonSegment<int>(
          value: 1,
          label: Text('Parabola & Radici'),
          icon: Icon(Icons.show_chart_rounded, size: 16),
        ),
      ],
      selected: {_visualMode},
      onSelectionChanged: (Set<int> newSelection) {
        setState(() {
          _visualMode = newSelection.first;
        });
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF1E1B4B);
          }
          return AppTheme.surfaceElevated;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFFA5B4FC);
          }
          return AppTheme.textSecondary;
        }),
        side: WidgetStateProperty.all(const BorderSide(color: AppTheme.borderDark)),
      ),
    );
  }

  Widget _buildStepNavigator() {
    final stepTitles = [
      '1. Area di partenza: x² + (b/a)x',
      '2. Taglio simmetrico a "L": due ali da b/(2a)x',
      '3. Il tassello vuoto: spazio mancante b²/(4a²)',
      '4. Completamento del Quadrato: aggiunta tassello',
      '5. Risoluzione: lato = √(Δ/(4a²)) ➔ formula',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                color: const Color(0xFF818CF8),
                onPressed: _prevStep,
                tooltip: 'Passo precedente',
                visualDensity: VisualDensity.compact,
              ),
              Expanded(
                child: Text(
                  stepTitles[_proofStep],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                color: const Color(0xFF818CF8),
                onPressed: _nextStep,
                tooltip: 'Passo successivo',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final isActive = index == _proofStep;
              return InkWell(
                onTap: () => setState(() => _proofStep = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF818CF8) : AppTheme.surfaceHighlight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvasArea() {
    return Container(
      height: 270,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark slate per massimo contrasto visivo
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _visualMode == 0
                  ? _CompletingSquarePainter(
                      a: _a,
                      b: _b,
                      c: _c,
                      baseX: _baseX,
                      proofStep: _proofStep,
                    )
                  : _ParabolaSymmetryPainter(
                      a: _a,
                      b: _b,
                      c: _c,
                      delta: _delta,
                    ),
            ),
          ),
          Positioned(
            top: 10,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xCC0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Text(
                _visualMode == 0
                    ? 'Dissezione Geometrica 2D'
                    : 'Piano Cartesiano & Simmetria',
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryAndFormulaCard() {
    final delta = _delta;
    final axis = _axisX;
    final r1 = _root1;
    final r2 = _root2;

    Color badgeColor;
    String badgeText;
    if (delta > 0) {
      badgeColor = const Color(0xFF10B981); // Emerald
      badgeText = 'Δ > 0 (2 Radici Reali)';
    } else if (delta.abs() < 1e-6) {
      badgeColor = const Color(0xFFF59E0B); // Amber
      badgeText = 'Δ = 0 (1 Radice Doppia)';
    } else {
      badgeColor = const Color(0xFFEF4444); // Rose
      badgeText = 'Δ < 0 (Nessuna Radice Reale)';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Telemetria e Risoluzione',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Discriminante Δ',
                  value: delta.toStringAsFixed(2),
                  formula: 'b² - 4ac',
                  color: const Color(0xFF818CF8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: 'Asse di Simmetria',
                  value: 'x = ${axis.toStringAsFixed(2)}',
                  formula: '-b / (2a)',
                  color: const Color(0xFF38BDF8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: 'Tassello Mancante',
                  value: (_cornerPieceWidth * _cornerPieceWidth).toStringAsFixed(2),
                  formula: 'b² / (4a²)',
                  color: const Color(0xFF34D399),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderDark),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  r1 != null
                      ? 'x₁ = ${r1.toStringAsFixed(2)}'
                      : 'x₁ ∈ ℂ (non reale)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Container(width: 1, height: 16, color: AppTheme.borderDark),
                Text(
                  r2 != null
                      ? 'x₂ = ${r2.toStringAsFixed(2)}'
                      : 'x₂ ∈ ℂ (non reale)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Container(width: 1, height: 16, color: AppTheme.borderDark),
                Text(
                  'Semidistanza = ${delta >= 0 ? (math.sqrt(delta) / (2 * _a.abs())).toStringAsFixed(2) : "N/D"}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String formula,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            formula,
            style: TextStyle(
              fontSize: 9,
              fontStyle: FontStyle.italic,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliders() {
    return Column(
      children: [
        _buildSliderRow(
          label: 'Coefficiente a',
          value: _a,
          min: 0.5,
          max: 3.0,
          divisions: 25,
          color: const Color(0xFF4F46E5),
          onChanged: (val) => setState(() => _a = val),
        ),
        _buildSliderRow(
          label: 'Coefficiente b',
          value: _b,
          min: 1.0,
          max: 8.0,
          divisions: 35,
          color: const Color(0xFFF59E0B),
          onChanged: (val) => setState(() => _b = val),
        ),
        _buildSliderRow(
          label: 'Termine noto c',
          value: _c,
          min: -8.0,
          max: 8.0,
          divisions: 64,
          color: const Color(0xFF10B981),
          onChanged: (val) => setState(() => _c = val),
        ),
        if (_visualMode == 0)
          _buildSliderRow(
            label: 'Dimensione geometrica base x',
            value: _baseX,
            min: 1.5,
            max: 4.0,
            divisions: 25,
            color: const Color(0xFF0284C7),
            onChanged: (val) => setState(() => _baseX = val),
          ),
      ],
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    final clampedValue = value.clamp(min, max);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label: ${value.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                activeTrackColor: color,
                inactiveTrackColor: color.withValues(alpha: 0.22),
                thumbColor: color,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              ),
              child: Slider(
                value: clampedValue,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter per la dissezione geometrica 2D del Completamento del Quadrato
class _CompletingSquarePainter extends CustomPainter {
  final double a;
  final double b;
  final double c;
  final double baseX;
  final int proofStep; // 0, 1, 2, 3, 4

  _CompletingSquarePainter({
    required this.a,
    required this.b,
    required this.c,
    required this.baseX,
    required this.proofStep,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Scala di disegno calibrata sulla dimensione base x e larghezza del tassello b/(2a)
    final pHalf = (b.abs() / (2 * a.abs())).clamp(0.4, 3.0);
    final totalSide = baseX + pHalf;
    final scale = (math.min(size.width, size.height) * 0.70) / totalSide;

    final xPix = baseX * scale;
    final pPix = pHalf * scale;

    // Posizionamento del vertice inferiore sinistro del quadrato x²
    final originX = cx - (xPix + pPix) / 2;
    final originY = cy + (xPix + pPix) / 2;

    // 1. Quadrato x² (blu/indigo)
    final squarePaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    final squareBorder = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final sqRect = Rect.fromLTWH(originX, originY - xPix, xPix, xPix);
    canvas.drawRect(sqRect, squarePaint);
    canvas.drawRect(sqRect, squareBorder);

    _drawText(
      canvas,
      'x²',
      Offset(sqRect.center.dx, sqRect.center.dy - 6),
      const TextStyle(
        color: Color(0xFFE0F2FE),
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
    _drawText(
      canvas,
      'Area = x²',
      Offset(sqRect.center.dx, sqRect.center.dy + 12),
      const TextStyle(
        color: Color(0xFFBAE6FD),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );

    // Quote dimensionali su x
    _drawDimension(canvas, Offset(originX, originY + 8),
        Offset(originX + xPix, originY + 8), 'x', const Color(0xFF38BDF8));
    _drawDimension(canvas, Offset(originX - 8, originY),
        Offset(originX - 8, originY - xPix), 'x', const Color(0xFF38BDF8));

    // Passo 0: Mostra il rettangolo lineare (b/a)*x a lato
    if (proofStep == 0) {
      final fullRectPaint = Paint()
        ..color = const Color(0xFFF59E0B).withValues(alpha: 0.35)
        ..style = PaintingStyle.fill;
      final fullRectBorder = Paint()
        ..color = const Color(0xFFF59E0B)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final fullW = (pHalf * 2) * scale;
      final rectRight = Rect.fromLTWH(originX + xPix + 8, originY - xPix, fullW, xPix);
      canvas.drawRect(rectRight, fullRectPaint);
      canvas.drawRect(rectRight, fullRectBorder);

      _drawText(
        canvas,
        '(b/a) · x',
        Offset(rectRight.center.dx, rectRight.center.dy),
        const TextStyle(
          color: Color(0xFFFEF3C7),
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      );
      _drawDimension(
        canvas,
        Offset(rectRight.left, rectRight.bottom + 8),
        Offset(rectRight.right, rectRight.bottom + 8),
        'b/a',
        const Color(0xFFF59E0B),
      );
      return;
    }

    // Passo 1+: Rettangoli simmetrici a "L" (b/(2a))*x
    final wingPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    final wingBorder = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Ala destra: x in altezza, pPix in larghezza
    final rightWing = Rect.fromLTWH(originX + xPix, originY - xPix, pPix, xPix);
    canvas.drawRect(rightWing, wingPaint);
    canvas.drawRect(rightWing, wingBorder);

    _drawText(
      canvas,
      'b/(2a)·x',
      rightWing.center,
      const TextStyle(
        color: Color(0xFFFEF3C7),
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    );
    _drawDimension(
      canvas,
      Offset(rightWing.left, rightWing.bottom + 8),
      Offset(rightWing.right, rightWing.bottom + 8),
      'b/(2a)',
      const Color(0xFFF59E0B),
    );

    // Ala superiore: pPix in altezza, xPix in larghezza
    final topWing = Rect.fromLTWH(originX, originY - xPix - pPix, xPix, pPix);
    canvas.drawRect(topWing, wingPaint);
    canvas.drawRect(topWing, wingBorder);

    _drawText(
      canvas,
      'b/(2a)·x',
      topWing.center,
      const TextStyle(
        color: Color(0xFFFEF3C7),
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    );
    _drawDimension(
      canvas,
      Offset(topWing.left - 8, topWing.bottom),
      Offset(topWing.left - 8, topWing.top),
      'b/(2a)',
      const Color(0xFFF59E0B),
    );

    // Passo 2: Evidenziazione spazio vuoto angolare (Tassello Mancante)
    final cornerRect =
        Rect.fromLTWH(originX + xPix, originY - xPix - pPix, pPix, pPix);

    if (proofStep == 2) {
      final emptyPaint = Paint()
        ..color = const Color(0xFFEF4444).withValues(alpha: 0.18)
        ..style = PaintingStyle.fill;
      final dashedBorder = Paint()
        ..color = const Color(0xFFEF4444)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawRect(cornerRect, emptyPaint);
      _drawDashedRect(canvas, cornerRect, dashedBorder);

      _drawText(
        canvas,
        'MANCANTE!',
        Offset(cornerRect.center.dx, cornerRect.center.dy - 6),
        const TextStyle(
          color: Color(0xFFFCA5A5),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      );
      _drawText(
        canvas,
        '[b/(2a)]²',
        Offset(cornerRect.center.dx, cornerRect.center.dy + 8),
        const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    // Passo 3 e 4: Tassello completato in smeraldo
    if (proofStep >= 3) {
      final cornerFilledPaint = Paint()
        ..color = const Color(0xFF10B981).withValues(alpha: 0.45)
        ..style = PaintingStyle.fill;
      final cornerFilledBorder = Paint()
        ..color = const Color(0xFF10B981)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;

      canvas.drawRect(cornerRect, cornerFilledPaint);
      canvas.drawRect(cornerRect, cornerFilledBorder);

      _drawText(
        canvas,
        'TASSELLO',
        Offset(cornerRect.center.dx, cornerRect.center.dy - 6),
        const TextStyle(
          color: Color(0xFFA7F3D0),
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      );
      _drawText(
        canvas,
        'b² / (4a²)',
        Offset(cornerRect.center.dx, cornerRect.center.dy + 8),
        const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    // Passo 4: Grande quadrato completo di lato (x + b/(2a))
    if (proofStep == 4) {
      final bigBorder = Paint()
        ..color = const Color(0xFFA855F7) // Purple glow
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      final bigRect =
          Rect.fromLTWH(originX, originY - xPix - pPix, xPix + pPix, xPix + pPix);
      canvas.drawRect(bigRect, bigBorder);

      _drawDimension(
        canvas,
        Offset(bigRect.left, bigRect.top - 12),
        Offset(bigRect.right, bigRect.top - 12),
        'Lato = x + b/(2a)',
        const Color(0xFFA855F7),
      );
      _drawDimension(
        canvas,
        Offset(bigRect.right + 12, bigRect.bottom),
        Offset(bigRect.right + 12, bigRect.top),
        'Lato = x + b/(2a)',
        const Color(0xFFA855F7),
      );
    }
  }

  void _drawDimension(
      Canvas canvas, Offset p1, Offset p2, String label, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;

    canvas.drawLine(p1, p2, paint);

    // Ticks alle estremità
    final normal = Offset(-(p2.dy - p1.dy), p2.dx - p1.dx);
    final len = normal.distance;
    if (len > 0) {
      final unitNorm = normal / len * 4;
      canvas.drawLine(p1 - unitNorm, p1 + unitNorm, paint);
      canvas.drawLine(p2 - unitNorm, p2 + unitNorm, paint);
    }

    final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
    _drawText(
      canvas,
      label,
      mid,
      TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        backgroundColor: const Color(0xDD0F172A),
      ),
    );
  }

  void _drawDashedRect(Canvas canvas, Rect rect, Paint paint) {
    const dashLength = 4.0;
    const gap = 3.0;

    void drawDashedLine(Offset start, Offset end) {
      final totalDist = (end - start).distance;
      final dir = (end - start) / totalDist;
      double currentDist = 0;
      while (currentDist < totalDist) {
        final d1 = currentDist;
        final d2 = math.min(currentDist + dashLength, totalDist);
        canvas.drawLine(start + dir * d1, start + dir * d2, paint);
        currentDist += dashLength + gap;
      }
    }

    drawDashedLine(rect.topLeft, rect.topRight);
    drawDashedLine(rect.topRight, rect.bottomRight);
    drawDashedLine(rect.bottomRight, rect.bottomLeft);
    drawDashedLine(rect.bottomLeft, rect.topLeft);
  }

  void _drawText(Canvas canvas, String text, Offset center, TextStyle style) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final offset =
        Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _CompletingSquarePainter oldDelegate) {
    return oldDelegate.a != a ||
        oldDelegate.b != b ||
        oldDelegate.c != c ||
        oldDelegate.baseX != baseX ||
        oldDelegate.proofStep != proofStep;
  }
}

/// CustomPainter per la visualizzazione Cartesiana della Parabola e della Simmetria delle Radici
class _ParabolaSymmetryPainter extends CustomPainter {
  final double a;
  final double b;
  final double c;
  final double delta;

  _ParabolaSymmetryPainter({
    required this.a,
    required this.b,
    required this.c,
    required this.delta,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Coordinate del vertice
    final xv = -b / (2 * a);
    final yv = -delta / (4 * a);

    // Sistema di coordinate cartesiano centrato attorno al vertice e all'asse x
    // x range tipico: [xv - 4, xv + 4]
    const xHalfSpan = 4.0;
    final scaleX = (size.width * 0.85) / (2 * xHalfSpan);
    const scaleY = 12.0;

    Offset toScreen(double x, double y) {
      final sx = cx + (x - xv) * scaleX;
      final sy = cy - y * scaleY + (yv.clamp(-4.0, 4.0) * scaleY * 0.4);
      return Offset(sx, sy);
    }

    // 1. Griglia e Assi
    final axisPaint = Paint()
      ..color = const Color(0xFF475569)
      ..strokeWidth = 1.2;

    // Asse x (y = 0)
    final pXLeft = toScreen(xv - xHalfSpan, 0);
    final pXRight = toScreen(xv + xHalfSpan, 0);
    canvas.drawLine(pXLeft, pXRight, axisPaint);

    // Asse di simmetria tratteggiato (x = xv)
    final symmetryPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 1.5;
    final topSym = toScreen(xv, 15);
    final botSym = toScreen(xv, -15);
    _drawDashedLine(canvas, topSym, botSym, symmetryPaint);

    // 2. Tracciamento Parabola y = ax² + bx + c
    final curvePaint = Paint()
      ..color = const Color(0xFFA855F7)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool first = true;
    for (double x = xv - xHalfSpan; x <= xv + xHalfSpan; x += 0.05) {
      final y = a * x * x + b * x + c;
      final pt = toScreen(x, y);
      if (first) {
        path.moveTo(pt.dx, pt.dy);
        first = false;
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(path, curvePaint);

    // 3. Vertice V(xv, yv)
    final vPt = toScreen(xv, yv);
    final vertexPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(vPt, 5, vertexPaint);

    _drawText(
      canvas,
      'V(${xv.toStringAsFixed(1)}, ${yv.toStringAsFixed(1)})',
      Offset(vPt.dx, vPt.dy + (a > 0 ? 14 : -14)),
      const TextStyle(
        color: Color(0xFF38BDF8),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        backgroundColor: Color(0xCC0F172A),
      ),
    );

    // 4. Se Δ >= 0, evidenziazione radici e semidistanza simmetrica
    if (delta >= 0) {
      final semidist = math.sqrt(delta) / (2 * a.abs());
      final x1 = xv - semidist;
      final x2 = xv + semidist;

      final pt1 = toScreen(x1, 0);
      final pt2 = toScreen(x2, 0);

      final rootPaint = Paint()
        ..color = const Color(0xFF10B981)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pt1, 5.5, rootPaint);
      canvas.drawCircle(pt2, 5.5, rootPaint);

      _drawText(
        canvas,
        'x₁ = ${x1.toStringAsFixed(2)}',
        Offset(pt1.dx, pt1.dy - 14),
        const TextStyle(
          color: Color(0xFF10B981),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          backgroundColor: Color(0xCC0F172A),
        ),
      );
      _drawText(
        canvas,
        'x₂ = ${x2.toStringAsFixed(2)}',
        Offset(pt2.dx, pt2.dy - 14),
        const TextStyle(
          color: Color(0xFF10B981),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          backgroundColor: Color(0xCC0F172A),
        ),
      );

      // Frecce di semidistanza dall'asse
      final distPaint = Paint()
        ..color = const Color(0xFFF59E0B)
        ..strokeWidth = 1.8;
      final pCenter = toScreen(xv, 0);

      canvas.drawLine(pCenter, pt1, distPaint);
      canvas.drawLine(pCenter, pt2, distPaint);

      _drawText(
        canvas,
        '-√Δ/(2a)',
        Offset((pCenter.dx + pt1.dx) / 2, pCenter.dy + 12),
        const TextStyle(
          color: Color(0xFFF59E0B),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          backgroundColor: Color(0xDD0F172A),
        ),
      );
      _drawText(
        canvas,
        '+√Δ/(2a)',
        Offset((pCenter.dx + pt2.dx) / 2, pCenter.dy + 12),
        const TextStyle(
          color: Color(0xFFF59E0B),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          backgroundColor: Color(0xDD0F172A),
        ),
      );
    } else {
      _drawText(
        canvas,
        'Δ < 0: La parabola non interseca l\'asse x (nessuna radice reale)',
        Offset(cx, cy - 60),
        const TextStyle(
          color: Color(0xFFF87171),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          backgroundColor: Color(0xDD0F172A),
        ),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashLength = 4.0;
    const gap = 3.0;
    final totalDist = (p2 - p1).distance;
    final dir = (p2 - p1) / totalDist;
    double currentDist = 0;
    while (currentDist < totalDist) {
      final d1 = currentDist;
      final d2 = math.min(currentDist + dashLength, totalDist);
      canvas.drawLine(p1 + dir * d1, p1 + dir * d2, paint);
      currentDist += dashLength + gap;
    }
  }

  void _drawText(Canvas canvas, String text, Offset center, TextStyle style) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final offset =
        Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _ParabolaSymmetryPainter oldDelegate) {
    return oldDelegate.a != a ||
        oldDelegate.b != b ||
        oldDelegate.c != c ||
        oldDelegate.delta != delta;
  }
}
