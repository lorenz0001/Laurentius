import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/content/markdown_content_parser.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/pages/node_detail_screen.dart';
import 'package:laurentius/presentation/widgets/algebraic_proof_widget.dart';

void main() {
  group('ProofStepExt Computed Getters', () {
    test('Correctly identifies corollary from description or insight', () {
      final stepNormal = ProofStep()
        ..description = '1. Costruzione geometrica'
        ..latexEquation = r'a^2 + b^2 = c^2';
      expect(stepNormal.isCorollary, isFalse);

      final stepCoroDesc = ProofStep()
        ..description = '4. Corollario: Formula Risolutiva'
        ..latexEquation = r'x = \frac{-b \pm \sqrt{\Delta}}{2a}';
      expect(stepCoroDesc.isCorollary, isTrue);

      final stepCoroInsight = ProofStep()
        ..description = '2. Deduzione'
        ..insight = 'Questo passaggio costituisce un fondamentale corollario.';
      expect(stepCoroInsight.isCorollary, isTrue);

      final stepGroupCoro = ProofStep()
        ..description = '[Corollario - Metrica Euclidea] 1. Riduzione algebrica';
      expect(stepGroupCoro.isCorollary, isTrue);

      final stepNull = ProofStep();
      expect(stepNull.isCorollary, isFalse);
    });

    test('groupName and cleanDescription correctly handle bracket prefixes', () {
      final stepWithGroup = ProofStep()
        ..description = '[Teorema di Fermat] 1. Definizione di massimo';
      expect(stepWithGroup.groupName, 'Teorema di Fermat');
      expect(stepWithGroup.cleanDescription, '1. Definizione di massimo');

      final stepNoGroup = ProofStep()
        ..description = '1. Definizione di derivata';
      expect(stepNoGroup.groupName, isNull);
      expect(stepNoGroup.cleanDescription, '1. Definizione di derivata');

      final stepNull = ProofStep();
      expect(stepNull.groupName, isNull);
      expect(stepNull.cleanDescription, isEmpty);
    });

    test('corollaryTitle extracts title from cleanDescription or groupName', () {
      final step1 = ProofStep()
        ..description = '4. Corollario: Teorema di Torricelli';
      expect(step1.corollaryTitle, 'Teorema di Torricelli');

      final step2 = ProofStep()
        ..description = '[Teorema] 3. Corollario: Formula Ridotta';
      expect(step2.corollaryTitle, 'Formula Ridotta');

      final step3 = ProofStep()
        ..description = '[Corollario: Formula Senza Tempo] 1. Isolamento di t';
      expect(step3.corollaryTitle, 'Formula Senza Tempo');

      final step4 = ProofStep()
        ..description = '[Corollario - Metrica Euclidea] 1. Passo iniziale';
      expect(step4.corollaryTitle, 'Metrica Euclidea');

      final stepNormal = ProofStep()
        ..description = '[Teorema] 1. Ipotesi';
      expect(stepNormal.corollaryTitle, isNull);
    });
  });

  group('MarkdownContentParser Advanced Proof & Corollary Ingestion', () {
    test('Parses ## Corollario: [Nome] as a distinct group with star avatar tag', () {
      const md = '''---
id: test_coro_group_01
title: "Teorema e Corollario Separato"
category: "Geometria"
---

Introduzione geometrica.

## Dimostrazione: Teorema di Pitagora
### 1. Costruzione dei quadrati
\$\$c^2 = a^2 + b^2\$\$
> **Insight:** Somma delle aree.

## Corollario: Metrica Euclidea e Diagonale del Quadrato
### 1. Ipotesi del triangolo isoscele rettangolo
\$\$a = b = l\$\$
> **Insight:** I due cateti coincidono.

### 2. Sostituzione e calcolo diagonale
\$\$d = \\sqrt{l^2 + l^2} = l\\sqrt{2}\$\$
> **Insight:** Dimostrazione esplicita della diagonale.
''';

      final node = MarkdownContentParser.parse(md);
      expect(node.algebraicProof.length, 3);
      expect(node.algebraicProof[0].groupName, 'Teorema di Pitagora');
      expect(node.algebraicProof[1].groupName, 'Corollario: Metrica Euclidea e Diagonale del Quadrato');
      expect(node.algebraicProof[2].groupName, 'Corollario: Metrica Euclidea e Diagonale del Quadrato');
      expect(node.algebraicProof[1].isCorollary, isTrue);
      expect(node.algebraicProof[2].latexEquation, r'd = \sqrt{l^2 + l^2} = l\sqrt{2}');
    });

    test('Parses ## Dimostrazione: Corollario - [Nome] with dash delimiter', () {
      const md = '''---
id: test_dash_coro_01
title: "Test Dash Corollary"
category: "Fisica"
---

## Dimostrazione: Legge Oraria
### 1. Integrazione dell'accelerazione
\$\$v(t) = v_0 + a t\$\$

## Dimostrazione: Corollario - Formula di Torricelli
### 1. Eliminazione del tempo t
\$\$t = \\frac{v - v_0}{a}\$\$

### 2. Risultato quadratico
\$\$v^2 = v_0^2 + 2 a \\Delta x\$\$
''';

      final node = MarkdownContentParser.parse(md);
      expect(node.algebraicProof.length, 3);
      expect(node.algebraicProof[0].groupName, 'Legge Oraria');
      expect(node.algebraicProof[1].groupName, 'Corollario - Formula di Torricelli');
      expect(node.algebraicProof[2].groupName, 'Corollario - Formula di Torricelli');
      expect(node.algebraicProof[1].isCorollary, isTrue);
    });

    test('Parses multi-step corollary demonstration (#### sub-steps) without dropping formulas', () {
      const md = '''---
id: test_nested_coro_01
title: "Dimostrazione Nidificata"
category: "Algebra"
---

## Dimostrazione Logico-Algebrica

### 1. Teorema fondamentale del completamento del quadrato
\$\$ax^2 + bx + c = 0\$\$
> **Insight:** Passo iniziale.

### 2. Corollario: Formula Ridotta
\$\$x_{1,2} = \\frac{-\\beta \\pm \\sqrt{\\beta^2 - ac}}{a}\$\$
> **Insight:** Formula per b pari.

#### Dimostrazione del Corollario
#### 1. Definizione del parametro beta
\$\$b = 2\\beta \\iff \\beta = \\frac{b}{2}\$\$
> **Insight:** Sostituzione fondamentale.

#### 2. Semplificazione del fattore comune 2
\$\$x = \\frac{-2\\beta \\pm 2\\sqrt{\\beta^2 - ac}}{2a}\$\$
> **Insight:** Il due si elide esattamente.
''';

      final node = MarkdownContentParser.parse(md);
      // Expected: step 1, step 2 (main corollary), sub-step 1, sub-step 2
      expect(node.algebraicProof.length, 4);
      expect(node.algebraicProof[0].cleanDescription, '1. Teorema fondamentale del completamento del quadrato');
      expect(node.algebraicProof[1].cleanDescription, '2. Corollario: Formula Ridotta');
      expect(node.algebraicProof[2].cleanDescription, contains('1. Definizione del parametro beta'));
      expect(node.algebraicProof[2].latexEquation, r'b = 2\beta \iff \beta = \frac{b}{2}');
      expect(node.algebraicProof[3].cleanDescription, contains('2. Semplificazione del fattore comune 2'));
      expect(node.algebraicProof[3].latexEquation, r'x = \frac{-2\beta \pm 2\sqrt{\beta^2 - ac}}{2a}');
      expect(node.algebraicProof[2].isCorollary, isTrue);
      expect(node.algebraicProof[3].isCorollary, isTrue);
    });
  });

  group('AlgebraicProofWidget Deep-Linking & Corollary Badging', () {
    testWidgets('Preselects initialGroup when provided', (tester) async {
      final steps = [
        ProofStep()
          ..description = '[Gruppo A] 1. Primo passaggio A'
          ..latexEquation = 'a = 1',
        ProofStep()
          ..description = '[Gruppo B] 1. Primo passaggio B'
          ..latexEquation = 'b = 2',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlgebraicProofWidget(
              proofSteps: steps,
              initialGroup: 'Gruppo B',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('1. Primo passaggio B'), findsOneWidget);
      expect(find.text('1. Primo passaggio A'), findsNothing);
    });

    testWidgets('Displays gold star icon for corollary group chip', (tester) async {
      final steps = [
        ProofStep()
          ..description = '[Teorema di Carnot] 1. Costruzione'
          ..latexEquation = 'c^2 = a^2 + b^2 - 2ab\\cos\\gamma',
        ProofStep()
          ..description = '[Corollario: Riduzione a Pitagora] 1. Caso retto'
          ..latexEquation = r'\cos(90^\circ) = 0 \implies c^2 = a^2 + b^2',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlgebraicProofWidget(
              proofSteps: steps,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find star icon in corollary group chip
      expect(find.byIcon(Icons.star_rounded), findsWidgets);
      expect(find.text('Corollario: Riduzione a Pitagora'), findsOneWidget);
    });

    testWidgets('targetCorollary auto-selects group and sets initialShowAll true', (tester) async {
      final steps = [
        ProofStep()
          ..description = '[Teorema] 1. Passo 1'
          ..latexEquation = 'x = 1',
        ProofStep()
          ..description = '[Teorema] 2. Passo 2'
          ..latexEquation = 'x = 2',
        ProofStep()
          ..description = '[Corollario: Torricelli] 1. Sub 1'
          ..latexEquation = 'v^2 = v_0^2 + 2ax',
        ProofStep()
          ..description = '[Corollario: Torricelli] 2. Sub 2'
          ..latexEquation = 'v = 0',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlgebraicProofWidget(
              proofSteps: steps,
              targetCorollary: 'Torricelli',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Both steps in Torricelli group should be visible because showAll was set to true
      expect(find.text('1. Sub 1'), findsOneWidget);
      expect(find.text('2. Sub 2'), findsOneWidget);
    });
  });

  group('NodeDetailScreen Deep-Linking & Smooth Scrolling Integration', () {
    testWidgets('Renders NodeDetailScreen with deep-linking parameters without error', (tester) async {
      final node = KnowledgeNode()
        ..serverId = 'test_detail_node'
        ..title = 'Teorema con Corollario'
        ..category = 'Matematica'
        ..algebraicProof = [
          ProofStep()
            ..description = '[Teorema] 1. Primo passo'
            ..latexEquation = 'y = x',
          ProofStep()
            ..description = '[Corollario: De L\'Hopital] 1. Rapporto derivate'
            ..latexEquation = r'\lim \frac{f}{g} = \lim \frac{f^\prime}{g^\prime}',
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: NodeDetailScreen(
            node: node,
            targetProofGroup: 'Corollario: De L\'Hopital',
            targetCorollary: 'De L\'Hopital',
            autoUnlockProof: true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Teorema con Corollario'), findsOneWidget);
      expect(find.text('1. Rapporto derivate'), findsOneWidget);
      expect(find.text('COROLLARIO DEDOTTO'), findsOneWidget);
    });
  });
}
