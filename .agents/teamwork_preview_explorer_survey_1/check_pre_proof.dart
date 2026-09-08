import 'dart:io';

void main() {
  final contentDir = Directory('assets/content');
  final files = contentDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.md'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    final raw = file.readAsStringSync();
    final lines = raw.split('\n');
    final corollariesInBody = <String>[];
    bool inProof = false;

    for (int i = 0; i < lines.length; i++) {
      final l = lines[i];
      if (l.toLowerCase().startsWith('## dimostrazione')) {
        inProof = true;
      }
      if (!inProof && l.toLowerCase().contains('corollario')) {
        corollariesInBody.add('L${i+1}: $l');
      }
    }
    if (corollariesInBody.isNotEmpty) {
      print('${file.path}:');
      for (final c in corollariesInBody) {
        print('  $c');
      }
    }
  }
}
