import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/domain/models/spotlight_result.dart';
import 'package:laurentius/presentation/pages/main_layout_screen.dart';
import 'package:laurentius/presentation/pages/node_detail_screen.dart';
import 'package:laurentius/presentation/widgets/algebraic_proof_widget.dart';
import 'package:laurentius/presentation/widgets/spotlight_dropdown_overlay.dart';
import 'package:laurentius/presentation/widgets/spotlight_result_card.dart';
import 'package:laurentius/presentation/widgets/spotlight_search_bar_widget.dart';

void main() {
  group('Spotlight UI & Navigation Widget Tests', () {
    testWidgets('1. MainLayoutScreen renders persistent SpotlightSearchBarWidget at the top', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: MainLayoutScreen()));
      await tester.pumpAndSettle();

      // La barra Spotlight è visibile direttamente senza dover cliccare alcuna icona modale
      expect(find.byType(SpotlightSearchBarWidget), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsWidgets);
      expect(find.text('⌘K'), findsOneWidget);

      // Il vecchio pulsante per sviluppatori "Ricarica" è stato rimosso dalla barra principale
      expect(find.text('Ricarica catalogo'), findsNothing);
      expect(find.byIcon(Icons.refresh_rounded), findsNothing);
    });

    testWidgets('2. Live typing into SpotlightSearchBarWidget displays results and clear button', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: MainLayoutScreen()));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      // Digita query
      await tester.enterText(searchField, 'ridotta');
      await tester.pump();

      // Il badge ⌘K scompare ed emerge il tasto pulisci (X)
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // Compare l'overlay con i risultati
      expect(find.byType(SpotlightDropdownOverlay), findsOneWidget);
      expect(find.byType(SpotlightResultCard), findsWidgets);

      // Pulisce il testo
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(find.byType(SpotlightDropdownOverlay), findsNothing);
    });

    testWidgets('3. SpotlightResultCard renders type badges, KaTeX formulas and 1-tap action', (tester) async {
      final testNode = KnowledgeNode()
        ..serverId = 'mat_quad_test'
        ..title = 'Equazioni di Secondo Grado'
        ..category = 'Matematica'
        ..subCategory = 'Algebra Quadratica';

      final populatedResult = SpotlightSearchResult(
        id: 'test_card_1',
        nodeId: 'mat_quad_test',
        node: testNode,
        type: SpotlightResultType.corollary,
        title: 'Formula Risolutiva Ridotta (b pari)',
        parentTopicTitle: 'Equazioni di Secondo Grado',
        category: 'Matematica',
        subCategory: 'Algebra Quadratica',
        snippet: 'Consente di dimezzare i calcoli evitando il moltiplicatore 4 nel discriminante.',
        latexFormula: r'x = \frac{-\frac{b}{2} \pm \sqrt{\left(\frac{b}{2}\right)^2 - ac}}{a}',
      );

      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SpotlightResultCard(
              result: populatedResult,
              query: 'ridotta',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Badge tipologia COROLLARIO
      expect(find.text('COROLLARIO'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);

      // Breadcrumb categoria
      expect(find.text('Matematica • Algebra Quadratica'), findsOneWidget);

      // Formula KaTeX
      expect(find.byType(Math), findsOneWidget);

      // Indicatore di azione diretta
      expect(find.text('Apri dimostrazione'), findsOneWidget);

      // Tocco sulla card
      await tester.tap(find.byType(SpotlightResultCard));
      expect(tapped, isTrue);
    });

    testWidgets('4. Direct <= 1-Tap Navigation: Selecting search result pushes NodeDetailScreen directly', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: MainLayoutScreen()));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'carabinieri');
      await tester.pump();

      expect(find.byType(SpotlightResultCard), findsWidgets);

      // Tap sul primo risultato (1 solo tap!)
      await tester.tap(find.byType(SpotlightResultCard).first);
      await tester.pumpAndSettle();

      // Verifica che la schermata NodeDetailScreen sia stata aperta istantaneamente
      expect(find.byType(NodeDetailScreen), findsOneWidget);
      expect(find.byType(AlgebraicProofWidget), findsOneWidget);
    });

    testWidgets('5. Keyboard Navigation: ArrowDown, ArrowUp and Escape shortcuts in Spotlight', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: MainLayoutScreen()));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'torricelli');
      await tester.pump();

      expect(find.byType(SpotlightDropdownOverlay), findsOneWidget);

      // Freccia Giù
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      // Freccia Su
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();

      // Escape chiude l'overlay
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(SpotlightDropdownOverlay), findsNothing);
    });

    testWidgets('6. Keyboard shortcut Enter triggers direct navigation to selected result', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: MainLayoutScreen()));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'viète');
      await tester.pump();

      expect(find.byType(SpotlightDropdownOverlay), findsOneWidget);

      // Tasto Invio
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.byType(NodeDetailScreen), findsOneWidget);
    });
  });
}
