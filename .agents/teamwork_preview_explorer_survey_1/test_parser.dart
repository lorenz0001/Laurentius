import 'dart:io';
import '../../lib/data/content/markdown_content_parser.dart';

void main() {
  final file = File('assets/content/algebra/quadratics/mat_quad_eq_01.md');
  final node = MarkdownContentParser.parse(file.readAsStringSync());
  print('Title: ${node.title}');
  print('Total proof steps: ${node.algebraicProof?.length}');
  for (final step in node.algebraicProof ?? []) {
    print(' - ${step.description}');
  }
}
