import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'Model/questiondata.dart';
import 'score_page.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _currentIndex = 0;
  final int _totalTime = 20 * 60; // 20 minutes in seconds
  late Timer _timer;
  int _timeLeft = 0;
  bool hasStarted = false;
  List<QuestionData> allQuestions = [];
  List<QuestionData> wrongAnswers = [];

  @override
  void initState() {
    super.initState();
    _timeLeft = _totalTime;
  }

  Future<void> loadQuestions() async {
    try {
      List<QuestionData> loadedQuestions = [];

      List<Map<String, dynamic>> sources = [
        {"file": "Assets/uobia.json", "count": 4},
        {"file": "Assets/issf.json", "count": 2},
        {"file": "Assets/regulamin.json", "count": 2},
        {"file": "Assets/prawo_karne.json", "count": 2},
      ];

      for (var source in sources) {
        String data = await rootBundle.loadString(source['file']);
        List<dynamic> jsonData = json.decode(data);
        int count = int.parse(source['count'].toString());
        List<dynamic> selectedQuestions = jsonData.take(count).toList();

        for (var questionData in selectedQuestions) {
          loadedQuestions.add(QuestionData(
            question: questionData['question'],
            options: List<String>.from(
                questionData['answers'].map((x) => x['text'])),
            correctAnswers: List<bool>.from(
                questionData['answers'].map((x) => x['isCorrect'])),
          ));
        }
      }

      var rand = Random();
      loadedQuestions.shuffle(rand);

      setState(() {
        allQuestions = loadedQuestions;
        hasStarted = true;
        _timeLeft = _totalTime;
        startTimer();
      });
    } catch (e) {
      print('Error loading questions: $e');
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

  void checkAnswer(int answerIndex) {
    QuestionData currentQuestion = allQuestions[_currentIndex];
    bool correct = currentQuestion.correctAnswers[answerIndex];
    setState(() {
      currentQuestion.answeredCorrectly = !correct;
      if (!correct) {
        wrongAnswers.add(currentQuestion); // Add to the list of wrong answers
      }
      if (_currentIndex < allQuestions.length - 1) {
        _currentIndex++;
      } else {
        _timer.cancel();
        showFinalResultDialog();
      }
    });
  }

  void showFinalResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Test Completed"),
        content: Text(
            "You have completed the test. Wrong answers: ${wrongAnswers.length}"),
        actions: <Widget>[
          TextButton(
            child: Text('Review Wrong Answers'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ScorePage(wrongAnswers: wrongAnswers),
              ));
            },
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
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
              setState(() {
                hasStarted = false; // Allow user to start a new test
              });
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
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                    _timeLeft = _totalTime;
                    wrongAnswers.clear(); // Clear previous wrong answers
                    hasStarted = true;
                    loadQuestions();
                  });
                },
                child: Text("Start Test"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                ),
              ),
            )
          ] else if (_currentIndex < allQuestions.length) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                allQuestions[_currentIndex].question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...allQuestions[_currentIndex].options.map((answer) {
              int idx = allQuestions[_currentIndex].options.indexOf(answer);
              return InkWell(
                onTap: () => checkAnswer(idx),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: AnimatedContainer(
                    duration: const Duration(),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: allQuestions[_currentIndex].answeredCorrectly
                          ? (allQuestions[_currentIndex].correctAnswers[idx]
                              ? Colors.green
                              : Colors.red)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          answer,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
