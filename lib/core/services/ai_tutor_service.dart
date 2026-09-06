import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/models/exercise_model.dart';
import '../../domain/models/knowledge_node.dart';
import 'app_settings_service.dart';

/// Servizio per l'integrazione didattica avanzata con DeepSeek AI (v4 Flash / Chat).
/// Gestisce la generazione di quiz rigorosi non fallaci, la rielaborazione controllata dei contenuti
/// (tasto matita) e il tutor interattivo contestualizzato (tasto punto interrogativo).
class AITutorService {
  /// Genera un esercizio didattico rigoroso e non fallace tramite DeepSeek AI.
  Future<ExerciseModel> generateExercise(KnowledgeNode node) async {
    final apiKey = await AppSettingsService.getApiKey();
    final model = await AppSettingsService.getModel();
    final baseUrl = await AppSettingsService.getBaseUrl();

    final endpoint = baseUrl.endsWith('/chat/completions')
        ? baseUrl
        : '$baseUrl/chat/completions';

    // Raccoglie i titoli dei prerequisiti per arricchire il contesto didattico
    final prereqTitles = node.prerequisites.map((p) => p.title).toList();

    // Se la chiave non è impostata o è il placeholder di default, usa il fallback didattico
    if (apiKey == null || apiKey.isEmpty || apiKey == 'tua_chiave_qui') {
      debugPrint(
        'AITutorService: chiave API DeepSeek non configurata, utilizzo fallback didattico offline.',
      );
      await Future.delayed(const Duration(milliseconds: 600));
      return _generateOfflineFallback(node);
    }

    final systemPrompt =
        '''
Sei un docente e autore di problemi per competizioni scientifiche e olimpiadi di matematica, con la pedagogia visiva e rigorosa di Brilliant.org.
Il tuo obiettivo è generare un quesito a scelta multipla RIGOROSO, MAI FALLACE E SCIENTIFICAMENTE INOPPUGNABILE, basato sul seguente nodo didattico:
- Titolo del Concetto: "${node.title}"
- Categoria / Materia: ${node.category} ${node.subCategory != null ? '(${node.subCategory})' : ''}
- Prerequisiti noti all'allievo: ${prereqTitles.isEmpty ? 'Concetti di base' : prereqTitles.join(', ')}

REGOLE ASSOLUTE ANTI-FALLACIA:
1. Deve esistere UNA E UNA SOLA risposta matematicamente e fisicamente esatta al 100%.
2. Esegui e verifica i passaggi di calcolo due volte prima di scrivere le 4 opzioni.
3. Le 3 opzioni errate (distrattori) devono rappresentare tipici trabocchetti o errori di comprensione concettuale (es. inversione di segno, scambio numeratore/denominatore, mancata elevazione a potenza, confusione tra grandezze correlate), MAI numeri casuali o ambigui.
4. Fornisci una spiegazione trasparente, dettagliata ed esaustiva che dimostri la validità dell'opzione corretta e smonti i distrattori.

DEVI rispondere ESCLUSIVAMENTE con un JSON valido (senza spiegazioni fuori dal JSON, senza backticks o markdown):
{
  "question": "Testo chiaro, univoco e ben formulato del quesito in lingua italiana",
  "type": "multiple_choice",
  "options": ["Opzione A", "Opzione B", "Opzione C", "Opzione D"],
  "correctAnswer": "Opzione corretta identica a una di quelle elencate",
  "explanation": "Spiegazione passo-passo con formule e deduzioni logiche chiare"
}
''';

    try {
      final response = await http
          .post(
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
                  'content':
                      'Genera un quiz rigoroso e stimolante su "${node.title}".',
                },
              ],
              'temperature':
                  0.5, // Minore temperatura per massimizzare rigore logico
            }),
          )
          .timeout(const Duration(seconds: 14));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        final choices = data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final content =
              choices.first['message']?['content']?.toString() ?? '';
          return _parseExerciseJson(content);
        }
      }

      debugPrint(
        'AITutorService: risposta API ${response.statusCode}, fallback in uso.',
      );
    } catch (e) {
      debugPrint(
        'AITutorService: errore durante la chiamata AI ($e), fallback in uso.',
      );
    }

    return _generateOfflineFallback(node);
  }

  /// Rielabora i blocchi di contenuto teorico di un nodo secondo l'istruzione dell'utente
  /// (Tasto Matita: es. "semplifica", "approfondisci con formule", "aggiungi analogia").
  /// Restituisce la nuova lista di ContentBlock senza intaccare l'animazione interattiva.
  Future<List<ContentBlock>> rephraseContent(
    KnowledgeNode node,
    String instruction,
  ) async {
    final apiKey = await AppSettingsService.getApiKey();
    final model = await AppSettingsService.getModel();
    final baseUrl = await AppSettingsService.getBaseUrl();

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'Chiave API DeepSeek non configurata. Vai nelle Impostazioni (icona ingranaggio) per inserirla.',
      );
    }

    final endpoint = baseUrl.endsWith('/chat/completions')
        ? baseUrl
        : '$baseUrl/chat/completions';

    // Raccoglie i blocchi attuali come testo di contesto
    final currentBlocksText = node.effectiveBlocks
        .map((b) => '[Tipo: ${b.type}]\n${b.content}')
        .join('\n\n---\n\n');

    final systemPrompt =
        '''
Sei un redattore didattico senior di Brilliant.org esperto in divulgazione scientifica e pedagogia intuitiva.
Ti viene chiesto di rielaborare la spiegazione teorica del seguente argomento:
- Argomento: "${node.title}" (Materia: ${node.category})
- Contenuto Attuale:
$currentBlocksText

ISTRUZIONE DELL'UTENTE:
"$instruction"

REGOLE DI GENERAZIONE:
1. Rispondi ESCLUSIVAMENTE con un JSON array di blocchi validi (senza testo prima o dopo, senza backticks).
2. Tipi di blocco ammessi:
   - "text_markdown": spiegazione testuale con elenchi puntati e grassetti
   - "math_latex": formula matematica LaTeX display mode (solo il codice LaTeX puro, senza dollari o delimitatori esterni)
   - "info_box": intuizione didattica, insight pratico o corollario chiave
3. Mantieni intatta la correttezza matematica. Se l'utente chiede di semplificare, usa analogie potenti senza sacrificare la verità scientifica.
4. NON includere widget interattivi o simulazioni, poiché quelle restano invariate.

Formato del JSON:
[
  { "type": "text_markdown", "content": "..." },
  { "type": "math_latex", "content": "..." },
  { "type": "info_box", "content": "..." }
]
''';

    final response = await http
        .post(
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
                'content':
                    'Rielabora il contenuto di "${node.title}" secondo le istruzioni.',
              },
            ],
            'temperature': 0.7,
          }),
        )
        .timeout(const Duration(seconds: 18));

    if (response.statusCode != 200) {
      throw Exception(
        'Errore DeepSeek API (${response.statusCode}): ${utf8.decode(response.bodyBytes)}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(
      utf8.decode(response.bodyBytes),
    );
    final choices = data['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw Exception('Nessuna risposta ricevuta dal modello DeepSeek.');
    }

    final rawContent = choices.first['message']?['content']?.toString() ?? '';
    return _parseBlocksJson(rawContent);
  }

  /// Risponde a una domanda o dubbio dell'utente riguardo al nodo corrente (Tasto Punto Interrogativo).
  Future<String> askQuestionAboutNode(
    KnowledgeNode node,
    String userQuestion,
  ) async {
    final apiKey = await AppSettingsService.getApiKey();
    final model = await AppSettingsService.getModel();
    final baseUrl = await AppSettingsService.getBaseUrl();

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'Chiave API DeepSeek non configurata. Configurala nelle Impostazioni per porre domande all\'assistente.',
      );
    }

    final endpoint = baseUrl.endsWith('/chat/completions')
        ? baseUrl
        : '$baseUrl/chat/completions';

    final currentSummary = node.effectiveBlocks
        .map((b) => b.content)
        .whereType<String>()
        .join('\n');

    final systemPrompt =
        '''
Sei Laurentius AI Tutor, l'assistente didattico brillante, empatico e rigoroso di Brilliant-OS.
Stai guidando uno studente che sta studiando il concetto:
- Argomento: "${node.title}" (${node.category} - ${node.subCategory ?? ''})
- Contenuto del corso:
$currentSummary

LINEE GUIDA PER LA RISPOSTA:
1. Rispondi direttamente alla domanda dello studente in modo chiaro, amichevole e scientificamente ineccepibile.
2. Usa lo stile "first principles" (dai primi principi): non dare definizioni per scontate, mostra l'intuizione geometrica o fisica.
3. Se appropriato, includi formule matematiche o esempi numerici concreti.
4. Formatta la risposta con Markdown pulito (grassetti, liste ed eventualmente formule LaTeX).
''';

    final response = await http
        .post(
          Uri.parse(endpoint),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': model,
            'messages': [
              {'role': 'system', 'content': systemPrompt},
              {'role': 'user', 'content': userQuestion},
            ],
            'temperature': 0.6,
          }),
        )
        .timeout(const Duration(seconds: 16));

    if (response.statusCode != 200) {
      throw Exception(
        'Errore DeepSeek API (${response.statusCode}): ${utf8.decode(response.bodyBytes)}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(
      utf8.decode(response.bodyBytes),
    );
    final choices = data['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw Exception('Nessuna risposta ricevuta dal tutor DeepSeek.');
    }

    return choices.first['message']?['content']?.toString().trim() ?? '';
  }

  /// Pulisce e decodifica la risposta JSON dell'esercizio
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

  /// Pulisce e decodifica la lista JSON dei blocchi rielaborati
  List<ContentBlock> _parseBlocksJson(String rawContent) {
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

    final dynamic parsed = jsonDecode(cleaned);
    if (parsed is List) {
      return parsed
          .map((e) => ContentBlock.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (parsed is Map && parsed['blocks'] is List) {
      return (parsed['blocks'] as List)
          .map((e) => ContentBlock.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Formato JSON inatteso per la lista di blocchi.');
  }

  /// Generatore di esercizi offline nel caso il server AI non sia accessibile
  ExerciseModel _generateOfflineFallback(KnowledgeNode node) {
    if (node.serverId.contains('ohm')) {
      return const ExerciseModel(
        question: 'Un resistore da 10 Ω è collegato a una differenza di potenziale di 30 V. Qual è l\'intensità di corrente che lo attraversa?',
        type: 'multiple_choice',
        options: ['1 A', '2 A', '3 A', '300 A'],
        correctAnswer: '3 A',
        explanation: 'Applicando la Legge di Ohm (V = R · I), isoliamo la corrente: I = V / R = 30 V / 10 Ω = 3 A. La corrente fluisce proporzionalmente alla tensione applicata e inversamente alla resistenza.',
      );
    } else if (node.serverId.contains('power')) {
      return const ExerciseModel(
        question: 'Se una lampadina assorbe una corrente di 0.5 A quando è alimentata a 220 V, quanta potenza elettrica dissipa?',
        type: 'multiple_choice',
        options: ['110 W', '440 W', '220 W', '55 W'],
        correctAnswer: '110 W',
        explanation: 'La potenza elettrica è data dal prodotto tra differenza di potenziale e corrente: P = V · I = 220 V · 0.5 A = 110 Watt.',
      );
    } else if (node.serverId.contains('joule')) {
      return const ExerciseModel(
        question: 'Una corrente di 2 A scorre in un circuito con resistenza pari a 5 Ω per 10 secondi. Quanto calore viene generato per effetto Joule?',
        type: 'multiple_choice',
        options: ['100 J', '200 J', '40 J', '500 J'],
        correctAnswer: '200 J',
        explanation: 'Il calore dissipato è dato da Q = R · I² · t = 5 Ω · (2 A)² · 10 s = 5 · 4 · 10 = 200 Joule.',
      );
    }

    return ExerciseModel(
      question:
          'Quale tra le seguenti affermazioni descrive con esattezza il principio fondamentale di "${node.title}"?',
      type: 'multiple_choice',
      options: [
        'Rappresenta una relazione di dipendenza diretta tra le grandezze di stato.',
        'La grandezza dipende unicamente dall\'intervallo temporale di osservazione.',
        'Si tratta di una proprietà invariante costante in qualunque sistema inerziale.',
        'Dipende inversamente dal cubo della distanza metrica.',
      ],
      correctAnswer: 'Rappresenta una relazione di dipendenza diretta tra le grandezze di stato.',
      explanation:
          'Nell\'ambito di "${node.title}", il modello descrive una dipendenza fondamentale e lineare tra le variabili di stato caratteristiche del sistema.',
    );
  }
}
