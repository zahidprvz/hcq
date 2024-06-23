import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcq/models/user_answer_model.dart';
import 'package:hcq/models/user_quiz_model.dart';
import 'package:hcq/utils/colors.dart';

class QuizScreen extends StatefulWidget {
  final String uid; // Current user's UID
  final String quizFilePath; // Path to quiz questions JSON file

  const QuizScreen({super.key, required this.uid, required this.quizFilePath});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Quiz> quizzes = [];
  List<String> userAnswers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
    _checkUserQuizStatus();
  }

  Future<void> _loadQuizzes() async {
    try {
      // Load JSON from assets
      String jsonString = await rootBundle.loadString(widget.quizFilePath);
      // Parse JSON into Dart objects
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> quizzesData = jsonData['quizzes'];

      setState(() {
        quizzes =
            quizzesData.map((quizJson) => Quiz.fromJson(quizJson)).toList();
      });
    } catch (e) {
      print('Error loading quizzes: $e');
      // Handle error loading quizzes
    }
  }

  Future<void> _checkUserQuizStatus() async {
    try {
      // Get Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Reference to user's document in Firestore
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(widget.uid).get();

      if (userDoc.exists) {
        // Explicitly cast data to Map<String, dynamic> to avoid Object type
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('quizzes')) {
          List<dynamic> quizResponses = userData['quizzes'];
          setState(() {
            userAnswers = quizResponses.cast<String>().toList();
          });

          // Check if user has already taken the quiz
          if (quizResponses.isNotEmpty) {
            // Show dialog to ask if user wants to retake the quiz
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: mobileBackgroundColor,
                  title: const Text('Quiz Already Taken'),
                  content: const Text('Do you want to retake the quiz?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'No',
                        style: TextStyle(color: secondaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: secondaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _resetQuiz();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error checking user quiz status: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _submitQuiz() async {
    try {
      // Get Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Reference to user's document in Firestore
      DocumentReference userRef = firestore.collection('users').doc(widget.uid);
      // Create or update user's quiz responses
      await userRef.set({
        'quizzes': userAnswers,
      }, SetOptions(merge: true));
      // Show success message or navigate to next screen
      print('Quiz responses submitted successfully');
    } catch (e) {
      print('Error submitting quiz responses: $e');
      // Handle error submitting quiz responses
    }
  }

  void _updateQuiz() async {
    try {
      // Get Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Reference to user's document in Firestore
      DocumentReference userRef = firestore.collection('users').doc(widget.uid);
      // Update user's existing quiz responses
      await userRef.update({
        'quizzes': userAnswers,
      });
      // Show success message or navigate to next screen
      print('Quiz responses updated successfully');
    } catch (e) {
      print('Error updating quiz responses: $e');
      // Handle error updating quiz responses
    }
  }

  void _resetQuiz() {
    setState(() {
      userAnswers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('Quiz Screen'),
        actions: [
          IconButton(
            onPressed: _submitQuiz,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: secondaryColor,
            ))
          : quizzes.isEmpty
              ? const Center(child: Text('No quizzes available.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var quiz in quizzes)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quiz.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            const SizedBox(height: 12.0),
                            for (var question in quiz.questions)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question.text,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                  for (var answer in question.answers)
                                    AnswerTile(
                                      answer: answer,
                                      isSelected: userAnswers.contains(
                                          '${question.id}:${answer.id}'),
                                      onSelected: (isSelected) {
                                        setState(() {
                                          if (isSelected) {
                                            userAnswers.add(
                                                '${question.id}:${answer.id}');
                                          } else {
                                            userAnswers.remove(
                                                '${question.id}:${answer.id}');
                                          }
                                        });
                                      },
                                    ),
                                  const SizedBox(height: 16.0),
                                ],
                              ),
                            const Divider(thickness: 2.0),
                          ],
                        ),
                      ElevatedButton(
                        onPressed: _submitQuiz,
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: secondaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class AnswerTile extends StatelessWidget {
  final Answer answer;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const AnswerTile({
    Key? key,
    required this.answer,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isSelected
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      title: Text(answer.text),
      onTap: () => onSelected(!isSelected),
    );
  }
}
