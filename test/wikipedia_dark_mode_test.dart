import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:laurentius/core/theme/app_theme.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/pages/node_detail_screen.dart';
import 'package:laurentius/presentation/pages/exercise_screen.dart';
import 'package:laurentius/presentation/widgets/algebraic_proof_widget.dart';
import 'package:laurentius/presentation/widgets/math_markdown_view.dart';

void main() {
  group('Wikipedia Mobile Dark Mode - Theme & Tokens Tests', () {
    test('AppTheme defines pitch black/charcoal backgrounds and crisp off-white text', () {
      expect(AppTheme.bgDark, const Color(0xFF101214));
      expect(AppTheme.surfaceDark, const Color(0xFF191C20));
      expect(AppTheme.surfaceElevated, const Color(0xFF22262B));
      expect(AppTheme.borderDark, const Color(0xFF2D3238));
      expect(AppTheme.textPrimary, const Color(0xFFEAECF0));
      expect(AppTheme.textSecondary, const Color(0xFF9CA3AF));

      final theme = AppTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppTheme.bgDark);
      expect(theme.appBarTheme.backgroundColor, AppTheme.bgDark);
    });
  });

  group('NodeDetailScreen - Wikipedia Mobile Dark Mode Layout & Collapsible Sections', () {
    late KnowledgeNode sampleNode;

    setUp(() {
      sampleNode = KnowledgeNode()
        ..serverId = 'math_pitagora_01'
        ..title = 'Teorema di Pitagora'
        ..category = 'Matematica'
        ..subCategory = 'Geometria Euclidea'
        ..lastUpdated = DateTime(2026, 1, 1)
        ..blocks = [
          ContentBlock()
            ..type = 'text_markdown'
            ..content = '### Definizione Geometrica\n\nIn un triangolo rettangolo la somma delle aree costruite sui cateti equivale all\'area costruita sull\'ipotenusa.',
          ContentBlock()
            ..type = 'math_latex'
            ..content = r'a^2 + b^2 = c^2',
        ]
        ..interactiveData = (InteractiveData()..templateType = 'triangle_solver')
        ..algebraicProof = [
          ProofStep()
            ..description = '1. Costruzione geometrica dei quadrati'
            ..latexEquation = r'Area_1 = a^2, \quad Area_2 = b^2',
          ProofStep()
            ..description = '2. Relazione algebrica'
            ..latexEquation = r'c^2 = a^2 + b^2',
        ];
    });

    testWidgets('Renders NodeDetailScreen with dark pitch background and Wikipedia typography', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: NodeDetailScreen(node: sampleNode),
        ),
      );
      await tester.pumpAndSettle();

      // Verifica Scaffold dark background
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);
      final scaffold = tester.widget<Scaffold>(scaffoldFinder);
      expect(scaffold.backgroundColor, const Color(0xFF101214));

      // Verifica Titolo nodo
      expect(find.text('Teorema di Pitagora'), findsWidgets);

      // Verifica badge in stile Wikipedia (Categoria, Sottocategoria, ID)
      expect(find.text('MATEMATICA'), findsOneWidget);
      expect(find.text('Geometria Euclidea'), findsOneWidget);
      expect(find.textContaining('math_pitagora_01'), findsOneWidget);
    });

    testWidgets('Renders collapsible accordion sections with initial expanded state and allows collapsing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: NodeDetailScreen(node: sampleNode),
        ),
      );
      await tester.pumpAndSettle();

      // Verifica intestazioni sezioni a fisarmonica
      final teoriaFinder = find.text('APPROFONDIMENTO TEORICO');
      final proofFinder = find.text('DIMOSTRAZIONE LOGICO-ALGEBRICA');
      final labFinder = find.text('LABORATORIO INTERATTIVO');

      expect(teoriaFinder, findsOneWidget);
      expect(proofFinder, findsOneWidget);
      expect(labFinder, findsOneWidget);

      // Inizialmente i contenuti della dimostrazione sono visibili
      expect(find.text('1. Costruzione geometrica dei quadrati'), findsOneWidget);

      // Clicca sull'header della sezione "DIMOSTRAZIONE LOGICO-ALGEBRICA" per collassarla
      await tester.ensureVisible(proofFinder);
      await tester.tap(proofFinder);
      await tester.pumpAndSettle();

      // Ora i contenuti della dimostrazione sono collassati
      expect(find.text('1. Costruzione geometrica dei quadrati'), findsNothing);

      // Clicca nuovamente per riaprire la sezione
      await tester.tap(proofFinder);
      await tester.pumpAndSettle();

      // I contenuti della dimostrazione sono nuovamente visibili
      expect(find.text('1. Costruzione geometrica dei quadrati'), findsOneWidget);
    });

    testWidgets('Collapses and expands APPROFONDIMENTO TEORICO section cleanly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: NodeDetailScreen(node: sampleNode),
        ),
      );
      await tester.pumpAndSettle();

      final teoriaFinder = find.text('APPROFONDIMENTO TEORICO');
      expect(find.text('Definizione Geometrica'), findsOneWidget);

      // Tap to collapse
      await tester.ensureVisible(teoriaFinder);
      await tester.tap(teoriaFinder);
      await tester.pumpAndSettle();
      expect(find.text('Definizione Geometrica'), findsNothing);

      // Tap to expand
      await tester.tap(teoriaFinder);
      await tester.pumpAndSettle();
      expect(find.text('Definizione Geometrica'), findsOneWidget);
    });

    testWidgets('Collapses and expands LABORATORIO INTERATTIVO section cleanly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: NodeDetailScreen(node: sampleNode),
        ),
      );
      await tester.pumpAndSettle();

      final labFinder = find.text('LABORATORIO INTERATTIVO');
      expect(labFinder, findsOneWidget);

      // Scroll to view and tap to collapse
      await tester.ensureVisible(labFinder);
      await tester.tap(labFinder);
      await tester.pumpAndSettle();

      // Tap to expand
      await tester.tap(labFinder);
      await tester.pumpAndSettle();
      expect(labFinder, findsOneWidget);
    });
  });

  group('AlgebraicProofWidget Dark Theme Styling', () {
    testWidgets('Renders theorem proof steps and corollaries in dark cards with crisp typography', (tester) async {
      final steps = [
        ProofStep()
          ..description = 'Passo A'
          ..latexEquation = 'a^2 = b^2 + c^2',
        ProofStep()
          ..description = 'Passo B'
          ..latexEquation = r'c = \sqrt{a^2 + b^2}',
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: AlgebraicProofWidget(
                proofSteps: steps,
                initialShowAll: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Passo A'), findsOneWidget);
      expect(find.text('Passo B'), findsOneWidget);
      expect(find.byType(Math), findsWidgets);
    });

    testWidgets('Renders corollary step with COROLLARIO DEDOTTO banner and dark styling', (tester) async {
      final steps = [
        ProofStep()
          ..description = '[Corollario: Teorema Inverso] Passo Inverso'
          ..latexEquation = r'a^2 + b^2 = c^2 \implies \alpha = 90^\circ',
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: AlgebraicProofWidget(
                proofSteps: steps,
                initialShowAll: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Passo Inverso'), findsOneWidget);
      expect(find.text('COROLLARIO DEDOTTO'), findsOneWidget);
      expect(find.byType(Math), findsWidgets);
    });
  });

  group('MathMarkdownView Dark High-Contrast LaTeX Rendering', () {
    testWidgets('Math rendering displays crisp KaTeX elements against dark background', (tester) async {
      const markdown = r'Formula chiave: $E = mc^2$ e blocco $$\int_0^\infty e^{-x} dx = 1$$';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Color(0xFF101214),
            body: SingleChildScrollView(
              child: MathMarkdownView(text: markdown),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Formula chiave:'), findsOneWidget);
      expect(find.byType(Math), findsWidgets);
    });
  });

  group('ExerciseScreen Dark Mode Layout', () {
    testWidgets('Renders ExerciseScreen with dark pitch background', (tester) async {
      final node = KnowledgeNode()
        ..serverId = 'math_calc_01'
        ..title = 'Calcolo Integrale'
        ..category = 'Matematica';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: ExerciseScreen(node: node),
        ),
      );
      // Solo un pump iniziale per non attendere timer o API asincrone
      await tester.pump();

      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);
      final scaffold = tester.widget<Scaffold>(scaffoldFinder);
      expect(scaffold.backgroundColor, const Color(0xFF101214));
      expect(find.text('Calcolo Integrale'), findsWidgets);
    });
  });
}
