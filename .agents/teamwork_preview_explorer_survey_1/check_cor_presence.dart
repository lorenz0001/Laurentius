import 'dart:io';
import '../../lib/data/content/markdown_content_parser.dart';

void main() {
  final contentDir = Directory('assets/content');
  final files = contentDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.md'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  int missingCorInProof = 0;
  for (final file in files) {
    final raw = file.readAsStringSync();
    final node = MarkdownContentParser.parse(raw);
    final hasCorInProof = (node.algebraicProof ?? []).any(
      (s) =>
          (s.description?.toLowerCase().contains('corollario') ?? false) ||
          (s.insight?.toLowerCase().contains('corollario') ?? false),
    );
    if (!hasCorInProof) {
      print('MISSING COROLLARY IN PROOF: ${node.serverId} (${file.path})');
      missingCorInProof++;
    }
  }
  print('Total files checked: ${files.length}. Missing corollaries in proof: $missingCorInProof');
}
