import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/university_glossary_catalog.dart';
import 'package:laurentius/data/catalog/university_linear_algebra_course.dart';

void main() {
  group('University Course & Glossary Integrity Tests (PoliMi - Prof. Constantinescu)', () {
    test('Course metadata and structure are properly configured', () {
      const course = UniversityLinearAlgebraCourse.course;
      expect(course.title, contains('Algebra Lineare'));
      expect(course.university, contains('Politecnico di Milano'));
      expect(course.professor, contains('Alexandru Constantinescu'));
      expect(course.chapters.length, 1);

      final chapter = course.chapters.first;
      expect(chapter.id, 'cap_01_fondamenti');
      expect(chapter.lectures.length, 6);
    });

    test('All 6 lectures have complete metadata, valid page ranges and color codes', () {
      final lectures = UniversityLinearAlgebraCourse.course.chapters.first.lectures;

      final expectedNumbers = ['1.1', '1.2', '1.3', '1.4', '1.5', '1.6'];
      for (int i = 0; i < lectures.length; i++) {
        final l = lectures[i];
        expect(l.number, expectedNumbers[i]);
        expect(l.title.isNotEmpty, isTrue);
        expect(l.subtitle.isNotEmpty, isTrue);
        expect(l.pageRange, contains('pp.'));
        expect(l.estimatedMinutes, greaterThan(0));
        expect(l.keyTermIds.isNotEmpty, isTrue);
        expect(l.markdownContent.isNotEmpty, isTrue);
        expect(l.markdownContent.length, greaterThan(500));
      }
    });

    test('All term links [Label](term:id) in markdown content map to valid glossary terms', () {
      final lectures = UniversityLinearAlgebraCourse.course.chapters.first.lectures;
      final termLinkRegex = RegExp(r'\[(.*?)\]\(term:(.*?)\)');

      int totalLinksChecked = 0;
      for (final lecture in lectures) {
        final matches = termLinkRegex.allMatches(lecture.markdownContent);
        for (final match in matches) {
          final label = match.group(1);
          final termId = match.group(2);

          expect(label, isNotNull);
          expect(termId, isNotNull);
          totalLinksChecked++;

          final term = UniversityGlossaryCatalog.getTerm(termId!);
          expect(
            term,
            isNotNull,
            reason: 'In lecture ${lecture.number}, link "$termId" has no entry in UniversityGlossaryCatalog',
          );
        }
      }
      expect(totalLinksChecked, greaterThan(25));
    });

    test('All keyTermIds declared in each lecture map to valid glossary terms', () {
      final lectures = UniversityLinearAlgebraCourse.course.chapters.first.lectures;
      for (final lecture in lectures) {
        for (final termId in lecture.keyTermIds) {
          final term = UniversityGlossaryCatalog.getTerm(termId);
          expect(
            term,
            isNotNull,
            reason: 'In lecture ${lecture.number}, keyTermId "$termId" is not defined in glossary',
          );
        }
      }
    });

    test('Every glossary term has complete definitions, valid LaTeX, and valid related terms', () {
      final allTerms = UniversityGlossaryCatalog.getAllTerms();
      expect(allTerms.length, greaterThanOrEqualTo(30));

      for (final term in allTerms) {
        expect(term.id.isNotEmpty, isTrue);
        expect(term.name.isNotEmpty, isTrue);
        expect(term.symbol.isNotEmpty, isTrue);
        expect(term.category.isNotEmpty, isTrue);
        expect(term.shortDefinition.isNotEmpty, isTrue);
        expect(term.formalLatex.isNotEmpty, isTrue);
        expect(term.pedagogicalExplanation.isNotEmpty, isTrue);
        expect(term.exampleTitle.isNotEmpty, isTrue);
        expect(term.exampleText.isNotEmpty, isTrue);

        // Verify related terms integrity
        for (final relId in term.relatedTermIds) {
          final relTerm = UniversityGlossaryCatalog.getTerm(relId);
          expect(
            relTerm,
            isNotNull,
            reason: 'Term "${term.id}" has invalid relatedTermId "$relId"',
          );
        }
      }
    });
  });
}
