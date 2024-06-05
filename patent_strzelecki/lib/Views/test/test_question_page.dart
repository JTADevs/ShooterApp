import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patent_strzelecki/Views/test/test_results_page.dart';
import 'dart:math';

class TestQuestionsPage extends StatefulWidget {
  @override
  _TestQuestionsPageState createState() => _TestQuestionsPageState();
}

class _TestQuestionsPageState extends State<TestQuestionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _remainingTime = 20 * 60;
  Timer? _timer;
  int _correctAnswers = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _startTimer();
  }

  Future<void> _fetchQuestions() async {
    final random = Random();
    final categories = [
      {'collection': 'uobia', 'count': 4},
      {'collection': 'regulamin', 'count': 2},
      {'collection': 'prawo_karne', 'count': 2},
      {'collection': 'issf', 'count': 2},
    ];

    for (var category in categories) {
      final querySnapshot =
          await _firestore.collection(category['collection'] as String).get();
      final questions = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to data
        data['select'] = -1; // Add initial selection state
        return data;
      }).toList();
      questions.shuffle(random);
      _questions.addAll(questions.take(category['count'] as int));
    }

    setState(() {
      _questions.shuffle(random);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _showTimeUpDialog();
        }
      });
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Time\'s up!'),
        content: Text('Your time for the test is over.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showCompletionDialog();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    int correctAnswers = 0;
    for (var question in _questions) {
      int selectedIndex = question['select'];
      if (selectedIndex != -1 &&
          question['answers'][selectedIndex]['isCorrect'] == true) {
        correctAnswers++;
      }
    }

    bool passed =
        correctAnswers >= 9; // Must have at least 9 correct answers to pass

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(passed ? 'Test Passed' : 'Test Failed'),
        content: Text(
            'You answered $correctAnswers out of ${_questions.length} questions correctly.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TestResultsPage(questions: _questions)),
              );
            },
            child: Text('Check Answers'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Test Questions'),
          backgroundColor: Colors.grey[800], // Dark grey color
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Questions'),
        backgroundColor: Colors.grey[800], // Dark grey color
      ),
      body: PageView.builder(
        controller: _pageController,
        physics:
            NeverScrollableScrollPhysics(), // Disable scrolling to previous question
        onPageChanged: (index) {
          setState(() {
            _currentQuestionIndex = index;
          });
        },
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final question = _questions[index];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time remaining: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Question ${index + 1}/${_questions.length}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    question['question'],
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ...question['answers'].map<Widget>((answer) {
                    final answerIndex = question['answers'].indexOf(answer);
                    final isSelected = answerIndex == question['select'];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: RadioListTile<int>(
                        value: answerIndex,
                        groupValue: question['select'],
                        onChanged: (value) {
                          setState(() {
                            question['select'] = value!;
                          });
                        },
                        title: Text(answer['text']),
                        activeColor: Colors.green,
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          child: Text('Quit Quiz'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          child: Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
