import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Risultato del test di connessione all'API DeepSeek
class ConnectionTestResult {
  final bool isSuccess;
  final String message;
  final int? statusCode;

  const ConnectionTestResult({
    required this.isSuccess,
    required this.message,
    this.statusCode,
  });
}

/// Servizio per la gestione centralizzata delle impostazioni dell'app
/// e della configurazione dell'API DeepSeek (chiave, modello, endpoint).
class AppSettingsService {
  static const String _keyDeepSeekApiKey = 'deepseek_api_key';
  static const String _keyDeepSeekModel = 'deepseek_model';
  static const String _keyDeepSeekBaseUrl = 'deepseek_base_url';

  static const String defaultModel = 'deepseek-v4-flash';
  static const String defaultBaseUrl = 'https://api.deepseek.com';

  /// Recupera la chiave API (da SharedPreferences o con fallback a .env)
  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final savedKey = prefs.getString(_keyDeepSeekApiKey)?.trim();
    if (savedKey != null && savedKey.isNotEmpty) {
      return savedKey;
    }
    final envKey = dotenv.isInitialized
        ? dotenv.env['DEEPSEEK_API_KEY']?.trim()
        : null;
    if (envKey != null && envKey.isNotEmpty && envKey != 'tua_chiave_qui') {
      return envKey;
    }
    return null;
  }

  /// Verifica se è configurata una chiave API valida (non vuota e non placeholder)
  static Future<bool> hasApiKey() async {
    final key = await getApiKey();
    return key != null && key.isNotEmpty && key != 'tua_chiave_qui';
  }

  /// Salva la chiave API DeepSeek
  static Future<void> setApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDeepSeekApiKey, key.trim());
  }

  /// Recupera il modello DeepSeek (default: deepseek-v4-flash)
  static Future<String> getModel() async {
    final prefs = await SharedPreferences.getInstance();
    final savedModel = prefs.getString(_keyDeepSeekModel)?.trim();
    if (savedModel != null && savedModel.isNotEmpty) {
      return savedModel;
    }
    final envModel = dotenv.isInitialized
        ? dotenv.env['DEEPSEEK_MODEL']?.trim()
        : null;
    if (envModel != null && envModel.isNotEmpty) {
      return envModel;
    }
    return defaultModel;
  }

  /// Salva il modello DeepSeek selezionato
  static Future<void> setModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDeepSeekModel, model.trim());
  }

  /// Recupera l'endpoint base URL (default: https://api.deepseek.com)
  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString(_keyDeepSeekBaseUrl)?.trim();
    if (savedUrl != null && savedUrl.isNotEmpty) {
      return savedUrl;
    }
    final envUrl = dotenv.isInitialized
        ? dotenv.env['DEEPSEEK_BASE_URL']?.trim()
        : null;
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }
    return defaultBaseUrl;
  }

  /// Salva l'endpoint base URL
  static Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDeepSeekBaseUrl, url.trim());
  }

  /// Esegue un test rapido per verificare se la chiave e l'endpoint rispondono correttamente
  static Future<ConnectionTestResult> testConnection({
    required String apiKey,
    String? model,
    String? baseUrl,
  }) async {
    final cleanKey = apiKey.trim();
    if (cleanKey.isEmpty) {
      return const ConnectionTestResult(
        isSuccess: false,
        message: 'Inserisci una chiave API prima di testare la connessione.',
      );
    }

    final targetUrl = (baseUrl != null && baseUrl.trim().isNotEmpty)
        ? baseUrl.trim()
        : defaultBaseUrl;
    final targetModel = (model != null && model.trim().isNotEmpty)
        ? model.trim()
        : defaultModel;

    final endpoint = targetUrl.endsWith('/chat/completions')
        ? targetUrl
        : '$targetUrl/chat/completions';

    try {
      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': 'Bearer $cleanKey',
            },
            body: jsonEncode({
              'model': targetModel,
              'messages': [
                {'role': 'user', 'content': 'Rispondi solo con la parola OK.'},
              ],
              'max_tokens': 5,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return ConnectionTestResult(
          isSuccess: true,
          message:
              'Connessione stabilita con successo a DeepSeek ($targetModel)!',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 401) {
        return const ConnectionTestResult(
          isSuccess: false,
          message: 'Errore 401: Chiave API non valida o non autorizzata.',
          statusCode: 401,
        );
      } else if (response.statusCode == 404) {
        return ConnectionTestResult(
          isSuccess: false,
          message:
              'Errore 404: Modello "$targetModel" o endpoint non trovato. Prova con "deepseek-chat".',
          statusCode: 404,
        );
      } else {
        return ConnectionTestResult(
          isSuccess: false,
          message:
              'Errore server DeepSeek (Codice HTTP ${response.statusCode}).',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ConnectionTestResult(
        isSuccess: false,
        message:
            'Impossibile contattare il server: verifica la connessione internet ($e).',
      );
    }
  }
}
