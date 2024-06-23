import 'package:hcq/models/user_question_model.dart';

class Quiz {
  String id;
  String title;
  List<Question> questions;

  Quiz({required this.id, required this.title, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    List<dynamic> questionsJson = json['questions'];
    List<Question> questions = questionsJson
        .map((questionJson) => Question.fromJson(questionJson))
        .toList();

    return Quiz(
      id: json['id'],
      title: json['title'],
      questions: questions,
    );
  }
}
