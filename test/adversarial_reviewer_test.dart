import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:laurentius/core/theme/app_theme.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/pages/node_detail_screen.dart';
import 'package:laurentius/presentation/pages/category_explorer_screen.dart';
import 'package:laurentius/presentation/widgets/algebraic_proof_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/squeeze_theorem_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/quadratic_visual_proof_widget.dart';
import 'package:laurentius/presentation/widgets/node_search_delegate.dart';
import 'package:laurentius/presentation/widgets/ai_tutor_qna_bottom_sheet.dart';
import 'package:laurentius/presentation/widgets/ai_rephrase_bottom_sheet.dart';
import 'package:laurentius/presentation/widgets/interactive/derivative_tangent_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/trig_circle_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/riemann_sum_widget.dart';

void main() {
  group('Adversarial Reviewer Suite - Accordion & Dark Mode Deep Checks', () {
    late KnowledgeNode testNode;

    setUp(() {
      testNode = KnowledgeNode()
        ..serverId = 'math_pitagora_adv'
        ..title = 'Teorema di Pitagora Avanzato'
        ..category = 'Matematica'
        ..subCategory = 'Geometria Euclidea'
        ..blocks = [
          ContentBlock()
            ..type = 'text_markdown'
            ..content = r'### Definizione Formale\n\nIn ogni triangolo rettangolo: $a^2 + b^2 = c^2$.',
          ContentBlock()
            ..type = 'math_latex'
            ..content = r'c = \sqrt{a^2 + b^2}',
        ]
        ..interactiveData = (InteractiveData()..templateType = 'triangle_solver')
        ..algebraicProof = [
          ProofStep()
            ..description = 'Costruzione iniziale dei quattro triangoli'
            ..latexEquation = r'(a+b)^2 = c^2 + 4 \cdot \frac{ab}{2}',
          ProofStep()
            ..description = 'Sviluppo del quadrato di binomio'
            ..latexEquation = r'a^2 + 2ab + b^2 = c^2 + 2ab',
          ProofStep()
            ..description = '[Corollario: Teorema di Fermat] Estensione esponenziale'
            ..latexEquation = r'a^n + b^n = c^n \quad \text{per } n > 2 \text{ non ha soluzioni intere}',
        ];
    });

    testWidgets('1. Preserves unlocked proof steps state across collapse and re-expansion cycles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: NodeDetailScreen(node: testNode),
        ),
      );
      await tester.pumpAndSettle();

      final proofHeader = find.text('DIMOSTRAZIONE LOGICO-ALGEBRICA');
      expect(proofHeader, findsOneWidget);

      // Inizialmente è visibile solo il primo passaggio
      expect(find.text('Costruzione iniziale dei quattro triangoli'), findsOneWidget);
      expect(find.text('Sviluppo del quadrato di binomio'), findsNothing);

      // L'utente sblocca il Passaggio 2
      final unlockBtn = find.text('Sblocca Passaggio 2');
      expect(unlockBtn, findsOneWidget);
      await tester.ensureVisible(unlockBtn);
      await tester.tap(unlockBtn);
      await tester.pumpAndSettle();

      // Ora il Passaggio 2 è sbloccato e visibile
      expect(find.text('Sviluppo del quadrato di binomio'), findsOneWidget);

      // L'utente collassa la sezione DIMOSTRAZIONE LOGICO-ALGEBRICA
      await tester.ensureVisible(proofHeader);
      await tester.tap(proofHeader);
      await tester.pumpAndSettle();

      // Quando collassata, i contenuti interni sono offstage
      expect(find.text('Costruzione iniziale dei quattro triangoli'), findsNothing);
      expect(find.text('Sviluppo del quadrato di binomio'), findsNothing);

      // L'utente riapre la sezione DIMOSTRAZIONE LOGICO-ALGEBRICA
      await tester.ensureVisible(proofHeader);
      await tester.tap(proofHeader);
      await tester.pumpAndSettle();

      // Verifica critica: il Passaggio 2 è ANCORA visibile (stato preservato, non resettato a 0!)
      expect(find.text('Costruzione iniziale dei quattro triangoli'), findsOneWidget);
      expect(find.text('Sviluppo del quadrato di binomio'), findsOneWidget);
      expect(find.text('Dimostrazione e corollari verificati'), findsOneWidget);
    });

    testWidgets('2. didUpdateWidget with targetCorollary auto-expands proof section if previously collapsed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: NodeDetailScreen(node: testNode),
        ),
      );
      await tester.pumpAndSettle();

      final proofHeader = find.text('DIMOSTRAZIONE LOGICO-ALGEBRICA');

      // Collassa manualmente la sezione dimostrazione
      await tester.ensureVisible(proofHeader);
      await tester.tap(proofHeader);
      await tester.pumpAndSettle();
      expect(find.text('Costruzione iniziale dei quattro triangoli'), findsNothing);

      // Ricostruisce lo schermo passando targetCorollary (ad es. navigazione da link o overlay)
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: NodeDetailScreen(
            node: testNode,
            targetCorollary: 'Teorema di Fermat',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // La sezione deve essersi riaperta automaticamente ed esporre il corollario mirato
      expect(find.text('COROLLARIO DEDOTTO'), findsOneWidget);
      expect(find.text('Estensione esponenziale'), findsOneWidget);
    });

    testWidgets('3. Stress test: Rapid concurrent toggling of multiple accordion sections with KaTeX', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: NodeDetailScreen(node: testNode),
        ),
      );
      await tester.pumpAndSettle();

      final theoryHeader = find.text('APPROFONDIMENTO TEORICO');
      final proofHeader = find.text('DIMOSTRAZIONE LOGICO-ALGEBRICA');

      // Esegue rapide alternanze consecutive di collapse/expand
      for (int i = 0; i < 4; i++) {
        await tester.tap(theoryHeader);
        await tester.pump(const Duration(milliseconds: 30));
        await tester.tap(proofHeader);
        await tester.pump(const Duration(milliseconds: 30));
      }

      // Convalida stabilizzazione finale
      await tester.pumpAndSettle();
      expect(find.byType(NodeDetailScreen), findsOneWidget);
      expect(find.byType(Math), findsWidgets);
    });

    testWidgets('4. Viewport constraint test: Small screen (360x480) renders without RenderFlex overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: NodeDetailScreen(node: testNode),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Verifica elementi chiave visibili o scrollabili
      expect(find.text('APPROFONDIMENTO TEORICO'), findsOneWidget);
      expect(find.text('DIMOSTRAZIONE LOGICO-ALGEBRICA'), findsOneWidget);
    });

    testWidgets('5. Dark theme contrast and surface styling validation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            backgroundColor: AppTheme.bgDark,
            body: AlgebraicProofWidget(
              proofSteps: testNode.algebraicProof,
              initialShowAll: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Trova Math renderizzati
      final mathWidgets = tester.widgetList<Math>(find.byType(Math));
      expect(mathWidgets.isNotEmpty, isTrue);

      for (final mw in mathWidgets) {
        // I testi matematici devono avere colore chiaro per contrastare lo sfondo scuro
        final color = mw.textStyle?.color;
        if (color != null) {
          final luminance = color.computeLuminance();
          // La luminanza del testo KaTeX deve essere >= 0.70 (chiara)
          expect(luminance > 0.70, isTrue, reason: 'Math text color $color has low contrast');
        }
      }
    });

    testWidgets('6. SqueezeTheoremWidget adheres to Wikipedia Dark Mode with zero white outer containers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: SqueezeTheoremWidget(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Teorema del Confronto (Carabinieri)'), findsOneWidget);
      expect(find.text('INF: g(x) = cos(x)'), findsOneWidget);

      // Nessun container principale con colore bianco puro
      final containers = tester.widgetList<Container>(find.byType(Container));
      for (final c in containers) {
        final dec = c.decoration;
        if (dec is BoxDecoration && dec.color != null) {
          expect(
            dec.color != Colors.white,
            isTrue,
            reason: 'Container must not have pure white background in dark mode',
          );
        }
      }
    });

    testWidgets('7. QuadraticVisualProofWidget adheres to Wikipedia Dark Mode with zero white outer containers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: QuadraticVisualProofWidget(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dimostrazione Visiva: Formula Quadratica'), findsOneWidget);
      expect(find.text('Completamento del Quadrato'), findsOneWidget);

      // Nessun container principale con colore bianco puro
      final containers = tester.widgetList<Container>(find.byType(Container));
      for (final c in containers) {
        final dec = c.decoration;
        if (dec is BoxDecoration && dec.color != null) {
          expect(
            dec.color != Colors.white,
            isTrue,
            reason: 'Container must not have pure white background in dark mode',
          );
        }
      }
    });

    testWidgets('8. CategoryExplorerScreen on 320x480 narrow viewport renders with 0 RenderFlex overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const CategoryExplorerScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CategoryExplorerScreen), findsOneWidget);
    });

    testWidgets('9. AlgebraicProofWidget.didUpdateWidget updates initialStepIndex and initialShowAll', (tester) async {
      final steps = [
        ProofStep()
          ..description = 'Passaggio 1'
          ..latexEquation = 'a = b',
        ProofStep()
          ..description = 'Passaggio 2'
          ..latexEquation = 'b = c',
        ProofStep()
          ..description = 'Passaggio 3'
          ..latexEquation = 'a = c',
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: AlgebraicProofWidget(
              proofSteps: steps,
              initialStepIndex: 0,
              initialShowAll: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Passaggio 1'), findsOneWidget);
      expect(find.text('Passaggio 2'), findsNothing);

      // Rebuild widget with initialStepIndex: 1
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: AlgebraicProofWidget(
              proofSteps: steps,
              initialStepIndex: 1,
              initialShowAll: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Passaggio 1'), findsOneWidget);
      expect(find.text('Passaggio 2'), findsOneWidget);
      expect(find.text('Passaggio 3'), findsNothing);

      // Rebuild widget with initialShowAll: true
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: AlgebraicProofWidget(
              proofSteps: steps,
              initialStepIndex: 1,
              initialShowAll: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Passaggio 1'), findsOneWidget);
      expect(find.text('Passaggio 2'), findsOneWidget);
      expect(find.text('Passaggio 3'), findsOneWidget);
    });

    testWidgets('10. GlobalNodeSearchDelegate renders dark app bar and dark theme elements', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: SizedBox()),
        ),
      );
      await tester.pumpAndSettle();

      final delegate = GlobalNodeSearchDelegate();
      final theme = delegate.appBarTheme(
        tester.element(find.byType(Scaffold)),
      );

      expect(theme.brightness, Brightness.dark);
      expect(theme.appBarTheme.backgroundColor, AppTheme.bgDark);
      expect(theme.appBarTheme.iconTheme?.color, AppTheme.textPrimary);
    });

    testWidgets('11. DerivativeTangentWidget on 320x480 narrow viewport renders with 0 RenderFlex overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: DerivativeTangentWidget(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(DerivativeTangentWidget), findsOneWidget);
    });

    testWidgets('12. TrigCircleWidget on 320x480 narrow viewport renders with 0 RenderFlex overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: TrigCircleWidget(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(TrigCircleWidget), findsOneWidget);
    });

    testWidgets('13. RiemannSumWidget on 320x480 narrow viewport renders with 0 RenderFlex overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: RiemannSumWidget(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(RiemannSumWidget), findsOneWidget);
    });

    testWidgets('14. NodeDetailScreen on 320x480 with long category (Elettrotecnica) renders without overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final longCategoryNode = KnowledgeNode()
        ..serverId = 'elem_ohm_01'
        ..title = 'Legge di Ohm Fondamentale ed Effetto Joule nei Circuiti'
        ..category = 'Elettrotecnica'
        ..subCategory = 'Circuiti Lineari in Regime Stazionario'
        ..algebraicProof = [
          ProofStep()
            ..description = 'Definizione di Resistenza'
            ..latexEquation = r'V = R \cdot I',
        ];

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: NodeDetailScreen(node: longCategoryNode),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(NodeDetailScreen), findsOneWidget);
    });

    testWidgets('15. AITutorQnABottomSheet accounts for virtual keyboard insets and keeps TextField accessible', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AITutorQnABottomSheet(node: testNode),
                  );
                },
                child: const Text('Open QnA'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open QnA'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      // Simula comparsa della tastiera virtuale (260px viewInsets.bottom)
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      addTearDown(() => tester.view.resetViewInsets());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final textFieldCenter = tester.getCenter(find.byType(TextField));
      // Lo spazio visibile termina a y = 640 - 260 = 380
      expect(
        textFieldCenter.dy <= 380,
        isTrue,
        reason: 'TextField must stay above virtual keyboard inset',
      );
    });

    testWidgets('16. AIRephraseBottomSheet accounts for virtual keyboard insets without overflowing', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AIRephraseBottomSheet(
                      node: testNode,
                      onApplied: () {},
                    ),
                  );
                },
                child: const Text('Open Rephrase'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Rephrase'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      // Simula comparsa della tastiera virtuale (260px viewInsets.bottom)
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      addTearDown(() => tester.view.resetViewInsets());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AIRephraseBottomSheet), findsOneWidget);
    });
  });
}
