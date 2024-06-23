import 'package:hcq/models/user_answer_model.dart';

class Question {
  String id;
  String text;
  List<Answer> answers;

  Question({required this.id, required this.text, required this.answers});

  factory Question.fromJson(Map<String, dynamic> json) {
    List<dynamic> answersJson = json['answers'];
    List<Answer> answers =
        answersJson.map((answerJson) => Answer.fromJson(answerJson)).toList();

    return Question(
      id: json['id'],
      text: json['text'],
      answers: answers,
    );
  }
}
