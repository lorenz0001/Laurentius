import '../../domain/models/knowledge_node.dart';

/// Pure Dart parser for decoupled Markdown educational content.
///
/// Parses YAML frontmatter into [KnowledgeNode] metadata,
/// [InteractiveData] and [InteractiveParameter] bindings,
/// and converts Markdown/LaTeX body text into [ContentBlock]s
/// and [ProofStep]s without any external package dependencies.
class MarkdownContentParser {
  /// Parses a raw Markdown string with optional YAML frontmatter into a [KnowledgeNode].
  static KnowledgeNode parse(String rawMarkdown) {
    final node = KnowledgeNode()
      ..serverId = ''
      ..title = ''
      ..category = ''
      ..lastUpdated = DateTime.now();

    if (rawMarkdown.trim().isEmpty) {
      return node;
    }

    final trimmed = rawMarkdown.trim();
    String frontmatter = '';
    String body = trimmed;

    if (trimmed.startsWith('---')) {
      final secondDelim = trimmed.indexOf('---', 3);
      if (secondDelim != -1) {
        frontmatter = trimmed.substring(3, secondDelim).trim();
        body = trimmed.substring(secondDelim + 3).trim();
      }
    }

    // 1. Parse YAML Frontmatter
    if (frontmatter.isNotEmpty) {
      _parseFrontmatter(frontmatter, node);
    }

    // 2. Parse Body Blocks and Proof Steps
    if (body.isNotEmpty) {
      _parseBody(body, node);
    }

    return node;
  }

