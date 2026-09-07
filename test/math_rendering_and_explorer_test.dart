import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:laurentius/presentation/pages/category_explorer_screen.dart';
import 'package:laurentius/presentation/widgets/math_markdown_view.dart';
import 'package:laurentius/presentation/widgets/interactive/rolle_lagrange_widget.dart';

void main() {
  group('MathMarkdownView LaTeX & Markdown Rendering Tests', () {
    testWidgets('Renders inline math with KaTeX without raw unparsed tokens', (tester) async {
      const markdown = r'La formula fondamentale è $(a+b)^2 = a^2 + 2ab + b^2$ per ogni $a, b \in \mathbb{R}$.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MathMarkdownView(text: markdown),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verifica che flutter_math_fork Math widget sia istanziato
      expect(find.byType(Math), findsWidgets);
      // Verifica che il testo introduttivo sia renderizzato
      expect(find.textContaining('La formula fondamentale è'), findsOneWidget);
    });

    testWidgets(r'Renders display math blocks ($$...$$) in scrollable card', (tester) async {
      const markdown = r"""### Teorema Fondamentale

Formula di quadratura:
$$x(t) = x_0 + v_0 t + \frac{1}{2} a t^2$$

Conclusione geometrica.""";

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MathMarkdownView(text: markdown),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Teorema Fondamentale'), findsOneWidget);
      expect(find.textContaining('Formula di quadratura:'), findsOneWidget);
      expect(find.textContaining('Conclusione geometrica.'), findsOneWidget);
      expect(find.byType(Math), findsWidgets);
    });

    testWidgets('Gracefully handles unclosed dollar or malformed math without crash', (tester) async {
      const brokenMarkdown = r'Testo con math non chiuso $a^2 e poi testo normale.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MathMarkdownView(text: brokenMarkdown),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Non deve crashare l'app
      expect(find.textContaining('Testo con math non chiuso'), findsOneWidget);
    });
  });

  group('CategoryExplorerScreen Difficulty Filter Tests', () {
    testWidgets('Displays difficulty chips and filters topics correctly', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryExplorerScreen(),
          ),
        ),
      );

      // Attende il caricamento dei nodi
      await tester.pumpAndSettle();

      // Verifica la presenza della barra dei filtri di difficoltà
      expect(find.widgetWithText(FilterChip, 'Tutti'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Fondamenti'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Intermedio'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Avanzato'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Superiore'), findsOneWidget);

      // In modalità "Tutti" su Matematica sono visibili nodi base e nodi avanzati
      expect(find.textContaining('Addizione'), findsWidgets);

      // Filtra per "Superiore"
      await tester.tap(find.widgetWithText(FilterChip, 'Superiore'));
      await tester.pumpAndSettle();

      // I nodi Fondamenti (come Addizione) non devono più apparire
      expect(find.text('Addizione e Proprietà Fondamentali'), findsNothing);
      // I nodi Superiori (come Teoremi Differenziali o Calcolo Integrale) devono essere visibili
      expect(find.textContaining('Rolle'), findsOneWidget);

      // Ripristina "Tutti"
      await tester.tap(find.widgetWithText(FilterChip, 'Tutti'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Addizione'), findsWidgets);
    });

    testWidgets('Filters topics within Elettrotecnica subject', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryExplorerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Passa alla tab "Elettrotecnica"
      await tester.tap(find.text('Elettrotecnica'));
      await tester.pumpAndSettle();

      // Verifica che la Legge di Ohm sia visibile in Elettrotecnica
      expect(find.textContaining('Legge di Ohm'), findsOneWidget);

      // Filtra per Fondamenti
      await tester.tap(find.widgetWithText(FilterChip, 'Fondamenti'));
      await tester.pumpAndSettle();

      // In Fondamenti di Elettrotecnica, la Legge di Ohm è presente
      expect(find.textContaining('Legge di Ohm'), findsOneWidget);
    });
  });

  group('RolleLagrangeWidget Interactive Simulation Tests', () {
    testWidgets('Renders RolleLagrangeWidget with mode switcher and sliders', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: RolleLagrangeWidget(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Header e controlli
      expect(find.text('Teoremi del Valor Medio & Rolle'), findsOneWidget);
      expect(find.text('Teorema di Lagrange'), findsOneWidget);
      expect(find.text('Teorema di Rolle'), findsOneWidget);

      // Indicatori telemetrici
      expect(find.text('PENDENZA SECANTE'), findsOneWidget);
      expect(find.text('DERIVATA TANGENTE'), findsOneWidget);
      expect(find.text('PUNTO INTERNO c'), findsOneWidget);

      // Slider per a e b
      expect(find.byType(Slider), findsNWidgets(2));

      // Modalità iniziale è Lagrange
      expect(find.textContaining('Lagrange: f\'(c) = m'), findsOneWidget);

      // Passa a modalità Rolle
      await tester.tap(find.text('Teorema di Rolle'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // In modalità Rolle: Rolle badge presente
      expect(find.textContaining('Rolle: f\'(c) = 0'), findsOneWidget);
    });

    testWidgets('Adjusting slider changes endpoint a and telemetry', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: RolleLagrangeWidget(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Trova gli slider
      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(2));

      // Trascina il primo slider (estremo a)
      await tester.drag(sliders.first, const Offset(30, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Il widget continua a visualizzare la telemetria aggiornata
      expect(find.text('PENDENZA SECANTE'), findsOneWidget);
    });

    testWidgets('Auto-animation play/pause toggle works', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: RolleLagrangeWidget(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Inizialmente l'animazione è ferma di default, quindi troviamo il pulsante di avvio
      final playBtn = find.byTooltip('Avvia animazione a 60 FPS');
      expect(playBtn, findsOneWidget);

      // Avvia animazione
      await tester.tap(playBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Ora il pulsante deve consentire di mettere in pausa
      final pauseBtn = find.byTooltip('Pausa simulazione');
      expect(pauseBtn, findsOneWidget);

      // Metti in pausa
      await tester.tap(pauseBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Avvia animazione a 60 FPS'), findsOneWidget);
    });
  });
}
