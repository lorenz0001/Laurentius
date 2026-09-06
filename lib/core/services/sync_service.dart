import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';

import '../../domain/models/knowledge_node.dart';

/// Servizio di sincronizzazione HTTP Offline-First.
/// Scarica la lista dei nodi dal server remoto ed effettua l'upsert locale in Isar.
class SyncService {
  /// Indirizzo IP e porta del server Python locale
  static const String defaultServerBaseUrl = 'http://10.229.178.148:8000';
  static const String nodesEndpoint = '/api/nodes';

  /// Esegue la sincronizzazione con il server remoto.
  /// Ritorna `true` se la sincronizzazione è avvenuta con successo, `false` se è attiva la modalità offline.
  Future<bool> syncWithServer(Isar isar, {String? baseUrl}) async {
    final effectiveBaseUrl = baseUrl ?? defaultServerBaseUrl;
    final uri = Uri.parse('$effectiveBaseUrl$nodesEndpoint');

    try {
      // 1. Richiesta HTTP con timeout breve per non bloccare l'esperienza offline
      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        // 2. Decodifica UTF-8 sicura dell'array JSON
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is! List) {
          debugPrint(
            'SyncService: payload non conforme (prevista una lista JSON)',
          );
          return false;
        }

        // 3. Deserializzazione dei nodi tramite .fromJson
        final List<KnowledgeNode> newNodes = decoded
            .map((item) => KnowledgeNode.fromJson(item as Map<String, dynamic>))
            .toList();

        if (newNodes.isEmpty) {
          return true;
        }

        // 4. Prima fase: Inserimento o aggiornamento (Upsert) nel database Isar
        await isar.writeTxn(() async {
          for (final node in newNodes) {
            // Mantiene l'ID locale primario esistente se presente, per preservare le relazioni
            final existing = await isar.knowledgeNodes
                .where()
                .serverIdEqualTo(node.serverId)
                .findFirst();
            if (existing != null) {
              node.id = existing.id;
            }
            await isar.knowledgeNodes.put(node);
          }
        });

        // 5. Seconda fase: Risoluzione e collegamento delle dipendenze (Prerequisites Graph)
        await isar.writeTxn(() async {
          for (final node in newNodes) {
            final persistedNode = await isar.knowledgeNodes
                .where()
                .serverIdEqualTo(node.serverId)
                .findFirst();

            if (persistedNode != null) {
              await persistedNode.prerequisites.load();
              persistedNode.prerequisites.clear();

              for (final prereqServerId in node.tempPrerequisiteIds) {
                final prereqNode = await isar.knowledgeNodes
                    .where()
                    .serverIdEqualTo(prereqServerId)
                    .findFirst();

                if (prereqNode != null) {
                  persistedNode.prerequisites.add(prereqNode);
                }
              }

              await persistedNode.prerequisites.save();
            }
          }
        });

        debugPrint(
          'SyncService: sincronizzati con successo ${newNodes.length} nodi da $uri',
        );
        return true;
      } else {
        debugPrint(
          'Offline mode: server ha risposto con codice ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      // Gestione errori Offline Mode (server non raggiungibile, timeout, no internet)
      // I dati locali in Isar rimangono intatti e disponibili.
      debugPrint('Offline mode: failed to sync with server ($e)');
      return false;
    }
  }
}
