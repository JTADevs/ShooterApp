import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'question_widget.dart';


class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _currentIndex = 0;
  final int _totalTime = 20 * 60; // 20 minutes in seconds
  late Timer _timer;
  int _timeLeft = 0;
  int allowedMistakes = 1;
  int currentMistakes = 0;
  bool hasStarted = false;
  List<String> questions = [];
  List<List<String>> options = [];
  List<List<bool>> correctAnswerFlags = []; // Tracking correct answers
  List<bool> answeredCorrectly = []; // Tracking if answers were correct

  @override
  void initState() {
    super.initState();
    _timeLeft = _totalTime;
  }

  Future<void> loadQuestions() async {
    try {
      questions = [];
      options = [];
      correctAnswerFlags = [];
      answeredCorrectly = []; // Initialize for new quiz session

      List<Map<String, dynamic>> sources = [
        {"file": "Assets/uobia.json", "count": 4},
        {"file": "Assets/issf.json", "count": 2},
        {"file": "Assets/regulamin.json", "count": 2},
        {"file": "Assets/prawo_karne.json", "count": 2},
      ];

      for (var source in sources) {
        String data = await rootBundle.loadString(source['file']);
        var jsonData = json.decode(data) as List;
        int count = int.parse(source['count'].toString());
        List<Map<String, dynamic>> selectedQuestions =
            List.from(jsonData.take(count));

        for (var questionData in selectedQuestions) {
          questions.add(questionData['question']);
          List<String> answerOptions = [];
          List<bool> correctAnswers = [];
          for (var answer in questionData['answers']) {
            answerOptions.add(answer['text']);
            correctAnswers.add(answer['isCorrect']);
          }
          options.add(answerOptions);
          correctAnswerFlags.add(correctAnswers);
          answeredCorrectly.add(false); // Initialize as false
        }
      }

      var rand = Random();
      questions.shuffle(rand);
      options.shuffle(rand);
      correctAnswerFlags.shuffle(rand);

      setState(() {
        hasStarted = true;
        _timeLeft = _totalTime;
        startTimer();
      });
    } catch (e) {
      print('Error loading questions: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to load the questions. Please try again."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer.cancel();
          showTimeUpDialog();
        }
      });
    });
  }

  void checkAnswer(int answerIndex, int questionIndex) {
    bool correct = correctAnswerFlags[questionIndex][answerIndex];
    setState(() {
      answeredCorrectly[questionIndex] = correct; // Record the result
      if (!correct) {
        currentMistakes++;
        if (currentMistakes > allowedMistakes) {
          showFailureDialog();
          _timer.cancel();
        }
      }
      if (_currentIndex < questions.length - 1) {
        _currentIndex++;
      } else {
        _timer.cancel();
        showResultDialog();
      }
    });
  }

  void showFailureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Test Failed"),
        content: Text("You have made too many mistakes. Please try again."),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void showResultDialog() {
    bool passed = currentMistakes <= allowedMistakes;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(passed ? "Congratulations!" : "Test Failed"),
        content: Text(passed
            ? "You have passed the test."
            : "You have made too many mistakes. Please try again."),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Time's Up!"),
        content: Text("Your time to complete the test has expired."),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Test - Remaining Time: ${_timeLeft ~/ 60}:${(_timeLeft % 60).toString().padLeft(2, '0')}"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (!hasStarted) ...[
            Center(
              child: ElevatedButton(
                onPressed: () => loadQuestions(),
                child: Text("Start Test"),
              ),
            )
          ] else if (_currentIndex < questions.length) ...[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(questions[_currentIndex],
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            for (int i = 0; i < options[_currentIndex].length; i++)
              ListTile(
                title: Text(options[_currentIndex][i]),
                onTap: () => checkAnswer(i, _currentIndex),
              ),
          ],
          if (hasStarted && _currentIndex >= questions.length) ...[
            Center(
              child: TextButton(
                onPressed: () {
                  showResultDialog();
                },
                child: Text("See Results"),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
