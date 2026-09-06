import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../domain/models/exercise_model.dart';
import '../../domain/models/knowledge_node.dart';

/// Servizio per la generazione dinamica di esercizi tramite AI (DeepSeek o endpoint compatibile OpenAI).
class AITutorService {
  static const String defaultEndpoint = 'https://api.deepseek.com/chat/completions';
  static const String defaultModel = 'deepseek-v4-flash';

  /// Genera un esercizio didattico personalizzato per il nodo indicato e i suoi prerequisiti.
  Future<ExerciseModel> generateExercise(KnowledgeNode node) async {
    final apiKey = dotenv.env['DEEPSEEK_API_KEY']?.trim();
    final baseUrl = dotenv.env['DEEPSEEK_BASE_URL']?.trim() ?? 'https://api.deepseek.com';
    final model = dotenv.env['DEEPSEEK_MODEL']?.trim() ?? defaultModel;
    final endpoint = baseUrl.endsWith('/chat/completions')
        ? baseUrl
        : '$baseUrl/chat/completions';

    // Raccoglie i titoli dei prerequisiti per arricchire il contesto didattico
    final prereqTitles = node.prerequisites.map((p) => p.title).toList();

    // Se la chiave non è impostata o è il placeholder di default, usa il fallback didattico
    if (apiKey == null || apiKey.isEmpty || apiKey == 'tua_chiave_qui') {
      debugPrint('AITutorService: chiave API non configurata in .env, utilizzo fallback didattico offline.');
      await Future.delayed(const Duration(milliseconds: 600));
      return _generateOfflineFallback(node);
    }

    final systemPrompt = '''
Sei un tutor didattico STEM esperto nello stile intuitivo ed educativo di Brilliant.org.
Genera un esercizio stimolante, concettuale o di calcolo pratico, basato sul seguente nodo di conoscenza:
- Argomento Principale: "${node.title}" (Categoria: ${node.category})
- Prerequisiti noti all'utente: ${prereqTitles.isEmpty ? 'Nessun prerequisito specifico' : prereqTitles.join(', ')}

DEVI rispondere ESCLUSIVAMENTE con un JSON valido (senza spiegazioni fuori dal JSON, senza backticks o blocchi ```json).
Struttura del JSON:
{
  "question": "Testo chiaro dell'esercizio in lingua italiana",
  "type": "multiple_choice",
  "options": ["Opzione A", "Opzione B", "Opzione C", "Opzione D"],
  "correctAnswer": "Opzione corretta esatta",
  "explanation": "Spiegazione passo-passo che illustra il ragionamento e l'intuizione fisica/matematica"
}
''';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {
              'role': 'user',
              'content': 'Genera un nuovo esercizio concettuale su "${node.title}".'
            }
          ],
          'temperature': 0.7,
        }),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final choices = data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final content = choices.first['message']?['content']?.toString() ?? '';
          return _parseExerciseJson(content);
        }
      }

      debugPrint('AITutorService: risposta API ${response.statusCode}, fallback in uso.');
    } catch (e) {
      debugPrint('AITutorService: errore durante la chiamata AI ($e), fallback in uso.');
    }

    return _generateOfflineFallback(node);
  }

  /// Pulisce e decodifica la risposta JSON dell'AI anche in presenza di backtick markdown
  ExerciseModel _parseExerciseJson(String rawContent) {
    var cleaned = rawContent.trim();
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    cleaned = cleaned.trim();

    final Map<String, dynamic> json = jsonDecode(cleaned);
    return ExerciseModel.fromJson(json);
  }

  /// Generatore di esercizi offline nel caso il server AI non sia accessibile
  ExerciseModel _generateOfflineFallback(KnowledgeNode node) {
    if (node.serverId.contains('ohm')) {
      return const ExerciseModel(
        question:
            'Un resistore da 10 Ω è collegato a una differenza di potenziale di 30 V. Qual è l\'intensità di corrente che lo attraversa?',
        type: 'multiple_choice',
        options: ['1 A', '2 A', '3 A', '300 A'],
        correctAnswer: '3 A',
        explanation:
            'Applicando la Legge di Ohm (V = R · I), isoliamo la corrente: I = V / R = 30 V / 10 Ω = 3 A. La corrente fluisce proporzionalmente alla tensione applicata e inversamente alla resistenza.',
      );
    } else if (node.serverId.contains('power')) {
      return const ExerciseModel(
        question:
            'Se una lampadina assorbe una corrente di 0.5 A quando è alimentata a 220 V, quanta potenza elettrica dissipa?',
        type: 'multiple_choice',
        options: ['110 W', '440 W', '220 W', '55 W'],
        correctAnswer: '110 W',
        explanation:
            'La potenza elettrica è data dal prodotto tra differenza di potenziale e corrente: P = V · I = 220 V · 0.5 A = 110 Watt.',
      );
    } else if (node.serverId.contains('joule')) {
      return const ExerciseModel(
        question:
            'Una corrente di 2 A scorre in un circuito con resistenza pari a 5 Ω per 10 secondi. Quanto calore viene generato per effetto Joule?',
        type: 'multiple_choice',
        options: ['100 J', '200 J', '40 J', '500 J'],
        correctAnswer: '200 J',
        explanation:
            'Il calore dissipato è dato da Q = R · I² · t = 5 Ω · (2 A)² · 10 s = 5 · 4 · 10 = 200 Joule.',
      );
    }

    return ExerciseModel(
      question:
          'Quale tra le seguenti affermazioni descrive meglio il principio fondamentale di "${node.title}"?',
      type: 'multiple_choice',
      options: [
        'Rappresenta una relazione di proporzionalità diretta tra le grandezze in gioco.',
        'La grandezza dipende unicamente dal tempo di applicazione.',
        'Si tratta di una costante universale invariante in ogni sistema fisico.',
        'Dipende inversamente dal quadrato della distanza geometrica.',
      ],
      correctAnswer:
          'Rappresenta una relazione di proporzionalità diretta tra le grandezze in gioco.',
      explanation:
          'Nell\'ambito di "${node.title}", il modello descrive una dipendenza fondamentale e lineare tra le variabili di stato caratteristiche del sistema.',
    );
  }
}
