import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/core/services/ai_tutor_service.dart';
import 'package:laurentius/core/services/app_settings_service.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/pages/node_detail_screen.dart';
import 'package:laurentius/presentation/pages/settings_screen.dart';
import 'package:laurentius/presentation/widgets/ai_rephrase_bottom_sheet.dart';
import 'package:laurentius/presentation/widgets/ai_tutor_qna_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppSettingsService Tests', () {
    test('Defaults and model selection work correctly', () async {
      final model = await AppSettingsService.getModel();
      expect(model, equals('deepseek-v4-flash'));

      final baseUrl = await AppSettingsService.getBaseUrl();
      expect(baseUrl, equals('https://api.deepseek.com'));

      final hasKeyInitial = await AppSettingsService.hasApiKey();
      expect(hasKeyInitial, isFalse);

      await AppSettingsService.setApiKey('sk-test-deepseek-123456');
      final hasKeyAfter = await AppSettingsService.hasApiKey();
      expect(hasKeyAfter, isTrue);

      final key = await AppSettingsService.getApiKey();
      expect(key, equals('sk-test-deepseek-123456'));

      await AppSettingsService.setModel('deepseek-chat');
      final newModel = await AppSettingsService.getModel();
      expect(newModel, equals('deepseek-chat'));
    });

    test('Connection test detects empty key without network request', () async {
      final result = await AppSettingsService.testConnection(apiKey: '  ');
      expect(result.isSuccess, isFalse);
      expect(result.message, contains('Inserisci una chiave API'));
    });
  });

  group('AITutorService Tests', () {
    test('generateExercise generates non-fallacious offline fallback with valid options', () async {
      final service = AITutorService();
      final node = KnowledgeNode()
        ..serverId = 'math_pitagora'
        ..title = 'Teorema di Pitagora'
        ..category = 'Matematica'
        ..subCategory = 'Geometria Euclidea';

      final exercise = await service.generateExercise(node);

      expect(exercise.question, isNotEmpty);
      expect(exercise.options, isNotNull);
      expect(exercise.options!.length, greaterThanOrEqualTo(4));
      // La risposta corretta deve essere esattamente una delle opzioni disponibili
      expect(exercise.options!.contains(exercise.correctAnswer), isTrue);
      // La spiegazione non deve essere vuota
      expect(exercise.explanation, isNotEmpty);
    });

    test('rephraseContent and askQuestion throw descriptive error if API key missing', () async {
      final service = AITutorService();
      final node = KnowledgeNode()
        ..serverId = 'phys_ohm'
        ..title = 'Legge di Ohm'
        ..category = 'Fisica';

      expect(
        () => service.rephraseContent(node, 'Semplifica'),
        throwsA(isA<Exception>()),
      );

      expect(
        () =>
            service.askQuestionAboutNode(node, 'Qual è il significato fisico?'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('UI & Widget Tests for AI Features', () {
    testWidgets('SettingsScreen renders key inputs and DeepSeek model chips', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Impostazioni AI & DeepSeek'), findsOneWidget);
      expect(find.text('Modelli Consigliati:'), findsOneWidget);
      expect(find.text('deepseek-v4-flash'), findsWidgets);
      expect(find.text('deepseek-chat'), findsOneWidget);
      expect(find.text('Testa Chiave API'), findsOneWidget);
      expect(
        find.byType(TextField),
        findsNWidgets(3),
      ); // API Key, Model & Base URL
    });

    testWidgets(
      'NodeDetailScreen renders AI pencil and question mark action buttons',
      (tester) async {
        final node = KnowledgeNode()
          ..serverId = 'math_pitagora'
          ..title = 'Teorema di Pitagora'
          ..category = 'Matematica'
          ..subCategory = 'Geometria'
          ..blocks = [
            ContentBlock()
              ..type = 'text_markdown'
              ..content = 'In ogni triangolo rettangolo...',
          ];

        await tester.pumpWidget(
          MaterialApp(home: NodeDetailScreen(node: node)),
        );
        await tester.pumpAndSettle();

        // Verifica presenza icone AppBar: Matita (edit_note_rounded), Punto interrogativo (help_outline_rounded), Quiz (quiz_outlined)
        expect(find.byIcon(Icons.edit_note_rounded), findsOneWidget);
        expect(find.byIcon(Icons.help_outline_rounded), findsOneWidget);
        expect(find.byIcon(Icons.quiz_outlined), findsOneWidget);
        expect(find.text('Teorema di Pitagora'), findsOneWidget);
      },
    );

    testWidgets(
      'AIRephraseBottomSheet renders quick prompt chips and generate button',
      (tester) async {
        final node = KnowledgeNode()
          ..serverId = 'math_pitagora'
          ..title = 'Teorema di Pitagora'
          ..category = 'Matematica'
          ..blocks = [
            ContentBlock()
              ..type = 'text_markdown'
              ..content = 'In ogni triangolo rettangolo...',
          ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AIRephraseBottomSheet(node: node, onApplied: () {}),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Rielaborazione AI del Testo'), findsOneWidget);
        expect(find.text('Genera Anteprima Rielaborata'), findsOneWidget);
        expect(find.byType(ActionChip), findsWidgets);
      },
    );

    testWidgets('AITutorQnABottomSheet renders greeting and suggested doubts', (
      tester,
    ) async {
      final node = KnowledgeNode()
        ..serverId = 'math_pitagora'
        ..title = 'Teorema di Pitagora'
        ..category = 'Matematica';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AITutorQnABottomSheet(node: node)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Chiedi all\'AI Tutor'), findsOneWidget);
      expect(find.textContaining('Laurentius AI Tutor'), findsWidgets);
      expect(find.byType(ActionChip), findsWidgets);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
