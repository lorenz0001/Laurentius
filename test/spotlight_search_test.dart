import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/core/services/spotlight_index_service.dart';
import 'package:laurentius/data/catalog/curriculum_registry.dart';
import 'package:laurentius/domain/models/spotlight_result.dart';

void main() {
  group('SpotlightIndexService Unit Tests', () {
    late SpotlightIndexService service;

    setUp(() {
      service = SpotlightIndexService(
        preloadedNodes: CurriculumRegistry.getAllNodes(),
      );
    });

    test('1. Ingestion loads all curriculum nodes with > 100 indexed items', () {
      expect(service.isInitialized, isTrue);
      expect(service.totalIndexedItems, greaterThan(100));
    });

    test('2. Indexes topics correctly with parent topic title and category', () {
      final results = service.search('Aritmetica');
      expect(results, isNotEmpty);
      final topicResult = results.firstWhere(
        (r) => r.type == SpotlightResultType.topic,
      );
      expect(topicResult.nodeId, isNotEmpty);
      expect(topicResult.category, 'Matematica');
      expect('${topicResult.title} ${topicResult.subCategory}', contains('Aritmetica'));
    });

    test('3. Indexes theorems with step headers and proof groups', () {
      final results = service.search('teorema');
      expect(results, isNotEmpty);
      final theoremResult = results.firstWhere(
        (r) => r.type == SpotlightResultType.theorem,
      );
      expect(theoremResult.type, SpotlightResultType.theorem);
      expect(theoremResult.proofStepIndex, isNotNull);
    });

    test('4. Indexes corollaries across curriculum domains', () {
      final results = service.search('corollario', limit: 100);
      expect(results, isNotEmpty);
      final corollaries = results.where(
        (r) => r.type == SpotlightResultType.corollary,
      );
      expect(corollaries.length, greaterThanOrEqualTo(5));

      final domains = corollaries.map((c) => c.category).toSet();
      expect(domains, contains('Matematica'));
    });

    test('5. Indexes LaTeX formulas with latexFormula property', () {
      final results = service.search('formula');
      expect(results, isNotEmpty);
      final formulaResult = results.firstWhere(
        (r) => r.type == SpotlightResultType.formula && r.latexFormula != null,
      );
      expect(formulaResult.latexFormula, isNotEmpty);
    });

    test('6. Italian diacritic folding: "viète" and "viete" return consistent results', () {
      final resultsWithAccent = service.search('viète');
      final resultsWithoutAccent = service.search('viete');

      expect(resultsWithAccent, isNotEmpty);
      expect(resultsWithoutAccent, isNotEmpty);

      // Entrambe le ricerche trovano la voce di Viète come top match
      expect(resultsWithAccent.first.nodeId, equals(resultsWithoutAccent.first.nodeId));
      expect(resultsWithAccent.first.nodeId, 'mat_quad_viete_01');
    });

    test('7. Specific query "bisezione" matches bisezione concepts', () {
      final results = service.search('bisezione');
      expect(results, isNotEmpty);
      final match = results.first;
      final textToCheck = '${match.title} ${match.snippet} ${match.parentTopicTitle}'.toLowerCase();
      expect(textToCheck, contains('bisezione'));
    });

    test('8. Specific query "carabinieri" matches Teorema dei Carabinieri and limit', () {
      final results = service.search('carabinieri');
      expect(results, isNotEmpty);
      final match = results.firstWhere((r) => r.nodeId == 'mat_lim_sinc_01');
      expect(match.parentTopicTitle.toLowerCase(), contains('carabinieri'));
    });

    test('9. Specific query "pura" matches Equazioni Pure and symmetry corollary', () {
      final results = service.search('pura');
      expect(results, isNotEmpty);
      final pureNode = results.firstWhere((r) => r.nodeId == 'mat_quad_pura_01');
      expect(pureNode.title.toLowerCase(), anyOf(contains('pura'), contains('pure')));
    });

    test('10. Specific query "ridotta" matches Formula Ridotta', () {
      final results = service.search('ridotta');
      expect(results, isNotEmpty);
      final match = results.first;
      final fullText = '${match.title} ${match.snippet}'.toLowerCase();
      expect(fullText, contains('ridotta'));
    });

    test('11. Specific query "torricelli" matches Torricelli-Barrow and Kinematics', () {
      final results = service.search('torricelli');
      expect(results, isNotEmpty);
      final nodeIds = results.map((r) => r.nodeId).toSet();
      expect(nodeIds, anyOf(contains('mat_fund_calc_01'), contains('phys_kin_01')));
    });

    test('12. Query "cartesio" matches Regola di Cartesio', () {
      final results = service.search('cartesio');
      expect(results, isNotEmpty);
      expect(results.first.nodeId, 'mat_quad_viete_01');
    });

    test('13. Multi-token scoring and match range calculation', () {
      final results = service.search('formula ridotta');
      expect(results, isNotEmpty);
      final top = results.first;
      expect(top.score, greaterThan(50.0));
      expect(top.matchRanges, isNotEmpty);
    });

    test('14. Empty and non-matching queries handled gracefully', () {
      expect(service.search(''), isEmpty);
      expect(service.search('   '), isEmpty);
      expect(service.search('xyzzzz_non_existent_token_999'), isEmpty);
    });
  });
}
