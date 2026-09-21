import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/models/knowledge_node.dart';

/// Modalità didattica di visualizzazione vettoriale 2D.
enum VectorViewMode {
  /// Modo 1: Vettore singolo, coordinate cartesiane, proiezioni sugli assi e base canonica.
  components,

  /// Modo 2: Somma vettoriale s = v1 + v2 con toggle tra regola del parallelogramma e punta-coda.
  addition,

  /// Modo 3: Combinazione lineare w = c1*v1 + c2*v2, calcolo del determinante 2D e visualizzazione dello Span.
  span,
}

/// Modello interno immutabile per il calcolo vettoriale in R^2.
class _Vec2 {
  final double x;
  final double y;

  const _Vec2(this.x, this.y);

  double get length => math.sqrt(x * x + y * y);
  double get angle => math.atan2(y, x);
  double get angleDeg {
    final deg = angle * 180 / math.pi;
    return deg < 0 ? deg + 360 : deg;
  }

  _Vec2 operator +(_Vec2 o) => _Vec2(x + o.x, y + o.y);
  _Vec2 operator -(_Vec2 o) => _Vec2(x - o.x, y - o.y);
  _Vec2 operator *(double s) => _Vec2(x * s, y * s);

  double dot(_Vec2 o) => x * o.x + y * o.y;
  double cross(_Vec2 o) => x * o.y - y * o.x;

  _Vec2 clamp(double minVal, double maxVal) => _Vec2(
        x.clamp(minVal, maxVal),
        y.clamp(minVal, maxVal),
      );
}

/// Widget interattivo a 60 FPS in stile Brilliant per l'esplorazione geometrica e algebrica di vettori in R^2.
/// Supporta drag diretto touch delle punte dei vettori, variazione scalare con slider,
/// verifica della disuguaglianza triangolare, calcolo del determinante e verifica della collinearità.
class Vector2DSimulationWidget extends StatefulWidget {
  final InteractiveData? data;

  const Vector2DSimulationWidget({super.key, this.data});

  @override
  State<Vector2DSimulationWidget> createState() =>
      _Vector2DSimulationWidgetState();
}

