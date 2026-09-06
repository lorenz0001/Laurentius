import 'package:flutter_test/flutter_test.dart';
import 'package:graphview/GraphView.dart';

void main() {
  test('Test SugiyamaAlgorithm and DAG with cross-subject links', () {
    final graph = Graph();
    final nodeMathLog = Node.Id('mat_log_01');
    final nodeChemEquil = Node.Id('chem_equil_01');
    final nodeChemPh = Node.Id('chem_ph_01');

    graph.addNode(nodeMathLog);
    graph.addNode(nodeChemEquil);
    graph.addNode(nodeChemPh);

    // Cross-disciplinary: chem_ph requires BOTH chem_equil AND mat_log
    graph.addEdge(nodeChemEquil, nodeChemPh);
    graph.addEdge(nodeMathLog, nodeChemPh);

    final config = SugiyamaConfiguration()
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM
      ..nodeSeparation = 40
      ..levelSeparation = 60;

    final algorithm = SugiyamaAlgorithm(config);
    // Algorithm run check
    expect(graph.nodeCount(), 3);
    expect(graph.edges.length, 2);
    final size = algorithm.run(graph, 10, 10);
    expect(size, isNotNull);
  });
}
