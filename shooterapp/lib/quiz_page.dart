import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final String category;

  QuizPage({required this.category});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> get questions =>
      _getQuestionsForCategory(widget.category);

  void _answerQuestion() {
    setState(() {
      _currentQuestionIndex++;
    });
  }

  List<Map<String, dynamic>> _getQuestionsForCategory(String category) {
    // Assuming that each category could potentially have different sets of questions.
    // Here, we populate only for "Ustawa o broni i amunicji".
    if (category == "Ustawa o broni i amunicji") {
      return [
        {
          "question": "Bronią, w rozumieniu ustawy, nie jest:",
          "answers": [
            {"text": "Broń palna", "correct": false},
            {"text": "Broń pneumatyczna", "correct": false},
            {"text": "Broń ostra", "correct": false},
          ]
        },
        {
          "question": "Bronią, w rozumieniu ustawy, jest:",
          "answers": [
            {"text": "Miotacz gazu obezwładniającego", "correct": true},
            {"text": "Miotacz gazu łzawiącego", "correct": true},
            {"text": "Miotacz gazu pieprzowego", "correct": true},
          ]
        },

        {
          "question": "Bronią, w rozumieniu ustawy o broni i amunicji, jest:",
          "answers": [
            {"text": "broń cięciwowa w postaci łuku", "isCorrect": true},
            {"text": "proca", "isCorrect": true},
            {"text": "broń cięciwowa w postaci kuszy", "isCorrect": true}
          ]
        },
        {
          "question": "Amunicją, w rozumieniu ustawy o broni i amunicji, są:",
          "answers": [
            {
              "text": "naboje przeznaczone do strzelania z broni palnej",
              "isCorrect": true
            },
            {
              "text": "naboje przeznaczone do strzelania z broni pneumatycznej",
              "isCorrect": true
            },
            {
              "text": "wszystkie naboje, bez względu na ich przeznaczenie",
              "isCorrect": true
            }
          ]
        },
        {
          "question":
              "Istotną częścią broni palnej, w rozumieniu ustawy o broni i amunicji, nie jest:",
          "answers": [
            {"text": "magazynek", "isCorrect": true},
            {"text": "komora zamkowa", "isCorrect": false},
            {"text": "lufa z komorą nabojową", "isCorrect": false}
          ]
        },
        {
          "question":
              "Istotną częścią broni palnej, w rozumieniu ustawy o broni i amunicji, jest:",
          "answers": [
            {"text": "szczerbinka", "isCorrect": true},
            {"text": "sprężyna powrotna", "isCorrect": true},
            {"text": "szkielet broni", "isCorrect": true}
          ]
        },
        {
          "question":
              "Istotną częścią broni palnej, w rozumieniu ustawy o broni i amunicji, nie jest:",
          "answers": [
            {"text": "tłumik", "isCorrect": true},
            {"text": "lufa z komorą nabojową", "isCorrect": false},
            {"text": "zamek", "isCorrect": false}
          ]
        },
        {
          "question":
              "Istotną częścią broni palnej, w rozumieniu ustawy o broni i amunicji, nie jest:",
          "answers": [
            {"text": "baskila", "isCorrect": true},
            {"text": "kolba", "isCorrect": true},
            {"text": "zamek", "isCorrect": false}
          ]
        },
        {
          "question":
              "Istotną częścią broni palnej, w rozumieniu ustawy o broni i amunicji, jest:",
          "answers": [
            {"text": "bęben nabojowy", "isCorrect": true},
            {"text": "rękojeść", "isCorrect": true},
            {"text": "muszka", "isCorrect": true}
          ]
        },
        {
          "question":
              "Istotną częścią amunicji, w rozumieniu ustawy o broni i amunicji, jest:",
          "answers": [
            {"text": "śrut strzelecki", "isCorrect": true},
            {
              "text": "materiał miotający w postaci prochu strzelniczego",
              "isCorrect": true
            },
            {"text": "odpowiedzi a. i b. są nieprawidłowe", "isCorrect": false}
          ]
        },
        {
          "question":
              "Istotną częścią amunicji, w rozumieniu ustawy o broni i amunicji, nie jest:",
          "answers": [
            {
              "text": "spłonka inicjująca spalanie materiału miotającego",
              "isCorrect": true
            },
            {
              "text":
                  "pocisk wypełniony materiałami wybuchowymi, chemicznymi środkami obezwładniającymi lub zapalającymi albo innymi substancjami, których działanie zagraża życiu lub zdrowiu",
              "isCorrect": true
            },
            {
              "text": "łuska łącząca w całość inne elementy naboju",
              "isCorrect": false
            }
          ]
        }

        // Add more questions here as per the provided data.
      ];
    }
    return []; // Return empty for categories without questions defined.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.category}'),
      ),
      body: _currentQuestionIndex < questions.length
          ? Column(
              children: <Widget>[
                ListTile(
                  title: Text(questions[_currentQuestionIndex]['question']),
                ),
                ...questions[_currentQuestionIndex]['answers']
                    .map<Widget>((answer) => ListTile(
                          title: Text(answer['text']),
                          leading: Radio(
                            value: answer['correct'],
                            groupValue: null,
                            onChanged: (value) {
                              if (answer['correct']) {
                                print('Correct!');
                              } else {
                                print('Wrong!');
                              }
                              _answerQuestion();
                            },
                          ),
                        ))
                    .toList(),
              ],
            )
          : Center(
              child: Text('No more questions!'),
            ),
    );
  }
}
