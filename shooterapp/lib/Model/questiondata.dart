class QuestionData {
  String question;
  List<String> options;
  List<bool> correctAnswers;
  bool answeredCorrectly;

  QuestionData({
    required this.question,
    required this.options,
    required this.correctAnswers,
    this.answeredCorrectly = false,
  });
}
