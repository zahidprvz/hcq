import 'package:flutter/material.dart';
import 'package:hcq/models/userAnswer.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/utils/story_brain.dart';
import 'package:hcq/widgets/story_elements.dart';

StoryBrain storyBrain = StoryBrain();

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  void submitAnswer(int choiceIndex) {
    setState(() {
      storyBrain.submitAnswer(choiceIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Journey Through History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: mobileBackgroundColor,
                  title: const Text(
                    'End Game',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text('Are you sure you want to end the game?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          storyBrain.restart();
                        });
                      },
                      child: const Text('End Game',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: storyBrain.isEnd() ? _buildResults() : _buildQuestion(),
      ),
    );
  }

  Widget _buildQuestion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                storyBrain.getCurrentQuestion(),
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        ...storyBrain.getCurrentChoices().asMap().entries.map((entry) {
          int idx = entry.key;
          String choice = entry.value;
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(fontSize: 18.0),
                padding: const EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                submitAnswer(idx);
              },
              child: Text(choice),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: ListView.builder(
            itemCount: storyBrain.getUserAnswers().length,
            itemBuilder: (context, index) {
              UserAnswer answer = storyBrain.getUserAnswers()[index];
              bool isCorrect = answer.isCorrect;
              return ListTile(
                title: Text(
                  StoryElements.storyData[answer.questionIndex].questionText,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Your answer: ${StoryElements.storyData[answer.questionIndex].choices[answer.selectedAnswerIndex]}',
                  style:
                      TextStyle(color: isCorrect ? Colors.green : Colors.red),
                ),
                trailing: isCorrect
                    ? const Icon(Icons.check, color: Colors.green)
                    : const Icon(Icons.close, color: Colors.red),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'You got ${storyBrain.getCorrectAnswersCount()} out of ${storyBrain.getTotalQuestions()} correct!',
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              textStyle: const TextStyle(fontSize: 18.0),
              padding: const EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            onPressed: () {
              setState(() {
                storyBrain.restart();
              });
            },
            child: const Text("Restart"),
          ),
        ),
      ],
    );
  }
}
