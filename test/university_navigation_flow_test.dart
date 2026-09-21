import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/university_linear_algebra_course.dart';
import 'package:laurentius/presentation/pages/university/university_courses_screen.dart';
import 'package:laurentius/presentation/pages/university/university_glossary_screen.dart';
import 'package:laurentius/presentation/pages/university/university_lecture_screen.dart';
import 'package:laurentius/presentation/pages/university/university_term_screen.dart';
import 'package:laurentius/presentation/widgets/university/term_visual_example_widget.dart';

Widget _wrapScreen(Widget screen) {
  return MaterialApp(
    theme: ThemeData.dark(),
    home: screen,
  );
}

void main() {
  group('University Course & Term Navigation Tests', () {
    testWidgets('1. UniversityCoursesScreen displays course info, professor name and all 6 lectures', (tester) async {
      tester.view.physicalSize = const Size(1080, 3200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapScreen(const UniversityCoursesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('POLITECNICO DI MILANO'), findsOneWidget);
      expect(find.text('Geometria e Algebra Lineare'), findsOneWidget);
      expect(find.text('Prof. Alexandru Constantinescu'), findsOneWidget);
      expect(find.textContaining('CAPITOLO 1: FONDAMENTI'), findsWidgets);

      // Verify all 6 lectures are rendered
      expect(find.textContaining('LEZIONE 1.1'), findsOneWidget);
      expect(find.textContaining('LEZIONE 1.2'), findsOneWidget);
      expect(find.textContaining('LEZIONE 1.3'), findsOneWidget);
      expect(find.textContaining('LEZIONE 1.4'), findsOneWidget);
      expect(find.textContaining('LEZIONE 1.5'), findsOneWidget);
      expect(find.textContaining('LEZIONE 1.6'), findsOneWidget);
    });

    testWidgets('2. Tapping lecture opens UniversityLectureScreen with back button and content', (tester) async {
      await tester.pumpWidget(_wrapScreen(const UniversityCoursesScreen()));
      await tester.pumpAndSettle();

      // Tap on Lezione 1.1
      await tester.tap(find.textContaining('LEZIONE 1.1'));
      await tester.pumpAndSettle();

      // Verify UniversityLectureScreen is displayed
      expect(find.byType(UniversityLectureScreen), findsOneWidget);
      expect(find.textContaining('Lezione 1.1: Enunciati Matematici'), findsOneWidget);
      expect(find.text('SEZIONE 1.1'), findsOneWidget);
      expect(find.text('pp. 8-16'), findsOneWidget);

      // Verify top back button exists
      final backButton = find.byTooltip('Torna alla lista delle lezioni');
      expect(backButton, findsOneWidget);

      // Tap top back button to return
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify returned to UniversityCoursesScreen
      expect(find.byType(UniversityCoursesScreen), findsOneWidget);
    });

    testWidgets('3. Tapping a key term chip opens UniversityTermScreen with static visual diagram', (tester) async {
      final lecture = UniversityLinearAlgebraCourse.lecture1;
      await tester.pumpWidget(_wrapScreen(UniversityLectureScreen(lecture: lecture)));
      await tester.pumpAndSettle();

      // Find chip for 'Enunciato Matematico'
      final termChip = find.widgetWithText(ActionChip, 'Enunciato Matematico');
      expect(termChip, findsOneWidget);

      // Tap term chip
      await tester.tap(termChip);
      await tester.pumpAndSettle();

      // Verify UniversityTermScreen is displayed
      expect(find.byType(UniversityTermScreen), findsOneWidget);
      expect(find.text('Enunciato Matematico'), findsWidgets);
      expect(find.textContaining('Spiegazione del Docente'), findsOneWidget);
      expect(find.textContaining('DEFINIZIONE FORMALE (KATEX)'), findsOneWidget);

      // Verify TermVisualExampleWidget is rendered
      expect(find.byType(TermVisualExampleWidget), findsOneWidget);

      // Verify top back button returns to lecture
      final backButton = find.byTooltip('Torna alla pagina precedente');
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(UniversityLectureScreen), findsOneWidget);
    });

    testWidgets('4. UniversityTermScreen renders related terms and allows deep navigation', (tester) async {
      tester.view.physicalSize = const Size(1000, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapScreen(const UniversityTermScreen(termId: 'implicazione_logica')));
      await tester.pumpAndSettle();

      expect(find.text('Implicazione Logica'), findsWidgets);
      expect(find.text('TERMINI CORRELATI'), findsOneWidget);

      // Tap on related term chip 'Proposizione Contrapposta'
      final relatedChip = find.widgetWithText(ActionChip, 'Proposizione Contrapposta');
      expect(relatedChip, findsOneWidget);

      await tester.ensureVisible(relatedChip);
      await tester.pumpAndSettle();

      await tester.tap(relatedChip);
      await tester.pumpAndSettle();

      // Now on Contrapposta term screen
      expect(find.text('Proposizione Contrapposta'), findsWidgets);

      // Top back button takes back to Implicazione Logica
      final backButton = find.byTooltip('Torna alla pagina precedente');
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Implicazione Logica'), findsWidgets);
    });

    testWidgets('5. UniversityGlossaryScreen lists all terms and filters by search', (tester) async {
      await tester.pumpWidget(_wrapScreen(const UniversityGlossaryScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Indice Analitico & Glossario Termini'), findsOneWidget);
      expect(find.text('Tutti i Termini'), findsOneWidget);

      // Search for 'Bézout'
      await tester.enterText(find.byType(TextField), 'Bézout');
      await tester.pumpAndSettle();

      expect(find.text('Identità e Lemma di Bézout'), findsOneWidget);
      expect(find.text('Algoritmo Euclideo delle Divisioni Successive'), findsNothing);

      // Clear search
      final clearButton = find.byIcon(Icons.clear_rounded);
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      expect(find.text('Algoritmo Euclideo delle Divisioni Successive'), findsOneWidget);
    });
  });
}