class _Vector2DSimulationWidgetState extends State<Vector2DSimulationWidget>
    with SingleTickerProviderStateMixin {
  late VectorViewMode _currentMode;
  late _Vec2 _v1;
  late _Vec2 _v2;
  double _c1 = 1.0;
  double _c2 = 1.0;
  bool _useParallelogram = true; // true = parallelogramma, false = punta-coda
  bool _isAutoAnimating = false; // Strictly paused on mount!
  int? _draggedIndex; // 1 = v1, 2 = v2, null = nessuno
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _initParameters();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(_onAnimationTick);
  }

  void _initParameters() {
    final t = widget.data?.templateType?.toLowerCase() ?? '';
    if (t == 'vector_addition' || t == 'somma_vettoriale') {
      _currentMode = VectorViewMode.addition;
    } else if (t == 'linear_combination' ||
        t == 'span_2d' ||
        t == 'combinazione_lineare' ||
        t == 'vector_span' ||
        t == 'vector_space') {
      _currentMode = VectorViewMode.span;
    } else {
      _currentMode = VectorViewMode.components;
    }

    double v1x = 3.0;
    double v1y = 2.0;
    double v2x = -1.0;
    double v2y = 3.0;
    double c1 = 1.0;
    double c2 = 1.0;

    final params = widget.data?.parameters;
    if (params != null) {
      for (final p in params) {
        final name = p.variableName?.toLowerCase() ?? '';
        final val = p.defaultValue ?? 0.0;
        if (name == 'vx' || name == 'v1x' || name == 'x1') {
          v1x = val;
        } else if (name == 'vy' || name == 'v1y' || name == 'y1') {
          v1y = val;
        } else if (name == 'v2x' || name == 'x2') {
          v2x = val;
        } else if (name == 'v2y' || name == 'y2') {
          v2y = val;
        } else if (name == 'c1') {
          c1 = val;
        } else if (name == 'c2') {
          c2 = val;
        }
      }
    }

    _v1 = _Vec2(v1x.clamp(-5.0, 5.0), v1y.clamp(-5.0, 5.0));
    _v2 = _Vec2(v2x.clamp(-5.0, 5.0), v2y.clamp(-5.0, 5.0));
    _c1 = c1.clamp(-3.0, 3.0);
    _c2 = c2.clamp(-3.0, 3.0);
  }

  @override
  void didUpdateWidget(covariant Vector2DSimulationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      setState(() {
        _initParameters();
      });
    }
  }

  void _toggleAutoAnimation() {
    setState(() {
      _isAutoAnimating = !_isAutoAnimating;
      if (_isAutoAnimating) {
        _animController.repeat();
      } else {
        _animController.stop();
      }
    });
  }

  void _onAnimationTick() {
    if (!_isAutoAnimating) return;
    final angle = _animController.value * 2 * math.pi;
    final r1 = _v1.length;
    setState(() {
      _v1 = _Vec2(
        (r1 * math.cos(angle)).clamp(-5.0, 5.0),
        (r1 * math.sin(angle)).clamp(-5.0, 5.0),
      );
    });
  }

  double _computeScale(Size size) {
    return (size.height / 12.0).clamp(18.0, 26.0);
  }

  Offset _toPixel(_Vec2 v, Offset center, double scale) {
    return Offset(center.dx + v.x * scale, center.dy - v.y * scale);
  }

  _Vec2 _toMath(Offset p, Offset center, double scale) {
    return _Vec2((p.dx - center.dx) / scale, -(p.dy - center.dy) / scale);
  }

  void _onPanStart(Offset localPos, Size size) {
    if (_draggedIndex != null) return;
    if (_isAutoAnimating) {
      _toggleAutoAnimation();
    }
    final center = Offset(size.width / 2, size.height / 2);
    final scale = _computeScale(size);
    final p1 = _toPixel(_v1, center, scale);
    const hitRadius = 32.0;

    final d1 = (localPos - p1).distance;
    if (_currentMode == VectorViewMode.components) {
      if (d1 <= hitRadius) {
        _draggedIndex = 1;
      } else {
        _draggedIndex = null;
      }
    } else {
      final p2 = _toPixel(_v2, center, scale);
      final d2 = (localPos - p2).distance;
      if (d1 <= hitRadius && d2 <= hitRadius) {
        _draggedIndex = d1 <= d2 ? 1 : 2;
      } else if (d1 <= hitRadius) {
        _draggedIndex = 1;
      } else if (d2 <= hitRadius) {
        _draggedIndex = 2;
      } else {
        _draggedIndex = null;
      }
    }
  }

  void _onPanUpdate(Offset localPos, Size size) {
    if (_draggedIndex == null) return;
    final center = Offset(size.width / 2, size.height / 2);
    final scale = _computeScale(size);
    var mathPos = _toMath(localPos, center, scale);

    mathPos = mathPos.clamp(-5.0, 5.0);

    // Snap sottile agli interi per precisione touch
    final rx = mathPos.x.roundToDouble();
    final ry = mathPos.y.roundToDouble();
    if ((mathPos.x - rx).abs() < 0.15) mathPos = _Vec2(rx, mathPos.y);
    if ((mathPos.y - ry).abs() < 0.15) mathPos = _Vec2(mathPos.x, ry);

    setState(() {
      if (_draggedIndex == 1) {
        _v1 = mathPos;
      } else if (_draggedIndex == 2) {
        _v2 = mathPos;
      }
    });
  }

  void _onPanEnd(DragEndDetails? details) {
    setState(() {
      _draggedIndex = null;
    });
  }

  @override
  void dispose() {
    _animController.removeListener(_onAnimationTick);
    _animController.dispose();
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
          // Header con Titolo, Selettore Modalità e Tasto Animazione
          _buildHeader(),
          const SizedBox(height: 14),

          // Modalità Tab Selector (Componenti, Somma, Span & Base)
          _buildModeSelector(),
          const SizedBox(height: 14),

          // Canvas Cartesiano Interattivo con GestureDetector a 60 FPS
          _buildInteractiveCanvas(),
          const SizedBox(height: 16),

          // Telemetria Matematica Dinamica per Modalità
          _buildTelemetrySection(),
          const SizedBox(height: 14),

          // Controlli Interattivi Slider
          _buildControlsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.alt_route_rounded,
                  color: Color(0xFF38BDF8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Flexible(
                child: Text(
                  'Vettori 2D & Algebra Lineare',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _toggleAutoAnimation,
          tooltip:
              _isAutoAnimating ? 'Ferma rotazione' : 'Auto-rotazione vettori',
          icon: Icon(
            _isAutoAnimating
                ? Icons.pause_circle_rounded
                : Icons.play_circle_fill_rounded,
            color: _isAutoAnimating
                ? const Color(0xFFFBBF24)
                : const Color(0xFF38BDF8),
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14171A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2D3238)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildModeTabItem(
            label: 'Componenti',
            icon: Icons.square_foot_rounded,
            mode: VectorViewMode.components,
          ),
          _buildModeTabItem(
            label: 'Somma',
            icon: Icons.add_circle_outline_rounded,
            mode: VectorViewMode.addition,
          ),
          _buildModeTabItem(
            label: 'Span & Base',
            icon: Icons.grid_goldenratio_rounded,
            mode: VectorViewMode.span,
          ),
        ],
      ),
    );
  }

  Widget _buildModeTabItem({
    required String label,
    required IconData icon,
    required VectorViewMode mode,
  }) {
    final isSelected = _currentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentMode = mode;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2D3238) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: isSelected
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasSize = Size(constraints.maxWidth, 280);
        return Stack(
          children: [
            Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (e) => _onPanStart(e.localPosition, canvasSize),
              onPointerMove: (e) => _onPanUpdate(e.localPosition, canvasSize),
              onPointerUp: (e) => _onPanEnd(null),
              onPointerCancel: (e) => _onPanEnd(null),
              child: GestureDetector(
                onPanStart: (d) => _onPanStart(d.localPosition, canvasSize),
                onPanUpdate: (d) => _onPanUpdate(d.localPosition, canvasSize),
                onPanEnd: _onPanEnd,
                onTapDown: (d) => _onPanStart(d.localPosition, canvasSize),
                child: SizedBox(
                  height: 280,
                  width: constraints.maxWidth,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: const Color(0xFF0F172A),
                      child: CustomPaint(
                        painter: _Vector2DPainter(
                          mode: _currentMode,
                          v1: _v1,
                          v2: _v2,
                          c1: _c1,
                          c2: _c2,
                          useParallelogram: _useParallelogram,
                          draggedIndex: _draggedIndex,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xCC000000),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Trascina le punte dei vettori sul piano',
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
    );
  }

  Widget _buildTelemetrySection() {
    switch (_currentMode) {
      case VectorViewMode.components:
        return _buildComponentsTelemetry();
      case VectorViewMode.addition:
        return _buildAdditionTelemetry();
      case VectorViewMode.span:
        return _buildSpanTelemetry();
    }
  }

  Widget _buildComponentsTelemetry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                label: 'Norma ||v₁||',
                value: _v1.length.toStringAsFixed(2),
                color: const Color(0xFF38BDF8),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                label: 'Angolo θ',
                value:
                    '${_v1.angleDeg.toStringAsFixed(1)}° (${_v1.angle.toStringAsFixed(2)} rad)',
                color: const Color(0xFFA855F7),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                label: 'Coordinate',
                value: 'v₁ = (${_v1.x.toStringAsFixed(1)}, ${_v1.y.toStringAsFixed(1)})',
                color: const Color(0xFFFBBF24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF14171A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2D3238)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 16,
                color: Color(0xFF4ADE80),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Base canonica: v₁ = ${_v1.x.toStringAsFixed(1)} e₁ + ${_v1.y.toStringAsFixed(1)} e₂ (e₁=(1,0), e₂=(0,1))',
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
      ],
    );
  }

  Widget _buildAdditionTelemetry() {
    final sum = _v1 + _v2;
    final normSum = sum.length;
    final sumNorms = _v1.length + _v2.length;
    final isCollinearDirection = (_v1.cross(_v2).abs() < 0.05) &&
        (_v1.dot(_v2) >= 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                label: '||v₁||',
                value: _v1.length.toStringAsFixed(2),
                color: const Color(0xFF38BDF8),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                label: '||v₂||',
                value: _v2.length.toStringAsFixed(2),
                color: const Color(0xFFFBBF24),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                label: '||v₁ + v₂||',
                value: normSum.toStringAsFixed(2),
                color: const Color(0xFFF43F5E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF14171A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2D3238)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Risultante s = v₁ + v₂ = (${sum.x.toStringAsFixed(1)}, ${sum.y.toStringAsFixed(1)})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF43F5E),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Disuguaglianza Triangolare: ${normSum.toStringAsFixed(2)} ≤ ${sumNorms.toStringAsFixed(2)} ${isCollinearDirection ? '(Uguaglianza: vettori equiversi)' : '(Soddisfatta)'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFCBD5E1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpanTelemetry() {
    final det = _v1.cross(_v2);
    final isCollinear = det.abs() < 0.05;
    final w = (_v1 * _c1) + (_v2 * _c2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                label: 'Determinante det(v₁,v₂)',
                value: det.toStringAsFixed(2),
                color: isCollinear
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF22C55E),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                label: 'Area Span |det|',
                value: det.abs().toStringAsFixed(2),
                color: const Color(0xFFA855F7),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                label: 'Risultante w',
                value: '(${w.x.toStringAsFixed(1)}, ${w.y.toStringAsFixed(1)})',
                color: const Color(0xFF38BDF8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isCollinear
                ? const Color(0x25EF4444)
                : const Color(0x2022C55E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCollinear
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF22C55E),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isCollinear
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_rounded,
                size: 18,
                color: isCollinear
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF22C55E),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isCollinear
                      ? 'Attenzione: Vettori Collineari (det = 0). Lo Span degenera in una retta (sottospazio 1D)!'
                      : 'Linearmente Indipendenti: Span(v₁, v₂) = ℝ² (Base di ℝ²) — Area = ${det.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isCollinear
                        ? const Color(0xFFFCA5A5)
                        : const Color(0xFF86EFAC),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF14171A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF2D3238)),
                ),
                child: Text(
                  'v₁ = (${_v1.x.toStringAsFixed(1)}, ${_v1.y.toStringAsFixed(1)})',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF38BDF8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF14171A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF2D3238)),
                ),
                child: Text(
                  'v₂ = (${_v2.x.toStringAsFixed(1)}, ${_v2.y.toStringAsFixed(1)})',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFBBF24),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF14171A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2D3238)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsSection() {
    switch (_currentMode) {
      case VectorViewMode.components:
        return Column(
          children: [
            _buildSliderRow(
              label: 'Componente v₁ₓ (Ascissa)',
              value: _v1.x,
              min: -5.0,
              max: 5.0,
              color: const Color(0xFF38BDF8),
              onChanged: (val) {
                setState(() {
                  _v1 = _Vec2(val, _v1.y);
                });
              },
            ),
            const SizedBox(height: 8),
            _buildSliderRow(
              label: 'Componente v₁ᵧ (Ordinata)',
              value: _v1.y,
              min: -5.0,
              max: 5.0,
              color: const Color(0xFFFBBF24),
              onChanged: (val) {
                setState(() {
                  _v1 = _Vec2(_v1.x, val);
                });
              },
            ),
          ],
        );
      case VectorViewMode.addition:
        return Column(
          children: [
            // Toggle tra Regola del Parallelogramma e Punta-Coda
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                const Text(
                  'Metodo di Somma Grafica:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
                Wrap(
                  spacing: 6,
                  children: [
                    ChoiceChip(
                      label: const Text('Parallelogramma'),
                      selected: _useParallelogram,
                      selectedColor: const Color(0xFF2D3238),
                      backgroundColor: const Color(0xFF14171A),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color: _useParallelogram
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF94A3B8),
                        fontWeight: _useParallelogram
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        setState(() {
                          _useParallelogram = true;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Punta-Coda'),
                      selected: !_useParallelogram,
                      selectedColor: const Color(0xFF2D3238),
                      backgroundColor: const Color(0xFF14171A),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color: !_useParallelogram
                            ? const Color(0xFFF43F5E)
                            : const Color(0xFF94A3B8),
                        fontWeight: !_useParallelogram
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        setState(() {
                          _useParallelogram = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildSliderRow(
              label: 'v₁ₓ',
              value: _v1.x,
              min: -5.0,
              max: 5.0,
              color: const Color(0xFF38BDF8),
              onChanged: (val) => setState(() => _v1 = _Vec2(val, _v1.y)),
            ),
            _buildSliderRow(
              label: 'v₁ᵧ',
              value: _v1.y,
              min: -5.0,
              max: 5.0,
              color: const Color(0xFF38BDF8),
              onChanged: (val) => setState(() => _v1 = _Vec2(_v1.x, val)),
            ),
            _buildSliderRow(
              label: 'v₂ₓ',
              value: _v2.x,
              min: -5.0,
              max: 5.0,
              color: const Color(0xFFFBBF24),
              onChanged: (val) => setState(() => _v2 = _Vec2(val, _v2.y)),
            ),
            _buildSliderRow(
              label: 'v₂ᵧ',
              value: _v2.y,
              min: -5.0,
              max: 5.0,
              color: const Color(0xFFFBBF24),
              onChanged: (val) => setState(() => _v2 = _Vec2(_v2.x, val)),
            ),
          ],
        );
      case VectorViewMode.span:
        return Column(
          children: [
            // Scalari c1 e c2
            _buildSliderRow(
              label: 'Scalare c₁ (per v₁)',
              value: _c1,
              min: -3.0,
              max: 3.0,
              step: 0.1,
              color: const Color(0xFF38BDF8),
              onChanged: (val) => setState(() => _c1 = val),
            ),
            _buildSliderRow(
              label: 'Scalare c₂ (per v₂)',
              value: _c2,
              min: -3.0,
              max: 3.0,
              step: 0.1,
              color: const Color(0xFFFBBF24),
              onChanged: (val) => setState(() => _c2 = val),
            ),
            const SizedBox(height: 8),
            // Preset configurazioni didattiche
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildPresetChip('c=(1, 1)', 1.0, 1.0),
                _buildPresetChip('c=(2, -1)', 2.0, -1.0),
                _buildPresetChip('c=(-1, 2)', -1.0, 2.0),
                _buildPresetChip('c=(0.5, 0.5)', 0.5, 0.5),
                _buildPresetChip('c=(0, 0)', 0.0, 0.0),
              ],
            ),
          ],
        );
    }
  }

  Widget _buildPresetChip(String label, double c1, double c2) {
    final isSelected = (_c1 - c1).abs() < 0.01 && (_c2 - c2).abs() < 0.01;
    return ActionChip(
      label: Text(label),
      backgroundColor: isSelected ? const Color(0xFF2D3238) : const Color(0xFF14171A),
      labelStyle: TextStyle(
        fontSize: 11,
        color: isSelected ? const Color(0xFFA855F7) : const Color(0xFFCBD5E1),
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
      ),
      onPressed: () {
        setState(() {
          _c1 = c1;
          _c2 = c2;
        });
      },
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    double step = 0.5,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    final clamped = value.clamp(min, max);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                clamped.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: const Color(0xFF2D3238),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.15),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: clamped,
              min: min,
              max: max,
              onChanged: (v) => onChanged(v.clamp(min, max)),
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter a 60 FPS per la renderizzazione geometrica di assi cartesiani, griglia,
/// vettori con frecce direzionali, aree parallelogramma, proiezioni e rette di collinearità.
class _Vector2DPainter extends CustomPainter {
  final VectorViewMode mode;
  final _Vec2 v1;
  final _Vec2 v2;
  final double c1;
  final double c2;
  final bool useParallelogram;
  final int? draggedIndex;

  _Vector2DPainter({
    required this.mode,
    required this.v1,
    required this.v2,
    required this.c1,
    required this.c2,
    required this.useParallelogram,
    required this.draggedIndex,
  });

  double _computeScale(Size size) {
    return (size.height / 12.0).clamp(18.0, 26.0);
  }

  Offset _toPixel(_Vec2 v, Offset center, double scale) {
    return Offset(center.dx + v.x * scale, center.dy - v.y * scale);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = _computeScale(size);

    _drawGrid(canvas, size, center, scale);
    _drawAxes(canvas, size, center, scale);

    switch (mode) {
      case VectorViewMode.components:
        _paintComponentsMode(canvas, center, scale);
        break;
      case VectorViewMode.addition:
        _paintAdditionMode(canvas, center, scale);
        break;
      case VectorViewMode.span:
        _paintSpanMode(canvas, center, scale);
        break;
    }
  }

  void _drawGrid(Canvas canvas, Size size, Offset center, double scale) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 1.0;

    for (double x = -6.0; x <= 6.0; x += 1.0) {
      final px = center.dx + x * scale;
      if (px >= 0 && px <= size.width) {
        canvas.drawLine(Offset(px, 0), Offset(px, size.height), gridPaint);
      }
    }

    for (double y = -6.0; y <= 6.0; y += 1.0) {
      final py = center.dy - y * scale;
      if (py >= 0 && py <= size.height) {
        canvas.drawLine(Offset(0, py), Offset(size.width, py), gridPaint);
      }
    }
  }

  void _drawAxes(Canvas canvas, Size size, Offset center, double scale) {
    final axesPaint = Paint()
      ..color = const Color(0xFF475569)
      ..strokeWidth = 1.5;

    // Asse X e Y
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), axesPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), axesPaint);

    // Tacche numeriche principali
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    const textStyle = TextStyle(
      fontSize: 9,
      color: Color(0xFF64748B),
      fontWeight: FontWeight.w600,
    );

    for (final tick in [-4, -2, 2, 4]) {
      final tx = center.dx + tick * scale;
      if (tx >= 10 && tx <= size.width - 10) {
        canvas.drawLine(
          Offset(tx, center.dy - 3),
          Offset(tx, center.dy + 3),
          axesPaint,
        );
        textPainter.text = TextSpan(text: '$tick', style: textStyle);
        textPainter.layout();
        textPainter.paint(canvas, Offset(tx - textPainter.width / 2, center.dy + 4));
      }

      final ty = center.dy - tick * scale;
      if (ty >= 10 && ty <= size.height - 10) {
        canvas.drawLine(
          Offset(center.dx - 3, ty),
          Offset(center.dx + 3, ty),
          axesPaint,
        );
        textPainter.text = TextSpan(text: '$tick', style: textStyle);
        textPainter.layout();
        textPainter.paint(canvas, Offset(center.dx + 6, ty - textPainter.height / 2));
      }
    }

    // Etichette assi x e y
    textPainter.text = const TextSpan(
      text: '+x',
      style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - textPainter.width - 6, center.dy - 14));

    textPainter.text = const TextSpan(
      text: '+y',
      style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx + 6, 6));
  }

  void _paintComponentsMode(Canvas canvas, Offset center, double scale) {
    final p1 = _toPixel(v1, center, scale);
    final px = _toPixel(_Vec2(v1.x, 0), center, scale);
    final py = _toPixel(_Vec2(0, v1.y), center, scale);

    // Linee di proiezione tratteggiate
    final projPaintX = Paint()
      ..color = const Color(0xFFFBBF24).withValues(alpha: 0.6)
      ..strokeWidth = 1.2;
    final projPaintY = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.6)
      ..strokeWidth = 1.2;

    _drawDashedLine(canvas, px, p1, projPaintX);
    _drawDashedLine(canvas, py, p1, projPaintY);

    // Componente x lungo l'asse
    _drawArrow(
      canvas,
      center,
      px,
      const Color(0xFF38BDF8),
      strokeWidth: 2.2,
      label: 'v₁ₓ e₁',
      showHandle: false,
    );

    // Componente y lungo l'asse
    _drawArrow(
      canvas,
      center,
      py,
      const Color(0xFFFBBF24),
      strokeWidth: 2.2,
      label: 'v₁ᵧ e₂',
      showHandle: false,
    );

    // Arco per angolo theta
    if (v1.length > 0.4) {
      final arcPaint = Paint()
        ..color = const Color(0xFFA855F7).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final rect = Rect.fromCircle(center: center, radius: 26.0);
      final sweepAngle = -v1.angle; // Invertito per coordinate canvas
      canvas.drawArc(rect, 0, sweepAngle, false, arcPaint);
    }

    // Vettore v1 principale
    _drawArrow(
      canvas,
      center,
      p1,
      const Color(0xFF38BDF8),
      strokeWidth: 3.5,
      label: 'v₁',
      showHandle: true,
      isHighlighted: draggedIndex == 1,
    );
  }

  void _paintAdditionMode(Canvas canvas, Offset center, double scale) {
    final p1 = _toPixel(v1, center, scale);
    final p2 = _toPixel(v2, center, scale);
    final sum = v1 + v2;
    final pSum = _toPixel(sum, center, scale);

    if (useParallelogram) {
      // Area parallelogramma
      final polyPath = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(pSum.dx, pSum.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close();

      final fillPaint = Paint()
        ..color = const Color(0xFFF43F5E).withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawPath(polyPath, fillPaint);

      // Lati tratteggiati paralleli
      final dashPaintV2 = Paint()
        ..color = const Color(0xFFFBBF24).withValues(alpha: 0.8)
        ..strokeWidth = 1.8;
      final dashPaintV1 = Paint()
        ..color = const Color(0xFF38BDF8).withValues(alpha: 0.8)
        ..strokeWidth = 1.8;

      _drawDashedLine(canvas, p1, pSum, dashPaintV2);
      _drawDashedLine(canvas, p2, pSum, dashPaintV1);
    } else {
      // Metodo Punta-Coda: v2 traslato sulla punta di v1
      _drawArrow(
        canvas,
        p1,
        pSum,
        const Color(0xFFFBBF24).withValues(alpha: 0.85),
        strokeWidth: 2.2,
        label: "v₂'",
        dashed: true,
        showHandle: false,
      );
    }

    // Vettore v1
    _drawArrow(
      canvas,
      center,
      p1,
      const Color(0xFF38BDF8),
      strokeWidth: 3.0,
      label: 'v₁',
      showHandle: true,
      isHighlighted: draggedIndex == 1,
    );

    // Vettore v2
    _drawArrow(
      canvas,
      center,
      p2,
      const Color(0xFFFBBF24),
      strokeWidth: 3.0,
      label: 'v₂',
      showHandle: true,
      isHighlighted: draggedIndex == 2,
    );

    // Vettore Risultante s = v1 + v2
    _drawArrow(
      canvas,
      center,
      pSum,
      const Color(0xFFF43F5E),
      strokeWidth: 3.8,
      label: 's = v₁ + v₂',
      showHandle: false,
    );
  }

  void _paintSpanMode(Canvas canvas, Offset center, double scale) {
    final det = v1.cross(v2);
    final isCollinear = det.abs() < 0.05;

    final p1 = _toPixel(v1, center, scale);
    final p2 = _toPixel(v2, center, scale);

    final w1 = v1 * c1;
    final w2 = v2 * c2;
    final w = w1 + w2;

    final pw1 = _toPixel(w1, center, scale);
    final pw2 = _toPixel(w2, center, scale);
    final pw = _toPixel(w, center, scale);

    if (isCollinear) {
      // Disegna la retta dello Span (sottospazio unidimensionale)
      final refVec = v1.length >= v2.length ? v1 : v2;
      if (refVec.length > 0.05) {
        final dir = _Vec2(refVec.x / refVec.length, refVec.y / refVec.length);
        final lineP1 = _toPixel(dir * -10.0, center, scale);
        final lineP2 = _toPixel(dir * 10.0, center, scale);

        final spanLinePaint = Paint()
          ..color = const Color(0xFFEF4444).withValues(alpha: 0.65)
          ..strokeWidth = 2.0;
        _drawDashedLine(canvas, lineP1, lineP2, spanLinePaint, dashLength: 8, spaceLength: 4);
      }
    } else {
      // Area parallelogramma dello Span(v1, v2)
      final pSumBase = _toPixel(v1 + v2, center, scale);
      final spanPath = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(pSumBase.dx, pSumBase.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close();

      final spanPaint = Paint()
        ..color = const Color(0xFF6366F1).withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      canvas.drawPath(spanPath, spanPaint);

      // Bordo tratteggiato
      final spanEdgePaint = Paint()
        ..color = const Color(0xFF818CF8).withValues(alpha: 0.5)
        ..strokeWidth = 1.2;
      _drawDashedLine(canvas, p1, pSumBase, spanEdgePaint);
      _drawDashedLine(canvas, p2, pSumBase, spanEdgePaint);
    }

    // Vettori scalati se diversi da c=1
    if ((c1 - 1.0).abs() > 0.05) {
      _drawArrow(
        canvas,
        center,
        pw1,
        const Color(0xFF38BDF8).withValues(alpha: 0.7),
        strokeWidth: 2.2,
        label: 'c₁ v₁',
        dashed: true,
        showHandle: false,
      );
    }
    if ((c2 - 1.0).abs() > 0.05) {
      _drawArrow(
        canvas,
        center,
        pw2,
        const Color(0xFFFBBF24).withValues(alpha: 0.7),
        strokeWidth: 2.2,
        label: 'c₂ v₂',
        dashed: true,
        showHandle: false,
      );
    }

    // Vettore v1 originale con handle
    _drawArrow(
      canvas,
      center,
      p1,
      const Color(0xFF38BDF8),
      strokeWidth: 3.0,
      label: 'v₁',
      showHandle: true,
      isHighlighted: draggedIndex == 1,
    );

    // Vettore v2 originale con handle
    _drawArrow(
      canvas,
      center,
      p2,
      const Color(0xFFFBBF24),
      strokeWidth: 3.0,
      label: 'v₂',
      showHandle: true,
      isHighlighted: draggedIndex == 2,
    );

    // Vettore combinazione lineare w = c1*v1 + c2*v2
    _drawArrow(
      canvas,
      center,
      pw,
      const Color(0xFFA855F7),
      strokeWidth: 3.6,
      label: 'w',
      showHandle: false,
    );
  }

  void _drawArrow(
    Canvas canvas,
    Offset from,
    Offset to,
    Color color, {
    double strokeWidth = 3.0,
    String? label,
    bool dashed = false,
    bool showHandle = false,
    bool isHighlighted = false,
  }) {
    final delta = to - from;
    final dist = delta.distance;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (dist < 3.0) {
      // Punto nullo
      canvas.drawCircle(from, 3.0, linePaint);
      return;
    }

    if (dashed) {
      _drawDashedLine(canvas, from, to, linePaint);
    } else {
      canvas.drawLine(from, to, linePaint);
    }

    // Freccia direzionale
    final angle = math.atan2(delta.dy, delta.dx);
    const arrowLen = 12.0;
    const arrowSpread = 0.42;

    final pLeft = to - Offset(math.cos(angle - arrowSpread), math.sin(angle - arrowSpread)) * arrowLen;
    final pRight = to - Offset(math.cos(angle + arrowSpread), math.sin(angle + arrowSpread)) * arrowLen;

    final arrowPath = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(pLeft.dx, pLeft.dy)
      ..lineTo(pRight.dx, pRight.dy)
      ..close();

    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(arrowPath, arrowPaint);

    // Handle touch interattivo alla punta
    if (showHandle) {
      final auraPaint = Paint()
        ..color = isHighlighted
            ? color.withValues(alpha: 0.5)
            : color.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(to, isHighlighted ? 15.0 : 11.0, auraPaint);

      final handleRingPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;
      canvas.drawCircle(to, 5.0, handleRingPaint);

      final handleCenterPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(to, 2.0, handleCenterPaint);
    }

    // Etichetta testuale leggibile
    if (label != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final textPos = to + Offset(math.cos(angle) * 8, math.sin(angle) * 8);

      // Sfondo protettivo per contrasto
      final bgRect = Rect.fromCenter(
        center: textPos + Offset(textPainter.width / 2, textPainter.height / 2),
        width: textPainter.width + 8,
        height: textPainter.height + 4,
      );
      final bgPaint = Paint()
        ..color = const Color(0xCC0F172A)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(4)), bgPaint);

      textPainter.paint(canvas, textPos);
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint, {
    double dashLength = 5.0,
    double spaceLength = 3.0,
  }) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    if (distance < 1e-4) return;
    final unitX = dx / distance;
    final unitY = dy / distance;
    double current = 0.0;
    while (current < distance) {
      final start = Offset(p1.dx + unitX * current, p1.dy + unitY * current);
      final len = math.min(dashLength, distance - current);
      final end = Offset(start.dx + unitX * len, start.dy + unitY * len);
      canvas.drawLine(start, end, paint);
      current += dashLength + spaceLength;
    }
  }

  @override
  bool shouldRepaint(covariant _Vector2DPainter oldDelegate) {
    return oldDelegate.mode != mode ||
        oldDelegate.v1.x != v1.x ||
        oldDelegate.v1.y != v1.y ||
        oldDelegate.v2.x != v2.x ||
        oldDelegate.v2.y != v2.y ||
        oldDelegate.c1 != c1 ||
        oldDelegate.c2 != c2 ||
        oldDelegate.useParallelogram != useParallelogram ||
        oldDelegate.draggedIndex != draggedIndex;
  }
}
