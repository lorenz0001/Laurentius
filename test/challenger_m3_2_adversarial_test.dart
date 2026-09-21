import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/curriculum_registry.dart';
import 'package:laurentius/data/content/content_loader_service.dart';
import 'package:laurentius/data/content/markdown_content_parser.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/vector_2d_simulation_widget.dart';

void main() {
  group('Adversarial Verification: Linear Algebra Markdown Content Nodes', () {
    final expectedFiles = [
      'lin_alg_01_tuples.md',
      'lin_alg_02_vectors.md',
      'lin_alg_03_operations.md',
      'lin_alg_04_span.md',
      'lin_alg_05_independence.md',
    ];

    test('All 5 Linear Algebra markdown files exist on disk with non-trivial content', () {
      for (final filename in expectedFiles) {
        final expectedPath = 'assets/content/linear_algebra/$filename';
        final file = File(expectedPath);
        expect(file.existsSync(), isTrue, reason: '$filename must exist on disk');
        final content = file.readAsStringSync();
        expect(content.trim().isNotEmpty, isTrue, reason: '$filename must not be empty');
        expect(content.length, greaterThan(500), reason: '$filename must contain substantial educational content');
        expect(
          ContentLoaderService.knownAssetPaths,
          contains(expectedPath),
          reason: '$expectedPath must be registered in ContentLoaderService.knownAssetPaths',
        );
      }
    });

    test('Parse all 5 Linear Algebra nodes: metadata, prerequisites, and template assertions', () {
      final validCurriculumIds = CurriculumRegistry.getAllNodes().map((n) => n.serverId).toSet();
      expect(validCurriculumIds.length, greaterThanOrEqualTo(40));

      final expectedTemplates = {
        'lin_alg_01_tuples': 'vector_2d',
        'lin_alg_02_vectors': 'vector_2d',
        'lin_alg_03_operations': 'vector_addition',
        'lin_alg_04_span': 'linear_combination',
        'lin_alg_05_independence': 'span_2d',
      };

      final expectedCorollaries = {
        'lin_alg_01_tuples': [
          'Cauchy-Schwarz',
          'Elemento Neutro',
        ],
        'lin_alg_02_vectors': [
          'Normalizzazione',
          'Traslazione',
        ],
        'lin_alg_03_operations': [
          'Annullamento del Prodotto',
          'Opposto Vettoriale',
        ],
        'lin_alg_04_span': [
          'Minimalità',
          'Collasso Dimensionale',
        ],
        'lin_alg_05_independence': [
          'Vettore Nullo',
          'Determinante 2D',
        ],
      };

      for (final filename in expectedFiles) {
        final file = File('assets/content/linear_algebra/$filename');
        final rawMarkdown = file.readAsStringSync();
        final node = MarkdownContentParser.parse(rawMarkdown);

        // 1. Metadata non-null and valid
        expect(node.serverId, isNotEmpty, reason: '$filename serverId must be non-empty');
        expect(node.title, isNotEmpty, reason: '$filename title must be non-empty');
        expect(node.category, 'Matematica', reason: '$filename category must be Matematica');
        expect(node.subCategory, 'Algebra Lineare', reason: '$filename subCategory must be Algebra Lineare');

        // 2. Prerequisites non-empty and resolvable in curriculum
        expect(node.tempPrerequisiteIds, isNotEmpty, reason: '$filename prerequisites must not be empty');
        for (final prereqId in node.tempPrerequisiteIds) {
          expect(
            validCurriculumIds.contains(prereqId),
            isTrue,
            reason: 'Prerequisite $prereqId in $filename must resolve to an existing curriculum node',
          );
        }

        // 3. Interactive simulation specification
        expect(node.interactiveData, isNotNull, reason: '$filename must define interactiveData');
        final data = node.interactiveData!;
        final expectedTemplate = expectedTemplates[node.serverId];
        expect(data.templateType, expectedTemplate, reason: '$filename must use template $expectedTemplate');
        expect(data.parameters, isNotNull, reason: '$filename must define parameters');
        expect(data.parameters!.isNotEmpty, isTrue, reason: '$filename parameters must not be empty');

        for (final param in data.parameters!) {
          expect(param.variableName, isNotEmpty, reason: '$filename param variableName must not be empty');
          expect(param.minValue, isNotNull, reason: '$filename param minValue must be set');
          expect(param.maxValue, isNotNull, reason: '$filename param maxValue must be set');
          expect(param.defaultValue, isNotNull, reason: '$filename param defaultValue must be set');
          expect(param.defaultValue! >= param.minValue!, isTrue);
          expect(param.defaultValue! <= param.maxValue!, isTrue);
        }

        // 4. InteractiveTemplateFactory builds Vector2DSimulationWidget
        final widget = InteractiveTemplateFactory.buildWidget(data);
        expect(
          widget,
          isNotNull,
          reason: 'InteractiveTemplateFactory must build widget for template ${data.templateType}',
        );
        expect(
          widget,
          isA<Vector2DSimulationWidget>(),
          reason: 'Template ${data.templateType} must resolve to Vector2DSimulationWidget',
        );

        // 5. Algebraic Proof & Corollary Extraction
        expect(
          node.algebraicProof.isNotEmpty,
          isTrue,
          reason: '$filename algebraicProof must have structured steps',
        );

        // Find all steps related to corollaries
        final corollarySteps = node.algebraicProof.where((step) {
          final desc = step.description?.toLowerCase() ?? '';
          final insight = step.insight?.toLowerCase() ?? '';
          return desc.contains('corollario') || insight.contains('corollario');
        }).toList();

        expect(
          corollarySteps.length,
          greaterThanOrEqualTo(2),
          reason: '$filename must extract at least 2 corollary steps, found ${corollarySteps.length}',
        );

        // Check specific named corollaries for this node
        final expectedForNode = expectedCorollaries[node.serverId]!;
        for (final expectedKeyword in expectedForNode) {
          final found = node.algebraicProof.any((step) =>
              (step.description?.toLowerCase().contains(expectedKeyword.toLowerCase()) ?? false) ||
              (step.insight?.toLowerCase().contains(expectedKeyword.toLowerCase()) ?? false) ||
              (step.latexEquation?.toLowerCase().contains(expectedKeyword.toLowerCase()) ?? false));
          expect(
            found,
            isTrue,
            reason: '$filename must contain corollary relating to "$expectedKeyword"',
          );
        }

        // Check that raw markdown contains at least two "### Corollario" sections with proofs
        final corollaryHeadingCount = RegExp(r'^###\s+Corollario\b', multiLine: true).allMatches(rawMarkdown).length;
        expect(
          corollaryHeadingCount,
          greaterThanOrEqualTo(2),
          reason: '$filename raw markdown must contain at least 2 ### Corollario headings, found $corollaryHeadingCount',
        );

        final proofHeadingCount = RegExp(r'^####\s+Dimostrazione', multiLine: true).allMatches(rawMarkdown).length;
        expect(
          proofHeadingCount,
          greaterThanOrEqualTo(2),
          reason: '$filename raw markdown must contain at least 2 #### Dimostrazione sections for corollaries, found $proofHeadingCount',
        );

        // Verify that corollaries have derivations (equations and/or insights)
        for (final coroStep in corollarySteps) {
          final hasEquation = coroStep.latexEquation != null && coroStep.latexEquation!.trim().isNotEmpty;
          final hasInsight = coroStep.insight != null && coroStep.insight!.trim().isNotEmpty;
          expect(
            hasEquation || hasInsight,
            isTrue,
            reason: 'Corollary step "${coroStep.description}" in $filename must have a derivation or insight',
          );
        }
      }
    });

    test('Verify exact parity between Linear Algebra markdown frontmatter and CurriculumRegistry fallbacks', () {
      final registryNodes = {
        for (final n in CurriculumRegistry.getAllNodes()) n.serverId: n
      };

      for (final filename in expectedFiles) {
        final file = File('assets/content/linear_algebra/$filename');
        final rawMarkdown = file.readAsStringSync();
        final parsedNode = MarkdownContentParser.parse(rawMarkdown);

        final fallbackNode = registryNodes[parsedNode.serverId];
        expect(fallbackNode, isNotNull, reason: 'Fallback node for ${parsedNode.serverId} must exist in CurriculumRegistry');
        expect(fallbackNode!.title, parsedNode.title, reason: 'Title parity for ${parsedNode.serverId}');
        expect(fallbackNode.category, parsedNode.category, reason: 'Category parity for ${parsedNode.serverId}');
        expect(fallbackNode.subCategory, parsedNode.subCategory, reason: 'SubCategory parity for ${parsedNode.serverId}');

        final regPrereqs = CurriculumRegistry.prerequisiteMap[parsedNode.serverId] ?? [];
        expect(
          regPrereqs,
          parsedNode.tempPrerequisiteIds,
          reason: 'Prerequisite list parity for ${parsedNode.serverId}',
        );
      }
    });

    test('Verify sequential prerequisite chain across the 5 Linear Algebra nodes', () {
      final file1 = File('assets/content/linear_algebra/lin_alg_01_tuples.md');
      final file2 = File('assets/content/linear_algebra/lin_alg_02_vectors.md');
      final file3 = File('assets/content/linear_algebra/lin_alg_03_operations.md');
      final file4 = File('assets/content/linear_algebra/lin_alg_04_span.md');
      final file5 = File('assets/content/linear_algebra/lin_alg_05_independence.md');

      final n1 = MarkdownContentParser.parse(file1.readAsStringSync());
      final n2 = MarkdownContentParser.parse(file2.readAsStringSync());
      final n3 = MarkdownContentParser.parse(file3.readAsStringSync());
      final n4 = MarkdownContentParser.parse(file4.readAsStringSync());
      final n5 = MarkdownContentParser.parse(file5.readAsStringSync());

      expect(n1.tempPrerequisiteIds, containsAll(['mat_add_01', 'mat_pythagoras_01']));
      expect(n2.tempPrerequisiteIds, contains('lin_alg_01_tuples'));
      expect(n3.tempPrerequisiteIds, contains('lin_alg_02_vectors'));
      expect(n4.tempPrerequisiteIds, contains('lin_alg_03_operations'));
      expect(n5.tempPrerequisiteIds, contains('lin_alg_04_span'));
    });
  });

  group('Adversarial Stress-Testing: InteractiveTemplateFactory Resolution', () {
    test('All Linear Algebra template keys and synonyms resolve to Vector2DSimulationWidget', () {
      final keys = [
        'vector_2d',
        'vector_addition',
        'linear_combination',
        'span_2d',
        'vector_simulation',
        'vector_span',
        'vector_space',
        'vettori_2d',
        'somma_vettoriale',
        'combinazione_lineare',
      ];

      for (final key in keys) {
        final data = InteractiveData()..templateType = key;
        final widget = InteractiveTemplateFactory.buildWidget(data);
        expect(
          widget,
          isA<Vector2DSimulationWidget>(),
          reason: 'Key "$key" must instantiate Vector2DSimulationWidget',
        );
      }
    });

    test('Null, empty, and invalid template types handle gracefully without exceptions', () {
      expect(InteractiveTemplateFactory.buildWidget(null), isNull);

      final emptyData = InteractiveData()..templateType = '';
      expect(InteractiveTemplateFactory.buildWidget(emptyData), isNull);

      final unknownData = InteractiveData()..templateType = 'non_existent_super_widget';
      expect(InteractiveTemplateFactory.buildWidget(unknownData), isNull);
    });

    test('Unknown template with fallback parameters delegates to LiveEquationWidget', () {
      final fallbackData = InteractiveData()
        ..templateType = 'unknown_but_has_equations'
        ..equations = ['x + 1']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'x'
            ..defaultValue = 1.0,
        ];
      final widget = InteractiveTemplateFactory.buildWidget(fallbackData);
      expect(widget, isNotNull);
      expect(widget.runtimeType.toString(), 'LiveEquationWidget');
    });
  });

  group('Adversarial Stress-Testing: MarkdownContentParser Robustness', () {
    test('Handles adversarial formatting: tabs, Windows CRLF line endings, extra whitespace', () {
      const crlfMarkdown =
          "---\r\nid: test_node\r\ntitle: \"Test Title\"\r\ncategory: \"Matematica\"\r\nsubCategory: \"Algebra Lineare\"\r\nprerequisites:\r\n  - mat_add_01\r\ninteractive:\r\n  template: vector_2d\r\n---\r\n\r\nBody text\r\n\r\n## Dimostrazione: Teorema\r\n\r\n### Passaggio 1\r\n\$\$x = 1\$\$\r\n> **Insight:** Esempio\r\n\r\n### Corollario: Primo\r\n\$\$y = 2\$\$\r\n#### Dimostrazione del Corollario\r\n\$\$y - 1 = 1\$\$\r\n> **Insight:** Dimostrato\r\n\r\n### Corollario: Secondo\r\n\$\$z = 3\$\$\r\n#### Dimostrazione del Corollario\r\n\$\$z - 2 = 1\$\$\r\n";

      final node = MarkdownContentParser.parse(crlfMarkdown);
      expect(node.serverId, 'test_node');
      expect(node.title, 'Test Title');
      expect(node.category, 'Matematica');
      expect(node.subCategory, 'Algebra Lineare');
      expect(node.tempPrerequisiteIds, ['mat_add_01']);
      expect(node.interactiveData?.templateType, 'vector_2d');
      expect(node.algebraicProof.length, greaterThanOrEqualTo(3));
    });

    test('Bracket style prerequisites parsing vs dash YAML list parsing', () {
      const bracketMarkdown = '''
---
id: test_bracket
title: "Bracket Prerequisites"
category: "Matematica"
prerequisites: [mat_add_01, mat_pythagoras_01]
---
# Content
''';
      final node = MarkdownContentParser.parse(bracketMarkdown);
      expect(node.serverId, 'test_bracket');
      expect(node.tempPrerequisiteIds, ['mat_add_01', 'mat_pythagoras_01']);
    });

    test('Handles malformed frontmatter and boundary conditions safely', () {
      // Missing end delimiter
      const malformed1 = '''
---
id: unclosed
title: "No Closing Delimiter"
Some markdown directly
''';
      final n1 = MarkdownContentParser.parse(malformed1);
      expect(n1.serverId, ''); // Graceful fallback

      // Completely empty string
      final n2 = MarkdownContentParser.parse('');
      expect(n2.serverId, '');
      expect(n2.title, '');
      expect(n2.blocks, isEmpty);
      expect(n2.algebraicProof, isEmpty);

      // Whitespace only
      final n3 = MarkdownContentParser.parse('   \n\t\r\n   ');
      expect(n3.serverId, '');
    });

    test('Extracts LaTeX with complex matrices and delimiters in corollaries', () {
      const matrixMarkdown = r'''
---
id: matrix_test
title: "Matrix Proof"
category: "Matematica"
---
## Dimostrazione: Teorema Principale

### 1. Definizione Matrice
$$\det \begin{pmatrix} a & b \\ c & d \end{pmatrix} = ad - bc$$

### Corollario: Invertibilita Matrice 2x2
$$\det A \neq 0 \iff \exists A^{-1}$$
#### Dimostrazione del Corollario
$$A^{-1} = \frac{1}{ad - bc} \begin{pmatrix} d & -b \\ -c & a \end{pmatrix}$$
> **Insight:** La matrice inversa esiste se e solo se il determinante e non nullo.
''';

      final node = MarkdownContentParser.parse(matrixMarkdown);
      expect(node.algebraicProof.length, greaterThanOrEqualTo(2));
      final coroSteps = node.algebraicProof.where((s) => s.description?.contains('Corollario') ?? false).toList();
      expect(coroSteps.isNotEmpty, isTrue);
      final hasMatrix = coroSteps.any((s) => s.latexEquation?.contains(r'\begin{pmatrix}') ?? false);
      expect(hasMatrix, isTrue, reason: 'Parser must preserve LaTeX matrix syntax in corollary steps');
    });
  });
}
