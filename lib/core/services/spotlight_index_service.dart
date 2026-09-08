import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../data/catalog/curriculum_registry.dart';
import '../../domain/models/knowledge_node.dart';
import '../../domain/models/spotlight_result.dart';

/// Motore di indicizzazione predittivo in-memory con ripiegamento dei diacritici italiani
/// e calcolo istantaneo (<1ms) della rilevanza di teoremi, formule, corollari e definizioni.
class SpotlightIndexService {
  final List<SpotlightSearchResult> _index = [];
  bool _isInitialized = false;

  SpotlightIndexService({Isar? isar, List<KnowledgeNode>? preloadedNodes}) {
    if (preloadedNodes != null) {
      indexNodes(preloadedNodes);
    } else if (isar != null) {
      try {
        final nodes = isar.knowledgeNodes.where().findAllSync();
        if (nodes.isNotEmpty) {
          indexNodes(nodes);
        } else {
          indexNodes(CurriculumRegistry.getAllNodes());
        }
      } catch (_) {
        indexNodes(CurriculumRegistry.getAllNodes());
      }
    } else {
      indexNodes(CurriculumRegistry.getAllNodes());
    }
  }

  bool get isInitialized => _isInitialized;
  int get totalIndexedItems => _index.length;

  /// Ripiega i diacritici (accenti) italiani e normalizza la stringa per confronti uniformi.
  /// Es. 'Viète' -> 'viete', 'Bisezione' -> 'bisezione', 'Città' -> 'citta'.
  static String foldDiacritics(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[àáâäãå]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôöõ]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[ñ]'), 'n');
  }

  /// Radice del lemma per gestire desinenze singolare/plurale e maschile/femminile in italiano
  /// (es. 'pura'/'pure' -> 'pur', 'ridotta'/'ridotte' -> 'ridott', 'bisezione'/'bisezioni' -> 'bisezion').
  static String stemItalian(String word) {
    if (word.length >= 4) {
      final last = word[word.length - 1];
      if (last == 'a' || last == 'e' || last == 'i' || last == 'o') {
        return word.substring(0, word.length - 1);
      }
    }
    return word;
  }

  /// Ingestione e indicizzazione completa di una lista di nodi del curriculum.
  void indexNodes(List<KnowledgeNode> nodes) {
    _index.clear();

    for (final node in nodes) {
      _indexTopic(node);
      _indexAlgebraicProofSteps(node);
      _indexContentBlocks(node);
    }

    _isInitialized = true;
  }

  void _indexTopic(KnowledgeNode node) {
    String snippet = node.subCategory ?? node.category;
    String? formula;

    for (final block in node.effectiveBlocks) {
      if (formula == null &&
          block.type == 'math_latex' &&
          block.content != null &&
          block.content!.isNotEmpty) {
        formula = block.content;
      }
      if (block.type == 'text_markdown' &&
          block.content != null &&
          block.content!.trim().isNotEmpty) {
        snippet = block.content!.trim();
        if (snippet.length > 140) {
          snippet = '${snippet.substring(0, 140)}...';
        }
        break;
      }
    }

    _index.add(
      SpotlightSearchResult(
        id: '${node.serverId}#topic',
        nodeId: node.serverId,
        node: node,
        type: SpotlightResultType.topic,
        title: node.title,
        parentTopicTitle: node.title,
        category: node.category,
        subCategory: node.subCategory,
        snippet: snippet,
        latexFormula: formula,
      ),
    );
  }

  void _indexAlgebraicProofSteps(KnowledgeNode node) {
    final proof = node.algebraicProof;
    if (proof.isEmpty) return;

    for (int i = 0; i < proof.length; i++) {
      final step = proof[i];
      final groupName = step.groupName;
      final cleanDesc = step.cleanDescription;
      final corollTitle = step.corollaryTitle;
      final isCorollary = step.isCorollary ||
          (groupName != null &&
              groupName.toLowerCase().contains('corollario')) ||
          cleanDesc.toLowerCase().contains('corollario');

      if (isCorollary) {
        // Indicizza come COROLLARIO
        String title = corollTitle ?? cleanDesc;
        title = title.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
        if (title.toLowerCase().startsWith('corollario:')) {
          title = title.substring(11).trim();
        } else if (title.toLowerCase().startsWith('corollario -')) {
          title = title.substring(12).trim();
        }
        if (title.isEmpty) title = 'Corollario di ${node.title}';

        _index.add(
          SpotlightSearchResult(
            id: '${node.serverId}#coroll_$i',
            nodeId: node.serverId,
            node: node,
            type: SpotlightResultType.corollary,
            title: title,
            parentTopicTitle: node.title,
            category: node.category,
            subCategory: node.subCategory,
            snippet: step.insight ?? cleanDesc,
            latexFormula: step.latexEquation,
            proofStepIndex: i,
            proofGroup: groupName,
          ),
        );
      }

      // Indicizza come TEOREMA / PASSAGGIO DIMOSTRATIVO
      String thmTitle = cleanDesc.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
      if (thmTitle.isEmpty) thmTitle = groupName ?? 'Dimostrazione di ${node.title}';

      _index.add(
        SpotlightSearchResult(
          id: '${node.serverId}#step_$i',
          nodeId: node.serverId,
          node: node,
          type: SpotlightResultType.theorem,
          title: thmTitle,
          parentTopicTitle: node.title,
          category: node.category,
          subCategory: node.subCategory,
          snippet: step.insight ?? cleanDesc,
          latexFormula: step.latexEquation,
          proofStepIndex: i,
          proofGroup: groupName,
        ),
      );

      // Se presente una formula LaTeX esplicita, indicizzala anche come FORMULA
      if (step.latexEquation != null && step.latexEquation!.trim().isNotEmpty) {
        _index.add(
          SpotlightSearchResult(
            id: '${node.serverId}#eq_$i',
            nodeId: node.serverId,
            node: node,
            type: SpotlightResultType.formula,
            title: isCorollary
                ? 'Formula: ${corollTitle ?? cleanDesc}'
                : 'Formula: $cleanDesc',
            parentTopicTitle: node.title,
            category: node.category,
            subCategory: node.subCategory,
            snippet: step.insight ?? cleanDesc,
            latexFormula: step.latexEquation,
            proofStepIndex: i,
            proofGroup: groupName,
          ),
        );
      }
    }
  }

  void _indexContentBlocks(KnowledgeNode node) {
    for (int j = 0; j < node.blocks.length; j++) {
      final block = node.blocks[j];
      final content = block.content?.trim() ?? '';
      if (content.isEmpty) continue;

      final lower = content.toLowerCase();

      // Riconoscimento formule matematiche autonome
      if (block.type == 'math_latex') {
        _index.add(
          SpotlightSearchResult(
            id: '${node.serverId}#block_formula_$j',
            nodeId: node.serverId,
            node: node,
            type: SpotlightResultType.formula,
            title: 'Equazione Fondamentale',
            parentTopicTitle: node.title,
            category: node.category,
            subCategory: node.subCategory,
            snippet: node.title,
            latexFormula: content,
            contentBlockIndex: j,
          ),
        );
      }

      // Riconoscimento definizioni formali
      if (lower.contains('definizione') ||
          lower.contains('si definisce') ||
          lower.contains('definito come')) {
        String defSnippet = content;
        if (defSnippet.length > 140) {
          defSnippet = '${defSnippet.substring(0, 140)}...';
        }
        _index.add(
          SpotlightSearchResult(
            id: '${node.serverId}#block_def_$j',
            nodeId: node.serverId,
            node: node,
            type: SpotlightResultType.definition,
            title: 'Definizione: ${node.title}',
            parentTopicTitle: node.title,
            category: node.category,
            subCategory: node.subCategory,
            snippet: defSnippet,
            contentBlockIndex: j,
          ),
        );
      }
    }
  }

  /// Ricerca istantanea (<1ms) con folding dei diacritici e ranking multilivello.
  List<SpotlightSearchResult> search(String query, {int limit = 30}) {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return const [];

    final foldedQuery = foldDiacritics(cleanQuery);
    final queryTokens = foldedQuery
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    if (queryTokens.isEmpty) return const [];

    final isSearchingCorollary = foldedQuery.contains('corollari');
    final isSearchingTheorem = foldedQuery.contains('teorem') ||
        foldedQuery.contains('dimostraz') ||
        foldedQuery.contains('lemma');
    final isSearchingFormula = foldedQuery.contains('formul') ||
        foldedQuery.contains('equazion') ||
        foldedQuery.contains('identit');
    final isSearchingDefinition = foldedQuery.contains('defin');

    final scoredResults = <SpotlightSearchResult>[];
    final seenIds = <String>{};

    for (final item in _index) {
      final foldedTitle = foldDiacritics(item.title);
      final foldedParent = foldDiacritics(item.parentTopicTitle);
      final foldedSubCat = foldDiacritics(item.subCategory ?? '');
      final foldedCategory = foldDiacritics(item.category);
      final foldedSnippet = foldDiacritics(item.snippet);
      final foldedFormula = foldDiacritics(item.latexFormula ?? '');
      final foldedProofGroup = foldDiacritics(item.proofGroup ?? '');

      double score = 0.0;
      final matchRanges = <TextRange>[];

      // 1. Corrispondenza esatta titolo
      if (foldedTitle == foldedQuery) {
        score += 150.0;
      } else if (foldedTitle.startsWith(foldedQuery)) {
        score += 110.0;
      } else if (foldedTitle.contains(foldedQuery)) {
        score += 85.0;
      }

      // 2. Corrispondenza con token singoli nel titolo
      int titleTokenMatches = 0;
      for (final token in queryTokens) {
        final tokenStem = stemItalian(token);
        final hasExact = foldedTitle.contains(token);
        final hasStem = tokenStem.length >= 3 && foldedTitle.contains(tokenStem);

        if (hasExact || hasStem) {
          score += hasExact ? 35.0 : 30.0;
          titleTokenMatches++;

          // Calcola range di match nel titolo per l'evidenziazione visiva
          final matchStr = hasExact ? token : tokenStem;
          final startIndex = foldedTitle.indexOf(matchStr);
          if (startIndex >= 0 && startIndex + matchStr.length <= item.title.length) {
            matchRanges.add(TextRange(start: startIndex, end: startIndex + matchStr.length));
          }
        }
      }
      if (titleTokenMatches == queryTokens.length && queryTokens.length > 1) {
        score += 25.0;
      }

      // 3. Corrispondenza nel gruppo di dimostrazione o titolo genitore
      for (final token in queryTokens) {
        final tokenStem = stemItalian(token);
        if (foldedProofGroup.contains(token) ||
            (tokenStem.length >= 3 && foldedProofGroup.contains(tokenStem))) {
          score += 40.0;
        }
        if (foldedParent.contains(token) ||
            (tokenStem.length >= 3 && foldedParent.contains(tokenStem))) {
          score += 35.0;
        }
      }

      // 4. Corrispondenza nei metadati di categoria / sottocategoria
      for (final token in queryTokens) {
        final tokenStem = stemItalian(token);
        if (foldedSubCat.contains(token) ||
            (tokenStem.length >= 3 && foldedSubCat.contains(tokenStem))) {
          score += 30.0;
        }
        if (foldedCategory.contains(token) ||
            (tokenStem.length >= 3 && foldedCategory.contains(tokenStem))) {
          score += 20.0;
        }
      }

      // 5. Corrispondenza nella formula LaTeX
      if (foldedFormula.isNotEmpty && foldedFormula.contains(foldedQuery)) {
        score += 40.0;
      }

      // 6. Corrispondenza nello snippet / intuizione
      if (foldedSnippet.contains(foldedQuery)) {
        score += 25.0;
      } else {
        for (final token in queryTokens) {
          final tokenStem = stemItalian(token);
          if (token.length > 2 &&
              (foldedSnippet.contains(token) ||
                  (tokenStem.length >= 3 && foldedSnippet.contains(tokenStem)))) {
            score += 15.0;
          }
        }
      }

      // 7. Modificatori di tipo intenzionale
      if (isSearchingCorollary && item.type == SpotlightResultType.corollary) {
        score += 60.0;
      }
      if (isSearchingTheorem && item.type == SpotlightResultType.theorem) {
        score += 50.0;
      }
      if (isSearchingFormula && item.type == SpotlightResultType.formula) {
        score += 50.0;
      }
      if (isSearchingDefinition && item.type == SpotlightResultType.definition) {
        score += 50.0;
      }

      // Solo risultati con score positivo o match diretto
      if (score > 0) {
        // Piccola preferenza per titoli più specifici e compatti
        score += (60.0 - item.title.length.clamp(0, 60)) * 0.05;

        // Evita duplicati di titoli identici per lo stesso nodo
        final dedupeKey = '${item.nodeId}_${item.type}_${item.title}';
        if (!seenIds.contains(dedupeKey)) {
          seenIds.add(dedupeKey);
          scoredResults.add(
            item.copyWith(
              score: score,
              matchRanges: matchRanges,
            ),
          );
        }
      }
    }

    // Ordina per rilevanza decrescente
    scoredResults.sort((a, b) => b.score.compareTo(a.score));

    if (scoredResults.length > limit) {
      return scoredResults.sublist(0, limit);
    }
    return scoredResults;
  }
}
