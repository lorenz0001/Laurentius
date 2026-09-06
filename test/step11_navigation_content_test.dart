import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/curriculum_registry.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/pages/main_layout_screen.dart';
import 'package:laurentius/presentation/pages/category_explorer_screen.dart';
import 'package:laurentius/presentation/widgets/content_block_factory.dart';

void main() {
  group('Step 11: Data Model, SubCategories & ContentBlock Tests', () {
    test('KnowledgeNode supports subCategory and ContentBlock list', () {
      final node = KnowledgeNode()
        ..serverId = 'test_01'
        ..title = 'Teorema di Test'
        ..category = 'Matematica'
        ..subCategory = 'Algebra Lineare'
        ..blocks = [
          ContentBlock()
            ..type = 'text_markdown'
            ..content = 'Testo descrittivo **bold**',
          ContentBlock()
            ..type = 'math_latex'
            ..content = r'x^2 + y^2 = r^2',
          ContentBlock()
            ..type = 'info_box'
            ..content = 'Insight corollario importante',
        ];

      expect(node.subCategory, equals('Algebra Lineare'));
      expect(node.blocks.length, equals(3));
      expect(node.effectiveBlocks.length, equals(3));
      expect(node.effectiveBlocks[0].type, equals('text_markdown'));
      expect(node.effectiveBlocks[1].type, equals('math_latex'));
      expect(node.effectiveBlocks[2].type, equals('info_box'));
    });

    test('effectiveBlocks provides seamless fallback when blocks is empty', () {
      final node = KnowledgeNode()
        ..serverId = 'test_fallback'
        ..title = 'Nodo Vecchio'
        ..category = 'Fisica'
        ..algebraicProof = [
          ProofStep()
            ..description = 'Passaggio 1'
            ..latexEquation = r'F = m \cdot a'
            ..insight = 'Seconda legge di Newton',
        ];

      expect(node.blocks, isEmpty);
      expect(node.effectiveBlocks.length, equals(3));
      expect(node.effectiveBlocks[0].type, equals('text_markdown'));
      expect(node.effectiveBlocks[0].content, equals('Passaggio 1'));
      expect(node.effectiveBlocks[1].type, equals('math_latex'));
      expect(node.effectiveBlocks[2].type, equals('info_box'));
    });

    test('Curriculum nodes have valid subCategories assigned', () {
      final allNodes = CurriculumRegistry.getAllNodes();
      expect(allNodes, isNotEmpty);

      for (final node in allNodes) {
        expect(
          node.subCategory,
          isNotNull,
          reason: 'Node ${node.serverId} should have a subCategory',
        );
        expect(node.subCategory!.isNotEmpty, isTrue);
      }
    });
  });

  group('Step 11: Navigation and UI Smoke Tests', () {
    testWidgets(
      'MainLayoutScreen renders BottomNavigationBar with Grafo and Esplora',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: MainLayoutScreen()));

        await tester.pumpAndSettle();

        expect(find.text('Brilliant OS'), findsOneWidget);
        expect(find.text('Grafo'), findsOneWidget);
        expect(find.text('Esplora'), findsOneWidget);
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);

        // Tap su Tab Esplora
        await tester.tap(find.text('Esplora'));
        await tester.pumpAndSettle();

        // Verifica presenza della schermata categorie
        expect(find.byType(CategoryExplorerScreen), findsOneWidget);
      },
    );

    testWidgets(
      'ContentBlockFactory builds valid widgets for all block types',
      (WidgetTester tester) async {
        final markdownBlock = ContentBlock()
          ..type = 'text_markdown'
          ..content = '### Titolo\nTesto in markdown';
        final latexBlock = ContentBlock()
          ..type = 'math_latex'
          ..content = r'a^2 + b^2 = c^2';
        final infoBoxBlock = ContentBlock()
          ..type = 'info_box'
          ..content = 'Insight sul corollario';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Column(
                  children: [
                    ContentBlockFactory.buildBlock(markdownBlock, context),
                    ContentBlockFactory.buildBlock(latexBlock, context),
                    ContentBlockFactory.buildBlock(infoBoxBlock, context),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Insight sul corollario'), findsOneWidget);
        expect(find.text('INSIGHT & INTUIZIONE DIDATTICA'), findsOneWidget);
      },
    );
  });
}
