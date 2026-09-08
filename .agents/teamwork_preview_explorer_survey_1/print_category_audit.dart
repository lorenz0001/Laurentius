import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final targetCat = args.isNotEmpty ? args[0] : '';
  final file = File('.agents/teamwork_preview_explorer_survey_1/audit_data.json');
  final List<dynamic> data = jsonDecode(file.readAsStringSync());

  for (final item in data) {
    final path = item['file'] as String;
    if (targetCat.isNotEmpty && !path.contains(targetCat)) continue;

    print('================================================================');
    print('TOPIC: ${item['id']}');
    print('PATH: ${item['file']}');
    print('TITLE: ${item['title']}');
    print('CATEGORY: ${item['category']} / ${item['subCategory']}');
    print('DEMONSTRATIONS (${item['demoCount']}):');

    final demos = item['demoSections'] as List<dynamic>;
    if (demos.isEmpty) {
      print('  *** NO DEMONSTRATION SECTIONS FOUND! ***');
    }

    for (final d in demos) {
      print('  - DEMO: ${d['header']} (L${d['line']})');
      final steps = d['steps'] as List<dynamic>;
      for (final s in steps) {
        final isCor = s['isCorollary'] as bool;
        final corMarker = isCor ? ' >>> [COROLLARY]' : '';
        print('    * ${s['header']} (L${s['line']})$corMarker');
        if (isCor) {
          final latex = (s['latex'] as List<dynamic>).join(' ');
          final insight = s['insight'] ?? '';
          print('      FORMULA: $latex');
          print('      INSIGHT: $insight');
        }
      }
    }

    final standalone = item['standaloneCorollaries'] as List<dynamic>;
    if (standalone.isNotEmpty) {
      print('  STANDALONE COROLLARY MENTIONS:');
      for (final sc in standalone) {
        print('    L${sc['line']}: ${sc['text']}');
      }
    }
    print('');
  }
}
