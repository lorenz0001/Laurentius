import 'package:flutter/material.dart';

/// Livello di importanza didattica assegnato dal docente (cfr. pag. 6 appunti PoliMi)
enum LectureColorCode {
  /// Verde: essenziale per il corso e per l'esame
  essential,

  /// Giallo: utile per il corso, ma non centrale
  useful,

  /// Arancione: più avanzato, ma ancora legato al materiale essenziale
  advanced,

  /// Rosso: molto avanzato e astratto (es. Proprietà universali, Categorie, Assioma della Scelta)
  abstractCore,
}

extension LectureColorCodeExt on LectureColorCode {
  Color get color {
    switch (this) {
      case LectureColorCode.essential:
        return const Color(0xFF22C55E); // Green
      case LectureColorCode.useful:
        return const Color(0xFFEAB308); // Yellow
      case LectureColorCode.advanced:
        return const Color(0xFFF97316); // Orange
      case LectureColorCode.abstractCore:
        return const Color(0xFFEF4444); // Red
    }
  }

  String get label {
    switch (this) {
      case LectureColorCode.essential:
        return 'Essenziale per esame';
      case LectureColorCode.useful:
        return 'Utile / Approfondimento';
      case LectureColorCode.advanced:
        return 'Avanzato';
      case LectureColorCode.abstractCore:
        return 'Molto avanzato / Astratto';
    }
  }
}

/// Tipi di diagrammi grafici statici per la visualizzazione intuitiva dei termini matematici
enum VisualDiagramType {
  truthValueDiagram,
  truthTableImplication,
  contrapositiveMatrix,
  subsetsLattice,
  cartesianGrid,
  arrowMappingGeneral,
  arrowMappingInjective,
  arrowMappingSurjective,
  arrowMappingBijective,
  inverseArrows,
  equivalenceGraph,
  partitionBubbles,
  quotientBlocks,
  wellOrderingRay,
  divisionTimeline,
  euclideanLadder,
  moduloClock,
  cayleyTableGrid,
  subgroupVenn,
  permutationBipartite,
  cycleGraph,
  parityGauge,
  cayleyEmbedding,
  ringDoubleStructure,
  fieldStar,
  choiceFunctionBox,
  commutativeDiagram,
}

/// Modello di un termine matematico del glossario ipertestuale
class UniversityTerm {
  final String id;
  final String name;
  final String symbol;
  final String category;
  final String shortDefinition;
  final String formalLatex;
  final String pedagogicalExplanation;
  final VisualDiagramType visualType;
  final String exampleTitle;
  final String exampleText;
  final List<String> relatedTermIds;

  const UniversityTerm({
    required this.id,
    required this.name,
    required this.symbol,
    required this.category,
    required this.shortDefinition,
    required this.formalLatex,
    required this.pedagogicalExplanation,
    required this.visualType,
    required this.exampleTitle,
    required this.exampleText,
    this.relatedTermIds = const [],
  });
}

/// Singola lezione del corso universitario
class UniversityLecture {
  final String id;
  final String number; // es. "1.1", "1.2"
  final String title;
  final String subtitle;
  final String pageRange; // es. "pp. 8-16"
  final LectureColorCode defaultColor;
  final int estimatedMinutes;
  final List<String> keyTermIds;
  final String markdownContent;

  const UniversityLecture({
    required this.id,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.pageRange,
    required this.defaultColor,
    required this.estimatedMinutes,
    required this.keyTermIds,
    required this.markdownContent,
  });
}

/// Capitolo o modulo di un corso universitario
class UniversityChapter {
  final String id;
  final String title;
  final String description;
  final List<UniversityLecture> lectures;

  const UniversityChapter({
    required this.id,
    required this.title,
    required this.description,
    required this.lectures,
  });
}

/// Corso universitario completo
class UniversityCourse {
  final String id;
  final String title;
  final String university;
  final String professor;
  final String academicYear;
  final String semester;
  final String description;
  final List<UniversityChapter> chapters;

  const UniversityCourse({
    required this.id,
    required this.title,
    required this.university,
    required this.professor,
    required this.academicYear,
    required this.semester,
    required this.description,
    required this.chapters,
  });
}
