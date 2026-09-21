import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../domain/models/university_course_model.dart';

/// Widget dedicato al rendering grafico statico dei concetti matematici del professore.
/// Fornisce rappresentazioni visuali chiare (mappe a frecce, partizioni, quadranti modulari, ecc.)
class TermVisualExampleWidget extends StatelessWidget {
  final VisualDiagramType diagramType;
  final String title;

  const TermVisualExampleWidget({
    super.key,
    required this.diagramType,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Slate 900
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header del diagramma
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_graph_rounded,
                  size: 16,
                  color: Color(0xFF38BDF8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF1F5F9),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withAlpha(40),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Visualizzazione Statica',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Canvas di disegno
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _DiagramPainter(diagramType),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagramPainter extends CustomPainter {
  final VisualDiagramType type;

  _DiagramPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case VisualDiagramType.arrowMappingInjective:
        _paintInjectiveMapping(canvas, size);
        break;
      case VisualDiagramType.arrowMappingSurjective:
        _paintSurjectiveMapping(canvas, size);
        break;
      case VisualDiagramType.arrowMappingBijective:
        _paintBijectiveMapping(canvas, size);
        break;
      case VisualDiagramType.partitionBubbles:
      case VisualDiagramType.quotientBlocks:
        _paintPartitionDiagram(canvas, size);
        break;
      case VisualDiagramType.moduloClock:
        _paintModuloClock(canvas, size);
        break;
      case VisualDiagramType.cycleGraph:
        _paintCycleGraph(canvas, size);
        break;
      case VisualDiagramType.truthTableImplication:
      case VisualDiagramType.contrapositiveMatrix:
      case VisualDiagramType.truthValueDiagram:
        _paintTruthMatrix(canvas, size);
        break;
      case VisualDiagramType.cayleyTableGrid:
        _paintCayleyTable(canvas, size);
        break;
      case VisualDiagramType.subsetsLattice:
        _paintSubsetsLattice(canvas, size);
        break;
      case VisualDiagramType.cartesianGrid:
        _paintCartesianGrid(canvas, size);
        break;
      case VisualDiagramType.divisionTimeline:
        _paintDivisionTimeline(canvas, size);
        break;
      case VisualDiagramType.euclideanLadder:
        _paintEuclideanLadder(canvas, size);
        break;
      case VisualDiagramType.fieldStar:
        _paintFieldStar(canvas, size);
        break;
      case VisualDiagramType.commutativeDiagram:
        _paintCommutativeDiagram(canvas, size);
        break;
      default:
        _paintGenericDiagram(canvas, size);
        break;
    }
  }

  // --- 1. MAPPATURA INIETTIVA (Frecce distinte su elementi distinti) ---
  void _paintInjectiveMapping(Canvas canvas, Size size) {
    final leftX = size.width * 0.25;
    final rightX = size.width * 0.75;
    _drawSetCapsule(canvas, Rect.fromCenter(center: Offset(leftX, size.height * 0.5), width: 70, height: 140), 'Dominio A', const Color(0xFF38BDF8));
    _drawSetCapsule(canvas, Rect.fromCenter(center: Offset(rightX, size.height * 0.5), width: 70, height: 170), 'Codominio B', const Color(0xFF4ADE80));

    final aPoints = [
      Offset(leftX, size.height * 0.32),
      Offset(leftX, size.height * 0.50),
      Offset(leftX, size.height * 0.68),
    ];
    final bPoints = [
      Offset(rightX, size.height * 0.24),
      Offset(rightX, size.height * 0.42),
      Offset(rightX, size.height * 0.60),
      Offset(rightX, size.height * 0.78), // Elemento non raggiunto (iniettiva non suriettiva)
    ];

    // Nodi
    for (int i = 0; i < aPoints.length; i++) {
      _drawNode(canvas, aPoints[i], 'a${i + 1}', const Color(0xFF38BDF8));
    }
    for (int i = 0; i < bPoints.length; i++) {
      final isHit = i < 3;
      _drawNode(canvas, bPoints[i], 'b${i + 1}', isHit ? const Color(0xFF4ADE80) : const Color(0xFF94A3B8));
    }

    // Frecce 1-a-1
    _drawArrow(canvas, aPoints[0], bPoints[0], const Color(0xFF38BDF8));
    _drawArrow(canvas, aPoints[1], bPoints[1], const Color(0xFF38BDF8));
    _drawArrow(canvas, aPoints[2], bPoints[2], const Color(0xFF38BDF8));

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Fibre: |f⁻¹(b)| ≤ 1 (ogni elemento ha al più una controimmagine)');
  }

  // --- 2. MAPPATURA SURIETTIVA (Ogni elemento di B è raggiunto) ---
  void _paintSurjectiveMapping(Canvas canvas, Size size) {
    final leftX = size.width * 0.25;
    final rightX = size.width * 0.75;
    _drawSetCapsule(canvas, Rect.fromCenter(center: Offset(leftX, size.height * 0.5), width: 70, height: 160), 'Dominio A', const Color(0xFF38BDF8));
    _drawSetCapsule(canvas, Rect.fromCenter(center: Offset(rightX, size.height * 0.5), width: 70, height: 120), 'Codominio B', const Color(0xFFA855F7));

    final aPoints = [
      Offset(leftX, size.height * 0.25),
      Offset(leftX, size.height * 0.42),
      Offset(leftX, size.height * 0.58),
      Offset(leftX, size.height * 0.75),
    ];
    final bPoints = [
      Offset(rightX, size.height * 0.35),
      Offset(rightX, size.height * 0.65),
    ];

    for (int i = 0; i < aPoints.length; i++) {
      _drawNode(canvas, aPoints[i], 'a${i + 1}', const Color(0xFF38BDF8));
    }
    for (int i = 0; i < bPoints.length; i++) {
      _drawNode(canvas, bPoints[i], 'b${i + 1}', const Color(0xFFA855F7));
    }

    _drawArrow(canvas, aPoints[0], bPoints[0], const Color(0xFF38BDF8));
    _drawArrow(canvas, aPoints[1], bPoints[0], const Color(0xFF38BDF8)); // Collisione ammessa
    _drawArrow(canvas, aPoints[2], bPoints[1], const Color(0xFF38BDF8));
    _drawArrow(canvas, aPoints[3], bPoints[1], const Color(0xFF38BDF8));

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Im(f) = B: tutti gli elementi di B sono raggiunti (|f⁻¹(b)| ≥ 1)');
  }

  // --- 3. MAPPATURA BIIETTIVA (Iniettiva + Suriettiva = Invertibile) ---
  void _paintBijectiveMapping(Canvas canvas, Size size) {
    final leftX = size.width * 0.25;
    final rightX = size.width * 0.75;
    _drawSetCapsule(canvas, Rect.fromCenter(center: Offset(leftX, size.height * 0.5), width: 70, height: 140), 'Dominio A', const Color(0xFF38BDF8));
    _drawSetCapsule(canvas, Rect.fromCenter(center: Offset(rightX, size.height * 0.5), width: 70, height: 140), 'Codominio B', const Color(0xFFFBBF24));

    final aPoints = [
      Offset(leftX, size.height * 0.32),
      Offset(leftX, size.height * 0.50),
      Offset(leftX, size.height * 0.68),
    ];
    final bPoints = [
      Offset(rightX, size.height * 0.32),
      Offset(rightX, size.height * 0.50),
      Offset(rightX, size.height * 0.68),
    ];

    for (int i = 0; i < aPoints.length; i++) {
      _drawNode(canvas, aPoints[i], 'a${i + 1}', const Color(0xFF38BDF8));
      _drawNode(canvas, bPoints[i], 'b${i + 1}', const Color(0xFFFBBF24));
      _drawArrow(canvas, aPoints[i], bPoints[i], const Color(0xFF38BDF8), isDoubleHeaded: true);
    }

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Corrispondenza biunivoca: |f⁻¹(b)| = 1, esiste inversa f⁻¹: B → A');
  }

  // --- 4. PARTIZIONE E INSIEME QUOZIENTE (M/~) ---
  void _paintPartitionDiagram(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.45), width: size.width * 0.8, height: 110);
    final borderPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), borderPaint);

    final colors = [const Color(0xFF38BDF8), const Color(0xFF4ADE80), const Color(0xFFF43F5E)];
    final classLabels = ['[0] = {..., -3, 0, 3, 6, ...}', '[1] = {..., -2, 1, 4, 7, ...}', '[2] = {..., -1, 2, 5, 8, ...}'];

    final w = rect.width / 3;
    for (int i = 0; i < 3; i++) {
      final subRect = Rect.fromLTWH(rect.left + i * w, rect.top, w, rect.height);
      final fillPaint = Paint()
        ..color = colors[i].withAlpha(30)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(RRect.fromRectAndRadius(subRect, const Radius.circular(12)), fillPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(subRect, const Radius.circular(12)), Paint()..color = colors[i]..style = PaintingStyle.stroke..strokeWidth = 1.2);

      _drawText(canvas, Offset(subRect.center.dx, subRect.top + 20), 'Classe [$i]', colors[i], isBold: true, fontSize: 13);
      _drawText(canvas, Offset(subRect.center.dx, subRect.center.dy + 8), classLabels[i], const Color(0xFFE2E8F0), fontSize: 9);
      _drawText(canvas, Offset(subRect.center.dx, subRect.bottom - 16), 'Rappr: $i', const Color(0xFF94A3B8), fontSize: 10);
    }

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Partizione di ℤ in 3 classi disgiunte: ℤ/~ = {[0], [1], [2]}');
  }

  // --- 5. OROLOGIO MODULARE (ℤ/nℤ) ---
  void _paintModuloClock(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.45);
    const radius = 55.0;

    final circlePaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, circlePaint);

    const int n = 5; // ℤ/5ℤ
    for (int i = 0; i < n; i++) {
      final angle = -math.pi / 2 + (i * 2 * math.pi / n);
      final p = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      _drawNode(canvas, p, '[$i]', const Color(0xFF38BDF8), radius: 14);

      // Arco orario
      final nextAngle = -math.pi / 2 + ((i + 1) * 2 * math.pi / n);
      final pNext = center + Offset(math.cos(nextAngle) * radius, math.sin(nextAngle) * radius);
      _drawCurveArrow(canvas, p, pNext, center, const Color(0xFF0284C7));
    }

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Aritmetica Modulare ℤ/5ℤ: le somme ciclano periodicamente');
  }

  // --- 6. GRAFO DEI CICLI DI PERMUTAZIONE ---
  void _paintCycleGraph(Canvas canvas, Size size) {
    final c1 = Offset(size.width * 0.35, size.height * 0.45);
    final c2 = Offset(size.width * 0.75, size.height * 0.45);

    // 3-ciclo (1 2 3)
    final p1 = c1 + const Offset(0, -35);
    final p2 = c1 + const Offset(30, 25);
    final p3 = c1 + const Offset(-30, 25);
    _drawNode(canvas, p1, '1', const Color(0xFF38BDF8));
    _drawNode(canvas, p2, '2', const Color(0xFF38BDF8));
    _drawNode(canvas, p3, '3', const Color(0xFF38BDF8));
    _drawArrow(canvas, p1, p2, const Color(0xFF38BDF8));
    _drawArrow(canvas, p2, p3, const Color(0xFF38BDF8));
    _drawArrow(canvas, p3, p1, const Color(0xFF38BDF8));
    _drawText(canvas, c1 + const Offset(0, 48), '(1  2  3)', const Color(0xFF38BDF8), isBold: true, fontSize: 12);

    // Punto fisso o 1-ciclo (4)
    _drawNode(canvas, c2, '4', const Color(0xFF4ADE80));
    final loopRect = Rect.fromCircle(center: c2 + const Offset(0, -22), radius: 16);
    canvas.drawArc(loopRect, 0.4, 2 * math.pi - 0.8, false, Paint()..color = const Color(0xFF4ADE80)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawText(canvas, c2 + const Offset(0, 48), '(4) fisso', const Color(0xFF4ADE80), isBold: true, fontSize: 12);

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Decomposizione in cicli disgiunti: σ = (1 2 3)(4)');
  }

  // --- 7. TABELLA DI VERITÀ / MATRICE CONTRAPPOSTA ---
  void _paintTruthMatrix(Canvas canvas, Size size) {
    final startY = size.height * 0.18;
    final rowH = 22.0;
    final colW = size.width * 0.18;
    final startX = size.width * 0.5 - (colW * 4) / 2;

    final headers = ['A', 'B', 'A ⇒ B', '¬B ⇒ ¬A'];
    final rows = [
      ['V', 'V', 'V', 'V'],
      ['V', 'F', 'F', 'F'],
      ['F', 'V', 'V', 'V'],
      ['F', 'F', 'V', 'V'],
    ];

    // Intestazioni
    for (int j = 0; j < headers.length; j++) {
      final p = Offset(startX + j * colW + colW / 2, startY);
      _drawText(canvas, p, headers[j], const Color(0xFF38BDF8), isBold: true, fontSize: 11);
    }

    // Righe
    for (int i = 0; i < rows.length; i++) {
      final y = startY + (i + 1) * rowH;
      final isFauxHypo = i >= 2;
      for (int j = 0; j < rows[i].length; j++) {
        final val = rows[i][j];
        final col = val == 'V' ? const Color(0xFF4ADE80) : const Color(0xFFF43F5E);
        final p = Offset(startX + j * colW + colW / 2, y);
        _drawText(canvas, p, val, col, isBold: isFauxHypo, fontSize: 11);
      }
    }

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Equivalenza logica della contrapposta: le due colonne coincidono');
  }

  // --- 8. TAVOLA DI CAYLEY ---
  void _paintCayleyTable(Canvas canvas, Size size) {
    final startY = size.height * 0.18;
    final step = 24.0;
    final startX = size.width * 0.5 - (step * 5) / 2;

    final table = [
      ['*', 'e', 'a', 'b', 'c'],
      ['e', 'e', 'a', 'b', 'c'],
      ['a', 'a', 'e', 'c', 'b'],
      ['b', 'b', 'c', 'e', 'a'],
      ['c', 'c', 'b', 'a', 'e'],
    ];

    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        final p = Offset(startX + j * step + step / 2, startY + i * step);
        final val = table[i][j];
        final isHeader = i == 0 || j == 0;
        final isNeutral = val == 'e' && !isHeader;
        final color = isHeader
            ? const Color(0xFF38BDF8)
            : isNeutral
                ? const Color(0xFFF59E0B)
                : const Color(0xFFE2E8F0);
        _drawText(canvas, p, val, color, isBold: isHeader || isNeutral, fontSize: 11);
      }
    }

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Tavola di Cayley (Gruppo di Klein ℤ₂ × ℤ₂): elemento neutro e simmetria');
  }

  // --- 9. RETICOLO SOTTOINSIEMI (Insieme delle parti) ---
  void _paintSubsetsLattice(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final top = Offset(cx, size.height * 0.20);
    final mid = [Offset(cx - 70, size.height * 0.42), Offset(cx, size.height * 0.42), Offset(cx + 70, size.height * 0.42)];
    final bot = Offset(cx, size.height * 0.68);

    _drawNode(canvas, top, '{a,b}', const Color(0xFF38BDF8), radius: 15);
    _drawNode(canvas, mid[0], '{a}', const Color(0xFF4ADE80), radius: 13);
    _drawNode(canvas, mid[1], '{b}', const Color(0xFF4ADE80), radius: 13);
    _drawNode(canvas, mid[2], '...', const Color(0xFF94A3B8), radius: 13);
    _drawNode(canvas, bot, '∅', const Color(0xFFF43F5E), radius: 13);

    _drawLine(canvas, bot, mid[0], const Color(0xFF475569));
    _drawLine(canvas, bot, mid[1], const Color(0xFF475569));
    _drawLine(canvas, mid[0], top, const Color(0xFF475569));
    _drawLine(canvas, mid[1], top, const Color(0xFF475569));

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Insieme delle Parti P(M): reticolo di inclusione con 2^|M| elementi');
  }

  // --- 10. PRODOTTO CARTESIANO (Griglia discreta) ---
  void _paintCartesianGrid(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.45;
    final p0 = Offset(cx - 50, cy - 35);

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        final p = p0 + Offset(i * 45.0, j * 32.0);
        _drawNode(canvas, p, '($i,$j)', const Color(0xFF38BDF8), radius: 11, fontSize: 8);
      }
    }

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'M × N = {(m, n) | m ∈ M, n ∈ N}: elenchi ordinati di coppie');
  }

  // --- 11. DIVISIONE CON RESTO (Timeline / Segmenti) ---
  void _paintDivisionTimeline(Canvas canvas, Size size) {
    final y = size.height * 0.45;
    final startX = size.width * 0.15;
    final endX = size.width * 0.85;
    final totalW = endX - startX;

    final linePaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(startX, y), Offset(endX, y), linePaint);

    // Blocchi q * b
    final qW = totalW * 0.28;
    for (int i = 0; i < 3; i++) {
      final rect = Rect.fromLTWH(startX + i * qW, y - 14, qW - 3, 28);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), Paint()..color = const Color(0xFF38BDF8).withAlpha(40));
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), Paint()..color = const Color(0xFF38BDF8)..style = PaintingStyle.stroke..strokeWidth = 1.2);
      _drawText(canvas, rect.center, 'b', const Color(0xFF38BDF8), isBold: true, fontSize: 11);
    }

    // Blocco resto r < b
    final restRect = Rect.fromLTWH(startX + 3 * qW, y - 14, totalW - 3 * qW, 28);
    canvas.drawRRect(RRect.fromRectAndRadius(restRect, const Radius.circular(6)), Paint()..color = const Color(0xFFF59E0B).withAlpha(40));
    canvas.drawRRect(RRect.fromRectAndRadius(restRect, const Radius.circular(6)), Paint()..color = const Color(0xFFF59E0B)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    _drawText(canvas, restRect.center, 'r < b', const Color(0xFFF59E0B), isBold: true, fontSize: 10);

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Teorema: a = q·b + r, con quoziente q e resto unico 0 ≤ r < b');
  }

  // --- 12. ALGORITMO EUCLIDEO (Scala di divisioni) ---
  void _paintEuclideanLadder(Canvas canvas, Size size) {
    final startY = size.height * 0.18;
    final steps = [
      '161 = 5 · 28 + 21',
      ' 28 = 1 · 21 + 7   (ultimo resto ≠ 0)',
      ' 21 = 3 · 7  + 0   ⇒  MCD(161, 28) = 7',
    ];

    for (int i = 0; i < steps.length; i++) {
      final y = startY + i * 26;
      final isFinal = i == 1 || i == 2;
      final color = isFinal ? const Color(0xFF4ADE80) : const Color(0xFFE2E8F0);
      _drawText(canvas, Offset(size.width * 0.5, y), steps[i], color, isBold: isFinal, fontSize: 12);
    }

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Invarianza del MCD: MCD(a, b) = MCD(b, r), termina sempre in passi finiti');
  }

  // --- 13. CAMPO A STELLA (Invertibilità moltiplicativa in F_p) ---
  void _paintFieldStar(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.45);
    const radius = 48.0;
    _drawNode(canvas, center, '0 (no inv)', const Color(0xFF64748B), radius: 14, fontSize: 8);

    const int elements = 4; // F_5* = {1, 2, 3, 4}
    final labels = ['1 (inv 1)', '2 (inv 3)', '3 (inv 2)', '4 (inv 4)'];
    for (int i = 0; i < elements; i++) {
      final angle = i * (2 * math.pi / elements);
      final p = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      _drawNode(canvas, p, labels[i], const Color(0xFF4ADE80), radius: 14, fontSize: 8);
    }

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Campi Finiti F_p: ogni elemento non nullo ammette inverso moltiplicativo');
  }

  // --- 14. DIAGRAMMA COMMUTATIVO (Proprietà Universale) ---
  void _paintCommutativeDiagram(Canvas canvas, Size size) {
    final top = Offset(size.width * 0.5, size.height * 0.22);
    final botLeft = Offset(size.width * 0.30, size.height * 0.62);
    final botRight = Offset(size.width * 0.70, size.height * 0.62);

    _drawNode(canvas, top, 'N', const Color(0xFF38BDF8), radius: 14);
    _drawNode(canvas, botLeft, 'P (Prodotto)', const Color(0xFFFBBF24), radius: 14, fontSize: 8);
    _drawNode(canvas, botRight, 'M_i', const Color(0xFF4ADE80), radius: 14);

    _drawArrow(canvas, top, botRight, const Color(0xFF94A3B8));
    _drawArrow(canvas, botLeft, botRight, const Color(0xFF94A3B8));
    _drawArrow(canvas, top, botLeft, const Color(0xFF38BDF8), isDashed: true);

    _drawText(canvas, Offset(size.width * 0.35, size.height * 0.38), '∃! u', const Color(0xFF38BDF8), isBold: true, fontSize: 11);
    _drawText(canvas, Offset(size.width * 0.65, size.height * 0.38), 'u_i', const Color(0xFF94A3B8), fontSize: 11);
    _drawText(canvas, Offset(size.width * 0.50, size.height * 0.68), 'p_i', const Color(0xFF94A3B8), fontSize: 11);

    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Proprietà Universale: p_i ∘ u = u_i (il morfismo u esiste ed è unico)');
  }

  // --- FALLBACK GENERICO ---
  void _paintGenericDiagram(Canvas canvas, Size size) {
    final c = Offset(size.width * 0.5, size.height * 0.45);
    _drawNode(canvas, c, 'Definizione Formale', const Color(0xFF38BDF8), radius: 24, fontSize: 10);
    _drawCaption(canvas, Offset(size.width * 0.5, size.height * 0.90), 'Rappresentazione rigorosa dei concetti del Politecnico di Milano');
  }

  // ==========================================================================
  // METODI DI SUPPORTO GRAFICO
  // ==========================================================================
  void _drawSetCapsule(Canvas canvas, Rect rect, String label, Color color) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(rect.width / 2));
    final fillPaint = Paint()
      ..color = color.withAlpha(20)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = color.withAlpha(120)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRRect(rrect, fillPaint);
    canvas.drawRRect(rrect, borderPaint);

    _drawText(canvas, Offset(rect.center.dx, rect.top - 12), label, color, isBold: true, fontSize: 11);
  }

  void _drawNode(Canvas canvas, Offset p, String label, Color color, {double radius = 10, double fontSize = 9}) {
    final nodePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(p, radius, nodePaint);
    canvas.drawCircle(p, radius, Paint()..color = Colors.white.withAlpha(80)..style = PaintingStyle.stroke..strokeWidth = 1.0);

    _drawText(canvas, p, label, Colors.black, isBold: true, fontSize: fontSize);
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, Color color, {bool isDoubleHeaded = false, bool isDashed = false}) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final dir = (to - from);
    final dist = dir.distance;
    if (dist < 15) return;
    final unit = dir / dist;
    final start = from + unit * 12;
    final end = to - unit * 12;

    if (!isDashed) {
      canvas.drawLine(start, end, paint);
    } else {
      _drawDashedLine(canvas, start, end, paint);
    }

    // Punta freccia
    _drawArrowHead(canvas, end, unit, color);
    if (isDoubleHeaded) {
      _drawArrowHead(canvas, start, -unit, color);
    }
  }

  void _drawCurveArrow(Canvas canvas, Offset from, Offset to, Offset center, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(from.dx, from.dy);
    final mid = (from + to) / 2;
    final pull = (mid - center) * 0.4;
    final control = mid + pull;
    path.quadraticBezierTo(control.dx, control.dy, to.dx, to.dy);
    canvas.drawPath(path, paint);

    final unit = (to - control) / (to - control).distance;
    _drawArrowHead(canvas, to, unit, color);
  }

  void _drawArrowHead(Canvas canvas, Offset tip, Offset direction, Color color) {
    const headLength = 7.0;
    const headAngle = 0.45;
    final p1 = tip - Offset(
      direction.dx * math.cos(headAngle) - direction.dy * math.sin(headAngle),
      direction.dx * math.sin(headAngle) + direction.dy * math.cos(headAngle),
    ) * headLength;
    final p2 = tip - Offset(
      direction.dx * math.cos(-headAngle) - direction.dy * math.sin(-headAngle),
      direction.dx * math.sin(-headAngle) + direction.dy * math.cos(-headAngle),
    ) * headLength;

    final path = Path()..moveTo(tip.dx, tip.dy)..lineTo(p1.dx, p1.dy)..lineTo(p2.dx, p2.dy)..close();
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
  }

  void _drawLine(Canvas canvas, Offset from, Offset to, Color color) {
    canvas.drawLine(from, to, Paint()..color = color..strokeWidth = 1.4);
  }

  void _drawDashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dist = (to - from).distance;
    final unit = (to - from) / dist;
    double current = 0;
    while (current < dist) {
      final segEnd = math.min(current + 4, dist);
      canvas.drawLine(from + unit * current, from + unit * segEnd, paint);
      current += 8;
    }
  }

  void _drawText(Canvas canvas, Offset p, String text, Color color, {bool isBold = false, double fontSize = 10}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    textPainter.paint(canvas, p - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  void _drawCaption(Canvas canvas, Offset p, String caption) {
    _drawText(canvas, p, caption, const Color(0xFF94A3B8), fontSize: 10);
  }

  @override
  bool shouldRepaint(covariant _DiagramPainter oldDelegate) => oldDelegate.type != type;
}
