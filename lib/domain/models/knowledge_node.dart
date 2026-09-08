import 'package:isar/isar.dart';

part 'knowledge_node.g.dart';

@collection
class KnowledgeNode {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String serverId;

  late String title;

  late String category;

  String? subCategory;

  final prerequisites = IsarLinks<KnowledgeNode>();

  List<ProofStep> algebraicProof = [];

  List<ContentBlock> blocks = [];

  InteractiveData? interactiveData;

  late DateTime lastUpdated;

  /// Campo ignorato da Isar, utilizzato temporaneamente durante la deserializzazione JSON
  /// per memorizzare i serverId dei nodi prerequisiti prima di collegarli nel grafo.
  @ignore
  List<String> tempPrerequisiteIds = [];

  /// Restituisce la lista dei blocchi di contenuto.
  /// Se `blocks` è vuota ma è presente `algebraicProof`, converte i passaggi
  /// dimostrativi in blocchi equivalenti per retrocompatibilità didattica.
  @ignore
  List<ContentBlock> get effectiveBlocks {
    if (blocks.isNotEmpty) return blocks;
    final fallbackList = <ContentBlock>[];
    for (final step in algebraicProof) {
      if (step.description != null && step.description!.trim().isNotEmpty) {
        fallbackList.add(
          ContentBlock()
            ..type = 'text_markdown'
            ..content = step.description,
        );
      }
      if (step.latexEquation != null && step.latexEquation!.trim().isNotEmpty) {
        fallbackList.add(
          ContentBlock()
            ..type = 'math_latex'
            ..content = step.latexEquation,
        );
      }
      if (step.insight != null && step.insight!.trim().isNotEmpty) {
        fallbackList.add(
          ContentBlock()
            ..type = 'info_box'
            ..content = step.insight,
        );
      }
    }
    return fallbackList;
  }

  KnowledgeNode();

  factory KnowledgeNode.fromJson(Map<String, dynamic> json) {
    final node = KnowledgeNode()
      ..serverId = json['serverId'] as String? ?? ''
      ..title = json['title'] as String? ?? ''
      ..category = json['category'] as String? ?? ''
      ..subCategory = json['subCategory'] as String?
      ..lastUpdated = json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
          : DateTime.now()
      ..algebraicProof =
          (json['algebraicProof'] as List?)
              ?.map((e) => ProofStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..blocks =
          (json['blocks'] as List?)
              ?.map((e) => ContentBlock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..interactiveData = json['interactiveData'] != null
          ? InteractiveData.fromJson(
              json['interactiveData'] as Map<String, dynamic>,
            )
          : null;

    // Estrazione dei serverId dei prerequisiti (supporta array di stringhe o array di oggetti)
    final rawPrereqs = json['prerequisites'] ?? json['prerequisiteIds'];
    if (rawPrereqs is List) {
      node.tempPrerequisiteIds = rawPrereqs
          .map(
            (e) =>
                e is String ? e : (e is Map ? e['serverId']?.toString() : null),
          )
          .whereType<String>()
          .toList();
    }

    return node;
  }
}

@embedded
class ContentBlock {
  String? type;
  String? content;

  ContentBlock();

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock()
      ..type = json['type'] as String?
      ..content = json['content'] as String?;
  }
}

@embedded
class ProofStep {
  String? description;
  String? latexEquation;
  String? insight;

  ProofStep();

  factory ProofStep.fromJson(Map<String, dynamic> json) {
    return ProofStep()
      ..description = json['description'] as String?
      ..latexEquation = json['latexEquation'] as String?
      ..insight = json['insight'] as String?;
  }
}

/// Estensione non-breaking con getter computati per [ProofStep]
/// (Isar retrocompatibile al 100% senza modifiche allo schema di persistenza).
extension ProofStepExt on ProofStep {
  /// Determina se il passaggio è un corollario o parte di una dimostrazione di corollario.
  bool get isCorollary {
    final desc = description?.toLowerCase() ?? '';
    final ins = insight?.toLowerCase() ?? '';
    return desc.contains('corollario') || ins.contains('corollario');
  }

  /// Estrae il nome del gruppo di dimostrazione dal prefisso [Gruppo], se presente.
  String? get groupName {
    if (description == null) return null;
    final match = RegExp(r'^\[(.*?)\]').firstMatch(description!);
    return match?.group(1)?.trim();
  }

  /// Restituisce la descrizione senza il prefisso [Gruppo].
  String get cleanDescription {
    if (description == null) return '';
    return description!.replaceFirst(RegExp(r'^\[.*?\]\s*'), '').trim();
  }

  /// Estrae il titolo del corollario se il passaggio ne definisce uno.
  String? get corollaryTitle {
    final clean = cleanDescription;
    final match =
        RegExp(r'corollario:\s*(.*)', caseSensitive: false).firstMatch(clean);
    if (match != null && match.group(1)!.trim().isNotEmpty) {
      return match.group(1)!.trim();
    }
    final g = groupName;
    if (g != null) {
      final gMatch = RegExp(
        r'corollario(?:\s*[:-]\s*|\s+)(.*)',
        caseSensitive: false,
      ).firstMatch(g);
      if (gMatch != null && gMatch.group(1)!.trim().isNotEmpty) {
        return gMatch.group(1)!.trim();
      }
    }
    return null;
  }
}

@embedded
class InteractiveData {
  String? templateType;
  String? unit;
  List<String>? equations;
  List<InteractiveParameter>? parameters;

  InteractiveData();

  factory InteractiveData.fromJson(Map<String, dynamic> json) {
    return InteractiveData()
      ..templateType = json['templateType'] as String?
      ..unit = json['unit'] as String?
      ..equations = (json['equations'] as List?)
          ?.map((e) => e.toString())
          .toList()
      ..parameters = (json['parameters'] as List?)
          ?.map((e) => InteractiveParameter.fromJson(e as Map<String, dynamic>))
          .toList();
  }
}

@embedded
class InteractiveParameter {
  String? variableName;
  String? label;
  String? unit;
  double? minValue;
  double? maxValue;
  double? defaultValue;
  double? stepSize;

  InteractiveParameter();

  factory InteractiveParameter.fromJson(Map<String, dynamic> json) {
    return InteractiveParameter()
      ..variableName = json['variableName'] as String?
      ..label = json['label'] as String?
      ..unit = json['unit'] as String?
      ..minValue = (json['minValue'] as num?)?.toDouble()
      ..maxValue = (json['maxValue'] as num?)?.toDouble()
      ..defaultValue = (json['defaultValue'] as num?)?.toDouble()
      ..stepSize = (json['stepSize'] as num?)?.toDouble();
  }
}
