import 'dart:convert';
import 'dart:io';

void main() {
  final contentDir = Directory('assets/content');
  final files = contentDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.md'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  final results = <Map<String, dynamic>>[];

  for (final file in files) {
    final relPath = file.path.replaceAll('\\', '/');
    final content = file.readAsStringSync();
    final lines = content.split('\n');

    String id = '';
    String title = '';
    String category = '';
    String subCategory = '';
    List<String> prereqs = [];
    String template = '';

    // Parse frontmatter
    if (content.startsWith('---')) {
      final end = content.indexOf('---', 3);
      if (end != -1) {
        final fmLines = content.substring(3, end).split('\n');
        for (var line in fmLines) {
          final trimmed = line.trim();
          if (trimmed.startsWith('id:')) id = trimmed.substring(3).trim();
          if (trimmed.startsWith('title:')) title = trimmed.substring(6).trim().replaceAll('"', '');
          if (trimmed.startsWith('category:')) category = trimmed.substring(9).trim().replaceAll('"', '');
          if (trimmed.startsWith('subCategory:')) subCategory = trimmed.substring(12).trim().replaceAll('"', '');
          if (trimmed.startsWith('template:')) template = trimmed.substring(9).trim().replaceAll('"', '');
          if (trimmed.startsWith('prerequisites:')) {
            // may be inline or list
            if (trimmed.contains('[') && trimmed.contains(']')) {
              final inner = trimmed.substring(trimmed.indexOf('[') + 1, trimmed.indexOf(']'));
              prereqs.addAll(inner.split(',').map((s) => s.trim().replaceAll('"', '').replaceAll("'", '')).where((s) => s.isNotEmpty));
            }
          }
          if (trimmed.startsWith('- ') && prereqs.isEmpty) {
            // maybe in prereqs block
            // simple check handled below
          }
        }
      }
    }

    // Scan demonstrations and corollaries
    final demoSections = <Map<String, dynamic>>[];
    Map<String, dynamic>? currentDemo;
    Map<String, dynamic>? currentStep;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      final lineNum = i + 1;

      if (line.startsWith('## Dimostrazione') || line.startsWith('## dimostrazione')) {
        if (currentDemo != null) {
          if (currentStep != null) {
            currentDemo['steps'].add(currentStep);
            currentStep = null;
          }
          demoSections.add(currentDemo);
        }
        currentDemo = {
          'header': line,
          'line': lineNum,
          'steps': <Map<String, dynamic>>[],
        };
      } else if (line.startsWith('### ') && currentDemo != null) {
        if (currentStep != null) {
          currentDemo['steps'].add(currentStep);
          currentStep = null;
        }
        final isCorollary = line.toLowerCase().contains('corollario');
        currentStep = {
          'header': line,
          'line': lineNum,
          'isCorollary': isCorollary,
          'latex': <String>[],
          'insight': '',
          'textLines': <String>[],
        };
      } else if (currentStep != null) {
        if (line.startsWith(r'$$')) {
          currentStep['latex'].add(line);
        } else if (line.startsWith('>')) {
          currentStep['insight'] = line;
        } else if (line.isNotEmpty) {
          currentStep['textLines'].add(line);
        }
      }
    }
    if (currentDemo != null) {
      if (currentStep != null) {
        currentDemo['steps'].add(currentStep);
      }
      demoSections.add(currentDemo);
    }

    // Also check for any Corollario outside of demo sections
    final standaloneCorollaries = <Map<String, dynamic>>[];
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.toLowerCase().contains('corollario') && !line.startsWith('id:') && !line.startsWith('title:')) {
        // Check if inside demo sections
        bool inside = false;
        for (final d in demoSections) {
          for (final s in d['steps']) {
            if (s['line'] == i + 1) inside = true;
          }
        }
        if (!inside) {
          standaloneCorollaries.add({
            'line': i + 1,
            'text': line,
          });
        }
      }
    }

    results.add({
      'file': relPath,
      'id': id,
      'title': title,
      'category': category,
      'subCategory': subCategory,
      'template': template,
      'demoCount': demoSections.length,
      'demoSections': demoSections,
      'standaloneCorollaries': standaloneCorollaries,
    });
  }

  final outFile = File('.agents/teamwork_preview_explorer_survey_1/audit_data.json');
  outFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(results));
  print('Audit complete. Saved ${results.length} topics to ${outFile.path}');
}
