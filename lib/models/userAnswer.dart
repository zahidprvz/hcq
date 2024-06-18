class UserAnswer {
  final int questionIndex;
  final int selectedAnswerIndex;
  final bool isCorrect;

  UserAnswer({
    required this.questionIndex,
    required this.selectedAnswerIndex,
    required this.isCorrect,
  });
}