  static void _parseFrontmatter(String frontmatter, KnowledgeNode node) {
    final lines = frontmatter.split('\n');
    String currentKey = '';
    String currentSubKey = '';
    Map<String, dynamic>? currentParam;
    final interactiveParams = <InteractiveParameter>[];
    final interactiveEquations = <String>[];
    final prerequisites = <String>[];
    String? templateType;
    String? outputUnit;
    bool hasInteractiveSection = false;

    for (var rawLine in lines) {
      final line = rawLine.trimRight();
      if (line.trim().isEmpty || line.trim().startsWith('#')) continue;

      final indent = rawLine.length - rawLine.trimLeft().length;

      if (indent == 0) {
        currentKey = '';
        currentSubKey = '';
        final colonIdx = line.indexOf(':');
        if (colonIdx != -1) {
          final key = line.substring(0, colonIdx).trim();
          final value = line.substring(colonIdx + 1).trim();
          currentKey = key;

          if (key == 'id') {
            node.serverId = _stripQuotes(value);
          } else if (key == 'title') {
            node.title = _stripQuotes(value);
          } else if (key == 'category') {
            node.category = _stripQuotes(value);
          } else if (key == 'subCategory') {
            final cleaned = _stripQuotes(value);
            node.subCategory = cleaned.isNotEmpty ? cleaned : null;
          } else if (key == 'prerequisites') {
            if (value.startsWith('[') && value.endsWith(']')) {
              final inner = value.substring(1, value.length - 1).trim();
              if (inner.isNotEmpty) {
                final parts = inner
                    .split(',')
                    .map((p) => _stripQuotes(p.trim()))
                    .where((p) => p.isNotEmpty);
                prerequisites.addAll(parts);
              }
            }
          } else if (key == 'interactive') {
            hasInteractiveSection = true;
          }
        }
      } else if (currentKey == 'prerequisites') {
        final trimmedLine = line.trim();
        if (trimmedLine.startsWith('-')) {
          final prereq = _stripQuotes(trimmedLine.substring(1).trim());
          if (prereq.isNotEmpty) prerequisites.add(prereq);
        }
      } else if (currentKey == 'interactive') {
        hasInteractiveSection = true;
        final trimmedLine = line.trim();

        if (currentSubKey == 'parameters') {
          if (trimmedLine.startsWith('-')) {
            if (currentParam != null) {
              interactiveParams.add(_buildParameter(currentParam));
            }
            currentParam = {};
            final rest = trimmedLine.substring(1).trim();
            if (rest.contains(':')) {
              final colonIdx = rest.indexOf(':');
              final pKey = rest.substring(0, colonIdx).trim();
              final pVal = _stripQuotes(rest.substring(colonIdx + 1).trim());
              currentParam[pKey] = pVal;
            }
          } else if (currentParam != null && trimmedLine.contains(':')) {
            final colonIdx = trimmedLine.indexOf(':');
            final pKey = trimmedLine.substring(0, colonIdx).trim();
            final pVal = _stripQuotes(
              trimmedLine.substring(colonIdx + 1).trim(),
            );
            currentParam[pKey] = pVal;
          } else if (trimmedLine.startsWith('equations:')) {
            if (currentParam != null) {
              interactiveParams.add(_buildParameter(currentParam));
              currentParam = null;
            }
            currentSubKey = 'equations';
          } else if (trimmedLine.startsWith('template:') ||
              trimmedLine.startsWith('templateType:')) {
            if (currentParam != null) {
              interactiveParams.add(_buildParameter(currentParam));
              currentParam = null;
            }
            currentSubKey = '';
            templateType = _stripQuotes(
              trimmedLine.substring(trimmedLine.indexOf(':') + 1).trim(),
            );
          } else if (trimmedLine.startsWith('unit:')) {
            if (currentParam != null) {
              interactiveParams.add(_buildParameter(currentParam));
              currentParam = null;
            }
            currentSubKey = '';
            outputUnit = _stripQuotes(
              trimmedLine.substring(trimmedLine.indexOf(':') + 1).trim(),
            );
          }
        } else if (currentSubKey == 'equations') {
          if (trimmedLine.startsWith('-')) {
            final eq = _stripQuotes(trimmedLine.substring(1).trim());
            if (eq.isNotEmpty) interactiveEquations.add(eq);
          } else if (trimmedLine.startsWith('parameters:')) {
            currentSubKey = 'parameters';
          } else if (trimmedLine.startsWith('template:') ||
              trimmedLine.startsWith('templateType:')) {
            currentSubKey = '';
            templateType = _stripQuotes(
              trimmedLine.substring(trimmedLine.indexOf(':') + 1).trim(),
            );
          } else if (trimmedLine.startsWith('unit:')) {
            currentSubKey = '';
            outputUnit = _stripQuotes(
              trimmedLine.substring(trimmedLine.indexOf(':') + 1).trim(),
            );
          }
        } else if (trimmedLine.startsWith('template:') ||
            trimmedLine.startsWith('templateType:')) {
          final val = trimmedLine
              .substring(trimmedLine.indexOf(':') + 1)
              .trim();
          templateType = _stripQuotes(val);
        } else if (trimmedLine.startsWith('unit:')) {
          final val = trimmedLine
              .substring(trimmedLine.indexOf(':') + 1)
              .trim();
          outputUnit = _stripQuotes(val);
        } else if (trimmedLine.startsWith('equations:')) {
          currentSubKey = 'equations';
        } else if (trimmedLine.startsWith('parameters:')) {
          currentSubKey = 'parameters';
        }
      }
    }

    if (currentParam != null) {
      interactiveParams.add(_buildParameter(currentParam));
    }

    node.tempPrerequisiteIds = prerequisites;

    if (hasInteractiveSection &&
        (templateType != null ||
            interactiveEquations.isNotEmpty ||
            interactiveParams.isNotEmpty ||
            outputUnit != null)) {
      node.interactiveData = InteractiveData()
        ..templateType = templateType
        ..unit = outputUnit
        ..equations = interactiveEquations.isNotEmpty
            ? interactiveEquations
            : null
        ..parameters = interactiveParams.isNotEmpty ? interactiveParams : null;
    }
  }

