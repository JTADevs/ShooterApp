import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final String category;

  QuizPage({required this.category});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;

  List<Map<String, dynamic>> get questions =>
      _getQuestionsForCategory(widget.category);

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null; // Reset selection for the next question
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
        _selectedAnswerIndex =
            null; // Reset selection for the previous question
      }
    });
  }

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
      // Optionally delay moving to the next question
      Future.delayed(Duration(seconds: 1), () {
        if (_currentQuestionIndex < questions.length - 1) {
          _nextQuestion();
        }
      });
    });
  }

  List<Map<String, dynamic>> _getQuestionsForCategory(String category) {
    // Example category questions added here
    if (category == "Ustawa o broni i amunicji") {
      return [
        {
          "question":
              "Bronią, w rozumieniu ustawy o broni i amunicji, nie jest:",
          "answers": [
            {"text": "kastet", "isCorrect": true},
            {"text": "nóż", "isCorrect": true},
            {
              "text":
                  "pałka wykonana z drewna lub innego ciężkiego i twardego materiału, imitująca kij bejsbolowy",
              "isCorrect": true
            }
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

        // More questions can be added here
      ];
    }
    return [];
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
                    .asMap()
                    .entries
                    .map<Widget>((entry) {
                  int idx = entry.key;
                  var answer = entry.value;
                  return InkWell(
                    onTap: () => _selectAnswer(idx),
                    child: Container(
                      color: _selectedAnswerIndex == idx
                          ? (answer['isCorrect']
                              ? Colors.green[300]
                              : Colors.red[300])
                          : null,
                      child: ListTile(
                        title: Text(answer['text']),
                        leading: Radio(
                          value: idx,
                          groupValue: _selectedAnswerIndex,
                          onChanged: (int? value) {
                            _selectAnswer(idx);
                          },
                        ),
                      ),
                    ),
                  );
                }).toList(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: _previousQuestion,
                      child: Text('Previous'),
                    ),
                    OutlinedButton(
                      onPressed: _nextQuestion,
                      child: Text('Next'),
                    ),
                  ],
                ),
              ],
            )
          : Center(
              child: Text('No more questions!'),
            ),
    );
  }
}
