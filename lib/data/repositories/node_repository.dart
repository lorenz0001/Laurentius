import 'package:isar/isar.dart';
import '../../domain/models/knowledge_node.dart';

class NodeRepository {
  final Isar _isar;

  NodeRepository(this._isar);

  Future<void> saveNode(KnowledgeNode node) async {
    await _isar.writeTxn(() async {
      await _isar.knowledgeNodes.put(node);
      await node.prerequisites.save();
    });
  }

  Future<KnowledgeNode?> getNodeByServerId(String serverId) async {
    return await _isar.knowledgeNodes.getByServerId(serverId);
  }

  Future<List<KnowledgeNode>> getAllNodes() async {
    return await _isar.knowledgeNodes.where().findAll();
  }
}
