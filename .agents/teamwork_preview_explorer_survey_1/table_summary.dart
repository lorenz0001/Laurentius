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

  print('| ID | Titolo | Categoria | Demo Totali | Steps Totali | Corollari Trovati | Tipo Corollario |');
  print('|---|---|---|---|---|---|---|');

  for (final file in files) {
    final raw = file.readAsStringSync();
    final node = MarkdownContentParser.parse(raw);
    final steps = node.algebraicProof ?? [];

    final corSteps = steps.where((s) {
      final d = s.description?.toLowerCase() ?? '';
      return d.contains('corollario');
    }).toList();

    // Check if any demo section header itself is a corollary
    final corSections = <String>[];
    final lines = raw.split('\n');
    for (final line in lines) {
      if ((line.startsWith('## Dimostrazione') || line.startsWith('## dimostrazione')) &&
          line.toLowerCase().contains('corollario')) {
        corSections.add(line);
      }
    }

    final corTitles = corSteps.map((s) => s.description?.replaceAll(RegExp(r'^\[.*?\]\s*'), '')).join('; ');
    final status = corSections.isNotEmpty ? 'Sezione dedicata' : 'Singolo passaggio finale (step N)';

    print('| `${node.serverId}` | ${node.title} | ${node.category} | ${raw.split(RegExp(r'^## Dimostrazione', multiLine: true, caseSensitive: false)).length - 1} | ${steps.length} | ${corSteps.length} (${corTitles}) | $status |');
  }
}
