import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:patent_strzelecki/Widget/question_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  final String category;

  QuizPage({required this.category});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final PageController _pageController = PageController();
  double _currentQuestionIndex = 0;
  List<Map<String, dynamic>> questions = [];

  Future<void> _loadQuestionsFromJson(String jsonPath) async {
    String jsonContent = await rootBundle.loadString(jsonPath);
    List<Map<String, dynamic>> jsonData =
        List<Map<String, dynamic>>.from(json.decode(jsonContent));

    setState(() {
      questions = jsonData.map((questionData) {
        List<dynamic> answers = List.from(questionData['answers']);
        answers.shuffle();
        return {
          "question": questionData['question'],
          "select": -1, // Reset selection for each question
          "answers": answers,
        };
      }).toList();
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void pobierzZKolekcji(String category) async {
    switch (category) {
      case "Prawo Karne":
        category = 'prawo_karne';
      case "Ustawa o broni i amunicji":
        category = 'uobia';
      case "Regulamin Strzelecki":
        category = 'regulamin';
      case "Bezpieczeństwo w strzelectwie":
        category = 'bezpieczenstwo';
      default:
        category = 'issf';
    }

    CollectionReference referencja = firestore.collection(category);

    try {
      QuerySnapshot dane = await referencja.get();

      List<Map<String, dynamic>> tmpList = [];
      dane.docs.forEach((DocumentSnapshot d) async {
        tmpList.add(d.data() as Map<String, dynamic>);
      });

      setState(() {
        questions = tmpList.map((questionData) {
          List<dynamic> answers = List.from(questionData['answers']);
          answers.shuffle();
          return {
            "question": questionData['question'],
            "select": -1, // Reset selection for each question
            "answers": answers,
          };
        }).toList();
      });
    } catch (error) {
      print("Błąd pobierania danych: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentQuestionIndex = _pageController.page!;
      });
    });
    pobierzZKolekcji(widget.category);
  }

  String _getJsonPath(String category) {
    switch (category) {
      case "Prawo Karne":
        return 'Assets/Questions/prawo_karne.json';
      case "Ustawa o broni i amunicji":
        return 'Assets/Questions/uobia.json';
      case "Regulamin Strzelecki":
        return 'Assets/Questions/regulamin.json';
      case "Bezpieczeństwo w strzelectwie":
        return 'Assets/Questions/bezpieczenstwo.json';
      default:
        return 'Assets/Questions/issf.json';
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
                return QuestionPageWidget(
                  question: questions[index],
                  index: index,
                  totalQuestions: questions.length, // Add this line
                  selectAnswer: (idx) => _selectAnswer(idx),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
