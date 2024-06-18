import 'package:hcq/models/userAnswer.dart';
import 'package:hcq/widgets/story_elements.dart';

class StoryBrain {
  int _currentQuestionIndex = 0;
  List<UserAnswer> _userAnswers = [];
  final List<StoryElement> _storyData = StoryElements.storyData;

  String getCurrentQuestion() {
    return _storyData[_currentQuestionIndex].questionText;
  }

  List<String> getCurrentChoices() {
    return _storyData[_currentQuestionIndex].choices;
  }

  void submitAnswer(int choiceIndex) {
    bool isCorrect =
        _storyData[_currentQuestionIndex].correctAnswerIndex == choiceIndex;
    _userAnswers.add(UserAnswer(
      questionIndex: _currentQuestionIndex,
      selectedAnswerIndex: choiceIndex,
      isCorrect: isCorrect,
    ));

    if (_currentQuestionIndex < _storyData.length - 1) {
      _currentQuestionIndex++;
    } else {
      _currentQuestionIndex = _storyData
          .length; // Set index beyond the last question to indicate end
    }
  }

  bool isCorrect(int questionIndex, int choiceIndex) {
    return _storyData[questionIndex].correctAnswerIndex == choiceIndex;
  }

  List<UserAnswer> getUserAnswers() {
    return _userAnswers;
  }

  bool isEnd() {
    return _currentQuestionIndex >= _storyData.length;
  }

  void restart() {
    _currentQuestionIndex = 0;
    _userAnswers = [];
  }

  int getCurrentQuestionIndex() {
    return _currentQuestionIndex;
  }

  int getTotalQuestions() {
    return _storyData.length;
  }

  int getCorrectAnswersCount() {
    return _userAnswers.where((answer) => answer.isCorrect).length;
  }
}
