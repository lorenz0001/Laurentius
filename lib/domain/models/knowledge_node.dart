import 'package:isar/isar.dart';

part 'knowledge_node.g.dart';

@collection
class KnowledgeNode {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String serverId;

  late String title;

  late String category;

  final prerequisites = IsarLinks<KnowledgeNode>();

  List<ProofStep> algebraicProof = [];

  InteractiveData? interactiveData;

  late DateTime lastUpdated;

  /// Campo ignorato da Isar, utilizzato temporaneamente durante la deserializzazione JSON
  /// per memorizzare i serverId dei nodi prerequisiti prima di collegarli nel grafo.
  @ignore
  List<String> tempPrerequisiteIds = [];

  KnowledgeNode();

  factory KnowledgeNode.fromJson(Map<String, dynamic> json) {
    final node = KnowledgeNode()
      ..serverId = json['serverId'] as String? ?? ''
      ..title = json['title'] as String? ?? ''
      ..category = json['category'] as String? ?? ''
      ..lastUpdated = json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
          : DateTime.now()
      ..algebraicProof = (json['algebraicProof'] as List?)
              ?.map((e) => ProofStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..interactiveData = json['interactiveData'] != null
          ? InteractiveData.fromJson(json['interactiveData'] as Map<String, dynamic>)
          : null;

    // Estrazione dei serverId dei prerequisiti (supporta array di stringhe o array di oggetti)
    final rawPrereqs = json['prerequisites'] ?? json['prerequisiteIds'];
    if (rawPrereqs is List) {
      node.tempPrerequisiteIds = rawPrereqs
          .map((e) => e is String ? e : (e is Map ? e['serverId']?.toString() : null))
          .whereType<String>()
          .toList();
    }

    return node;
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

@embedded
class InteractiveData {
  String? templateType;
  List<String>? equations;
  List<InteractiveParameter>? parameters;

  InteractiveData();

  factory InteractiveData.fromJson(Map<String, dynamic> json) {
    return InteractiveData()
      ..templateType = json['templateType'] as String?
      ..equations = (json['equations'] as List?)?.map((e) => e.toString()).toList()
      ..parameters = (json['parameters'] as List?)
          ?.map((e) => InteractiveParameter.fromJson(e as Map<String, dynamic>))
          .toList();
  }
}

@embedded
class InteractiveParameter {
  String? variableName;
  String? label;
  double? minValue;
  double? maxValue;
  double? defaultValue;
  double? stepSize;

  InteractiveParameter();

  factory InteractiveParameter.fromJson(Map<String, dynamic> json) {
    return InteractiveParameter()
      ..variableName = json['variableName'] as String?
      ..label = json['label'] as String?
      ..minValue = (json['minValue'] as num?)?.toDouble()
      ..maxValue = (json['maxValue'] as num?)?.toDouble()
      ..defaultValue = (json['defaultValue'] as num?)?.toDouble()
      ..stepSize = (json['stepSize'] as num?)?.toDouble();
  }
}