  static void _parseBody(String body, KnowledgeNode node) {
    final demoRegex = RegExp(r'^##\s+Dimostrazione.*$', caseSensitive: false, multiLine: true);
    final firstDemoMatch = demoRegex.firstMatch(body);

    final preProof = firstDemoMatch != null
        ? body.substring(0, firstDemoMatch.start).trim()
        : body.trim();
    final proofPart = firstDemoMatch != null
        ? body.substring(firstDemoMatch.start).trim()
        : '';

    // 1. Parse Pre-Proof Blocks
    final blocks = <ContentBlock>[];
    if (preProof.isNotEmpty) {
      final rawBlocks = preProof.split(RegExp(r'\n\s*\n'));
      for (final rawBlock in rawBlocks) {
        final b = rawBlock.trim();
        if (b.isEmpty) continue;

        if (b.startsWith(r'$$') && b.endsWith(r'$$')) {
          final latex = b.replaceAll(r'$$', '').trim();
          blocks.add(
            ContentBlock()
              ..type = 'math_latex'
              ..content = latex,
          );
        } else if (b.startsWith('>')) {
          final callout = b
              .replaceAll(
                RegExp(r'^>\s*(\*\*Insight:\*\*|\*\*Intuizione:\*\*)?', multiLine: true),
                '',
              )
              .trim();
          blocks.add(
            ContentBlock()
              ..type = 'info_box'
              ..content = callout,
          );
        } else {
          blocks.add(
            ContentBlock()
              ..type = 'text_markdown'
              ..content = b,
          );
        }
      }
    }
    node.blocks = blocks;

    // 2. Parse Proof Steps across one or multiple ## Dimostrazione sections
    if (proofPart.isNotEmpty) {
      final steps = <ProofStep>[];
      final sectionChunks = proofPart.split(
        RegExp(r'(?=^##\s+Dimostrazione)', caseSensitive: false, multiLine: true),
      );

      for (final section in sectionChunks) {
        final trimmedSection = section.trim();
        if (trimmedSection.isEmpty) continue;

        final lines = trimmedSection.split('\n');
        final firstLine = lines.first.trim();
        String? groupName;

        // Check if a specific sub-demonstration title is provided after colon or dash
        final colonIdx = firstLine.indexOf(':');
        final dashIdx = firstLine.indexOf(' - ');
        if (colonIdx != -1) {
          final name = firstLine.substring(colonIdx + 1).trim();
          if (name.isNotEmpty) groupName = name;
        } else if (dashIdx != -1) {
          final name = firstLine.substring(dashIdx + 3).trim();
          if (name.isNotEmpty) groupName = name;
        }

        final sectionBody = lines.skip(1).join('\n').trim();
        final stepChunks = sectionBody.split(
          RegExp(r'(?=^###\s+)', multiLine: true),
        );

        for (final chunk in stepChunks) {
          final trimmedChunk = chunk.trim();
          if (!trimmedChunk.startsWith('###')) continue;

          final stepLines = trimmedChunk.split('\n');
          final headerLine = stepLines.first
              .replaceFirst(RegExp(r'^###\s+'), '')
              .trim();
          final remaining = stepLines.skip(1).join('\n').trim();

          String? latex;
          String? insight;

          final mathMatch = RegExp(
            r'\$\$(.*?)\$\$',
            dotAll: true,
          ).firstMatch(remaining);
          if (mathMatch != null) {
            latex = mathMatch.group(1)?.trim();
          }

          final insightMatch = RegExp(
            r'>\s*(\*\*Insight:\*\*|\*\*Intuizione:\*\*)?\s*(.*?)(?=(\n|$))',
            dotAll: true,
          ).firstMatch(remaining);
          if (insightMatch != null) {
            insight = insightMatch.group(2)?.trim();
          }

          final finalDesc = groupName != null ? '[$groupName] $headerLine' : headerLine;

          steps.add(
            ProofStep()
              ..description = finalDesc
              ..latexEquation = latex
              ..insight = insight,
          );
        }
      }
      node.algebraicProof = steps;
    }
  }

  static InteractiveParameter _buildParameter(Map<String, dynamic> map) {
    final param = InteractiveParameter();
    param.variableName = map['variable'] ?? map['variableName'] ?? map['name'];
    param.label = map['label'];
    param.unit = map['unit'];
    if (map.containsKey('min') || map.containsKey('minValue')) {
      param.minValue = double.tryParse(
        (map['min'] ?? map['minValue']).toString(),
      );
    }
    if (map.containsKey('max') || map.containsKey('maxValue')) {
      param.maxValue = double.tryParse(
        (map['max'] ?? map['maxValue']).toString(),
      );
    }
    if (map.containsKey('default') || map.containsKey('defaultValue')) {
      param.defaultValue = double.tryParse(
        (map['default'] ?? map['defaultValue']).toString(),
      );
    }
    if (map.containsKey('step') || map.containsKey('stepSize')) {
      param.stepSize = double.tryParse(
        (map['step'] ?? map['stepSize']).toString(),
      );
    }
    return param;
  }

  static String _stripQuotes(String value) {
    var v = value.trim();
    if ((v.startsWith('"') && v.endsWith('"')) ||
        (v.startsWith("'") && v.endsWith("'"))) {
      return v.substring(1, v.length - 1);
    }
    return v;
  }
}
