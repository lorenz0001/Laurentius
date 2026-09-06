/// Modello per rappresentare un esercizio generato dall'AI Tutor.
class ExerciseModel {
  final String question;
  final String type; // "multiple_choice" o "numeric"
  final List<String>? options;
  final String correctAnswer;
  final String explanation;

  const ExerciseModel({
    required this.question,
    required this.type,
    this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      question: json['question'] as String? ?? '',
      type: json['type'] as String? ?? 'multiple_choice',
      options: (json['options'] as List?)?.map((e) => e.toString()).toList(),
      correctAnswer: json['correctAnswer']?.toString() ?? '',
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'type': type,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}
