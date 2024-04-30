import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QuizPage extends StatefulWidget {
  final String category;

  QuizPage({required this.category});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final PageController _pageController = PageController();
  double _currentQuestionIndex = 0; // Changed to double to work with Slider
  List<Map<String, dynamic>> questions = [];

  Future<List<Map<String, dynamic>>> _loadQuestionsFromJson(
      String jsonPath) async {
    String jsonContent =
        await DefaultAssetBundle.of(context).loadString(jsonPath);
    return List<Map<String, dynamic>>.from(json.decode(jsonContent));
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentQuestionIndex = _pageController.page!;
      });
    });
    _loadQuestionsFromJson(_getJsonPath(widget.category))
        .then((loadedQuestions) {
      setState(() {
        questions = loadedQuestions.map((questionData) {
          List<dynamic> answers = List.from(questionData['answers']);
          answers.shuffle(); 
          return {
            "question": questionData['question'],
            "select": questionData['select'],
            "answers": answers,
          };
        }).toList();
      });
    });
  }

  String _getJsonPath(String category) {
    switch (category) {
      case "Prawo karne":
        return 'Assets/prawo_karne.json';
      case "Ustawa o broni i amunicji":
        return 'Assets/uobia.json';
      case "Regulamin Strzelecki":
        return 'Assets/regulamin.json';
      case "Bezpieczeństwo w strzelectwie":
        return 'Assets/bezpieczenstwo.json';
      default:
        return 'Assets/issf.json'; 
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    setState(() {
      questions[_currentQuestionIndex.round()]["select"] = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.category}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return buildQuestionPage(questions[index], index);
              },
            ),
          ),
          Slider(
            value: _currentQuestionIndex,
            min: 0,
            max: (questions.length - 1).toDouble(),
            divisions: questions.length,
            thumbColor: Colors.orange,
            activeColor: Colors.orange.shade200,
            label: '${_currentQuestionIndex.round() + 1}',
            onChanged: (value) {
              setState(() {
                _currentQuestionIndex = value;
              });
              _pageController.animateToPage(
                value.round(),
                duration: const Duration(milliseconds: 1),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildQuestionPage(Map<String, dynamic> question, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
              question['question'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: (question['answers'] as List).map<Widget>((answer) {
              int idx = question['answers'].indexOf(answer);
              return InkWell(
                onTap: () => _selectAnswer(idx),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: question["select"] == idx
                          ? (answer['isCorrect'] ? Colors.green : Colors.red)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    child: SizedBox( // Używamy SizedBox, aby ustawić szerokość na infinity (czyli pełną dostępną szerokość)
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        child: Text(
                          answer['text'],
                          textAlign: TextAlign.center, // Centrowanie tekstu
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
