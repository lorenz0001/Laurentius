import 'package:flutter/material.dart';
import 'knowledge_node.dart';

/// Tipologia di entità matematica o scientifica indicizzata da Spotlight.
enum SpotlightResultType {
  corollary,
  theorem,
  formula,
  definition,
  topic,
}

/// Risultato di ricerca istantanea Spotlight con metadati e deep-linking.
class SpotlightSearchResult {
  final String id;
  final String nodeId;
  final KnowledgeNode node;
  final SpotlightResultType type;
  final String title;
  final String parentTopicTitle;
  final String category;
  final String? subCategory;
  final String snippet;
  final String? latexFormula;
  final int? proofStepIndex;
  final String? proofGroup;
  final int? contentBlockIndex;
  final double score;
  final List<TextRange> matchRanges;

  const SpotlightSearchResult({
    required this.id,
    required this.nodeId,
    required this.node,
    required this.type,
    required this.title,
    required this.parentTopicTitle,
    required this.category,
    this.subCategory,
    required this.snippet,
    this.latexFormula,
    this.proofStepIndex,
    this.proofGroup,
    this.contentBlockIndex,
    this.score = 0.0,
    this.matchRanges = const [],
  });

  SpotlightSearchResult copyWith({
    String? id,
    String? nodeId,
    KnowledgeNode? node,
    SpotlightResultType? type,
    String? title,
    String? parentTopicTitle,
    String? category,
    String? subCategory,
    String? snippet,
    String? latexFormula,
    int? proofStepIndex,
    String? proofGroup,
    int? contentBlockIndex,
    double? score,
    List<TextRange>? matchRanges,
  }) {
    return SpotlightSearchResult(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      node: node ?? this.node,
      type: type ?? this.type,
      title: title ?? this.title,
      parentTopicTitle: parentTopicTitle ?? this.parentTopicTitle,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      snippet: snippet ?? this.snippet,
      latexFormula: latexFormula ?? this.latexFormula,
      proofStepIndex: proofStepIndex ?? this.proofStepIndex,
      proofGroup: proofGroup ?? this.proofGroup,
      contentBlockIndex: contentBlockIndex ?? this.contentBlockIndex,
      score: score ?? this.score,
      matchRanges: matchRanges ?? this.matchRanges,
    );
  }

  @override
  String toString() =>
      'SpotlightSearchResult(id: $id, type: $type, title: $title, score: $score)';
}
