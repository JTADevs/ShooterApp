import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
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
    List<Map<String, dynamic>> jsonData = List<Map<String, dynamic>>.from(json.decode(jsonContent));


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

  final databaseRef = FirebaseDatabase.instance.ref().child('patent-5e510-default-rtdb/europe-west1');
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // void dodajDoKolekcji() async{
  //   for (var c in ['prawo_karne','uobia','regulamin','bezpieczenstwo','issf']){
  //     CollectionReference referencja = firestore.collection(c);
  //     List<Map<String, dynamic>> dane = List<Map<String, dynamic>>.from(json.decode(await rootBundle.loadString('Assets/baza/'+c+'.json')));
  //     for (var d in dane) {
  //       await referencja.add(d).then((DocumentReference document) {
  //         print("Dokument dodany z ID: ${document.id}");
  //       }).catchError((error) {
  //         print("Błąd dodawania dokumentu: $error");
  //       });
  //     }
  //   }
  // }

  // Future<void> dodajDaneDoFirebase(Map<String, dynamic> dane) async {
  //   try {
  //     // Inicjalizacja aplikacji Firebase (jeśli nie została jeszcze zainicjalizowana)
  //     if (fb.apps.isEmpty) {
  //       fb.initializeApp(
  //         apiKey: "YOUR_API_KEY",
  //         authDomain: "YOUR_AUTH_DOMAIN",
  //         databaseURL: "YOUR_DATABASE_URL",
  //         projectId: "YOUR_PROJECT_ID",
  //         storageBucket: "YOUR_STORAGE_BUCKET",
  //         messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  //         appId: "YOUR_APP_ID",
  //       );
  //     }

  //     // Pobranie referencji do lokalizacji w bazie danych
  //     final fb.DatabaseReference ref = fb.database().ref("questions/prawo_karne");

  //     // Dodanie danych do bazy danych
  //     await ref.push().set(dane);

  //     print("Dane zostały pomyślnie dodane do bazy Firebase.");
  //   } catch (error) {
  //     print("Wystąpił błąd podczas dodawania danych do bazy Firebase: $error");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentQuestionIndex = _pageController.page!;
      });
    });
    // dodajDoKolekcji();
    _loadQuestionsFromJson(_getJsonPath(widget.category));
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
