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
}

@embedded
class ProofStep {
  String? description;
  String? latexEquation;
  String? insight;
}

@embedded
class InteractiveData {
  String? templateType;
  List<String>? equations;
  List<InteractiveParameter>? parameters;
}

@embedded
class InteractiveParameter {
  String? variableName;
  String? label;
  double? minValue;
  double? maxValue;
  double? defaultValue;
  double? stepSize;
}
