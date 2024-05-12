class QuestionData {
  String question;
  List<String> options;
  List<bool> correctAnswers;
  bool answeredCorrectly;
  int selectedOptionIndex; // Add this field for storing the index of the selected option

  QuestionData({
    required this.question,
    required this.options,
    required this.correctAnswers,
    this.answeredCorrectly = false,
    this.selectedOptionIndex =
        -1, // Initialize with -1 indicating no option selected
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswers: List<bool>.from(json['correctAnswers']),
      answeredCorrectly: json['answeredCorrectly'] ?? false,
      selectedOptionIndex: json['selectedOptionIndex'] ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswers': correctAnswers,
      'answeredCorrectly': answeredCorrectly,
      'selectedOptionIndex': selectedOptionIndex,
    };
  }
}
