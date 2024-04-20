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
  bool _isAnswerSelected = false;

  List<Map<String, dynamic>> get questions =>
      _getQuestionsForCategory(widget.category);

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        _isAnswerSelected = false; // Reset the animation
        _selectedAnswerIndex = null; // Reset selection for the next question
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
        _isAnswerSelected = false; // Reset the animation
        _selectedAnswerIndex =
            null; // Reset selection for the previous question
      }
    });
  }

  void _selectAnswer(int index) {
    if (!_isAnswerSelected) {
      // To prevent re-selection during the animation
      setState(() {
        _selectedAnswerIndex = index;
        _isAnswerSelected = true;
      });
    }
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
    } else if (category == "Prawo Karne") {
      return [
        {
          "question":
              "Kto porzuca broń palną lub amunicję, która pozostaje w jego dyspozycji, podlega (art. 50 uobia):",
          "answers": [
            {
              "text": "wyłącznie karze aresztu albo grzywny",
              "isCorrect": false
            },
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "wyłącznie karze grzywny", "isCorrect": false}
          ]
        },
        {
          "question":
              "Kto nie dopełnia obowiązku rejestracji broni, podlega (art. 51 ust. 2 uobia):",
          "answers": [
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "karze aresztu albo grzywny", "isCorrect": false},
            {"text": "wyłącznie karze grzywny", "isCorrect": false}
          ]
        },
        {
          "question":
              "Kto nie dopełnia obowiązku zawiadomienia Policji o utracie lub zbyciu innej osobie broni i amunicji do tej broni, podlega (art. 51 ust. 2 uobia):",
          "answers": [
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "wyłącznie karze grzywny", "isCorrect": false},
            {"text": "karze aresztu albo grzywny", "isCorrect": false}
          ]
        },
        {
          "question":
              "Kto nosi broń, znajdując się w stanie po użyciu alkoholu, podlega (art. 51 ust. 2 uobia):",
          "answers": [
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "karze aresztu albo grzywny", "isCorrect": false},
            {"text": "wyłącznie karze grzywny", "isCorrect": false}
          ]
        },
        {
          "question":
              "Kto przechowuje oraz nosi broń i amunicję w sposób umożliwiający dostęp do nich osób nieuprawnionych, podlega (art. 51 ust. 2 uobia):",
          "answers": [
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "karze aresztu albo grzywny", "isCorrect": false},
            {"text": "wyłącznie karze grzywny", "isCorrect": false}
          ]
        },
        {
          "question":
              "Kto używa w celach szkoleniowych lub sportowych broni zdolnej do rażenia celów na odległość poza strzelnicami, podlega (art. 51 ust. 2 uobia):",
          "answers": [
            {"text": "karze aresztu albo grzywny", "isCorrect": false},
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "wyłącznie karze grzywny", "isCorrect": false}
          ]
        },
        {
          "question":
              "Kto narusza przepisy regulaminu określającego zasady zachowania bezpieczeństwa na strzelnicy, podlega (art. 51 ust. 2 uobia):",
          "answers": [
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "wyłącznie karze grzywny", "isCorrect": false},
            {"text": "karze aresztu albo grzywny", "isCorrect": false}
          ]
        },
        {
          "question":
              "Kto posiada broń, nie mając przy sobie legitymacji posiadacza broni lub Europejskiej karty broni palnej albo innego dokumentu upoważniającego do posiadania broni, podlega (art. 51 ust. 3 uobia):",
          "answers": [
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "karze aresztu albo grzywny", "isCorrect": false},
            {"text": "wyłącznie karze grzywny", "isCorrect": false}
          ]
        },
        {
          "question":
              "Kto posiada broń, nie mając przy sobie legitymacji osoby dopuszczonej do posiadania broni i świadectwa broni, podlega (art. 51 ust. 3 uobia):",
          "answers": [
            {"text": "wyłącznie karze grzywny", "isCorrect": false},
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "wyłącznie karze aresztu albo grzywny", "isCorrect": false}
          ]
        },
        {
          "question":
              "Nie popełnia przestępstwa, kto działając w obronie koniecznej odpiera bezpośredni, bezprawny zamach (art. 25 kodeksu karnego). Co może być przedmiotem obrony?",
          "answers": [
            {
              "text":
                  "na życie, zdrowie, wolność człowieka oraz na mienie wielkiej wartości",
              "isCorrect": true
            },
            {
              "text": "na jakiekolwiek dobro chronione prawem",
              "isCorrect": false
            },
            {"text": "tylko na życie i zdrowie człowieka", "isCorrect": false}
          ]
        },
        {
          "question":
              "Do przekroczenia granic obrony koniecznej może dojść w sytuacji, gdy (art. 25 kodeksu karnego):",
          "answers": [
            {"text": "działania obronne wyprzedziły zamach", "isCorrect": true},
            {"text": "dobrem ratowanym nie było życie", "isCorrect": false},
            {"text": "dobro ratowane było niskiej wartości", "isCorrect": false}
          ]
        },
        {
          "question":
              "Do przekroczenia granic obrony koniecznej może dojść również w innej sytuacji, gdy (art. 25 kodeksu karnego):",
          "answers": [
            {"text": "dobrem ratowanym nie było życie", "isCorrect": false},
            {
              "text": "dobro ratowane było niskiej wartości",
              "isCorrect": false
            },
            {
              "text":
                  "działania obronne były niewspółmierne do niebezpieczeństwa zamachu",
              "isCorrect": true
            }
          ]
        },
        {
          "question":
              "Kto bez wymaganego zezwolenia wyrabia broń palną, podlega (art. 263 kodeksu karnego):",
          "answers": [
            {
              "text": "karze pozbawienia wolności od roku do lat 10",
              "isCorrect": true
            },
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": false
            },
            {"text": "karze aresztu albo grzywny", "isCorrect": false}
          ]
        },
        {
          "question":
              "Kto bez wymaganego zezwolenia posiada broń palną lub amunicję, podlega (art. 263 kodeksu karnego):",
          "answers": [
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "karze aresztu albo grzywny", "isCorrect": false},
            {
              "text": "karze pozbawienia wolności od 6 miesięcy do lat 8",
              "isCorrect": false
            }
          ]
        },
        {
          "question":
              "Kto, mając zezwolenie na posiadanie broni palnej lub amunicji, udostępnia lub przekazuje ją osobie nieuprawnionej, podlega (art. 263 kodeksu karnego):",
          "answers": [
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do lat 2",
              "isCorrect": true
            },
            {"text": "karze aresztu albo grzywny", "isCorrect": false},
            {"text": "grzywnie", "isCorrect": false}
          ]
        },
        {
          "question":
              "Kto nieumyślnie powoduje utratę broni palnej lub amunicji, która zgodnie z prawem pozostaje w jego dyspozycji, podlega (art. 263 kodeksu karnego):",
          "answers": [
            {
              "text": "wyłącznie karze aresztu albo grzywny",
              "isCorrect": false
            },
            {
              "text":
                  "grzywnie, karze ograniczenia wolności albo pozbawienia wolności do roku",
              "isCorrect": true
            },
            {"text": "grzywnie", "isCorrect": false}
          ]
        }
      ];
    } else if (category == "Bezpieczeństwo w strzelectwie") {
      return [
        {
          "question":
              "Strzelnice powinny być zlokalizowane, zbudowane i zorganizowane w sposób (art. 46 ust. 1 uobia):",
          "answers": [
            {
              "text": "nienaruszający wymogów związanych z ochroną środowiska",
              "isCorrect": false
            },
            {
              "text":
                  "wykluczający możliwość wydostania się poza ich obręb pocisku wystrzelonego z broni ze stanowiska strzeleckiego w sposób zgodny z regulaminem strzelnicy",
              "isCorrect": false
            },
            {"text": "odpowiedzi a. i b. są prawidłowe.", "isCorrect": true}
          ]
        },
        {
          "question":
              "Szczegółowe zasady zachowania bezpieczeństwa na strzelnicy określa (art. 46 ust. 2 uobia):",
          "answers": [
            {"text": "regulamin strzelnicy", "isCorrect": true},
            {"text": "statut strzelnicy", "isCorrect": false},
            {"text": "prowadzący strzelanie", "isCorrect": false}
          ]
        },
        {
          "question":
              "Za bezpieczeństwo użytkowników strzelnicy oraz osób im towarzyszących odpowiada (Rozdział 1 ust. 1 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {"text": "właściciel strzelnicy", "isCorrect": true},
            {"text": "zarządca strzelnicy", "isCorrect": false},
            {"text": "prowadzący strzelanie", "isCorrect": false}
          ]
        },
        {
          "question":
              "Stanowiska strzeleckie dla osób korzystających ze strzelnicy (Rozdział 1 ust. 1 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {"text": "wyznacza prowadzący strzelanie", "isCorrect": true},
            {
              "text": "osoby korzystające ze strzelnicy wyznaczają sobie same",
              "isCorrect": false
            },
            {"text": "wyznacza właściciel strzelnicy", "isCorrect": false}
          ]
        },
        {
          "question":
              "Osobom towarzyszącym osobom korzystającym ze strzelnicy (Rozdział 1 ust. 2 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {
              "text": "zabrania się przebywania na terenie strzelnicy",
              "isCorrect": false
            },
            {
              "text":
                  "zabrania się wchodzenia na stanowiska strzeleckie oraz styczności z bronią",
              "isCorrect": true
            },
            {
              "text":
                  "zabrania się wnoszenia jedzenia i picia na teren strzelnic",
              "isCorrect": false
            }
          ]
        },
        {
          "question":
              "Używanie broni innych osób korzystających ze strzelnicy jest (Rozdział 1 ust. 2 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {"text": "zabronione", "isCorrect": false},
            {
              "text": "zabronione bez zgody prowadzącego strzelanie",
              "isCorrect": false
            },
            {"text": "zabronione bez zgody jej użytkownika", "isCorrect": true}
          ]
        },
        {
          "question":
              "Spożywanie alkoholu lub używanie środków odurzających oraz przebywanie osób będących pod ich wpływem na strzelnicy jest (Rozdział 1 ust. 2 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {
              "text":
                  "dozwolone pod warunkiem wynajęcia strzelnicy przez zorganizowaną grupę osób",
              "isCorrect": false
            },
            {
              "text": "dozwolone za zgodą właściciela strzelnicy",
              "isCorrect": false
            },
            {"text": "zabronione", "isCorrect": true}
          ]
        },
        {
          "question":
              "Na strzelnicy, wyjmowanie broni odbywa się wyłącznie na stanowisku strzeleckim lub treningowym tylko (Rozdział 2 ust. 2 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {
              "text":
                  "na polecenie prowadzącego strzelanie lub trening strzelecki",
              "isCorrect": true
            },
            {"text": "za zgodą właściciela strzelnicy", "isCorrect": false},
            {"text": "za zgodą zarządcy strzelnicy", "isCorrect": false}
          ]
        },
        {
          "question":
              "Na strzelnicy, strzelanie rozpoczyna się wyłącznie na komendę (Rozdział 2 ust. 4 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {"text": "właściciela strzelnicy", "isCorrect": false},
            {"text": "prowadzącego strzelanie", "isCorrect": true},
            {"text": "zarządcy strzelnicy", "isCorrect": false}
          ]
        },
        {
          "question":
              "Na strzelnicy, zakończenie strzelania zgłasza się (Rozdział 2 ust. 5 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {
              "text": "zakończenia strzelania nie zgłasza się",
              "isCorrect": false
            },
            {
              "text":
                  "osobie znajdującej się na sąsiadującym stanowisku strzeleckim",
              "isCorrect": false
            },
            {"text": "prowadzącemu strzelanie", "isCorrect": true}
          ]
        },
        {
          "question":
              "Na strzelnicy, po zakończeniu strzelania (Rozdział 2 ust. 6 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {
              "text":
                  "broń rozładowuje się i przedstawia do kontroli prowadzącemu strzelanie",
              "isCorrect": true
            },
            {
              "text": "broń rozładowuje się i chowa do kabury",
              "isCorrect": false
            },
            {
              "text":
                  "broń rozładowuje się i pozostawia na stanowisku strzeleckim",
              "isCorrect": false
            }
          ]
        },
        {
          "question":
              "Na strzelnicy, po zakończeniu strzelania, rozładowaniu broni i przedstawieniu jej prowadzącemu strzelanie (Rozdział 2 ust. 6 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {"text": "podchodzi się do tarcz", "isCorrect": false},
            {
              "text":
                  "opuszcza się stanowisko strzeleckie z bronią z otwartą komorą nabojową",
              "isCorrect": true
            },
            {
              "text":
                  "opuszcza się stanowisko strzeleckie pozostawiając broń na stanowisku",
              "isCorrect": false
            }
          ]
        },
        {
          "question":
              "Na strzelnicy, podczas strzelania, komendę „STOP” może wydać (Rozdział 3 ust. 4 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {"text": "wyłącznie prowadzący strzelanie", "isCorrect": true},
            {
              "text": "prowadzący strzelanie lub inna osoba",
              "isCorrect": false
            },
            {
              "text": "prowadzący strzelanie lub zarządca strzelnicy",
              "isCorrect": false
            }
          ]
        },
        {
          "question":
              "Na strzelnicy, podczas strzelania, po komendzie „STOP” (Rozdział 3 ust. 4 wzorcowego regulaminu bezpiecznego funkcjonowania strzelnic):",
          "answers": [
            {
              "text": "strzelający bezzwłocznie przerywają strzelanie",
              "isCorrect": true
            },
            {
              "text":
                  "strzelający przerywają strzelanie po wyczerpaniu amunicji w magazynku",
              "isCorrect": false
            },
            {
              "text":
                  "strzelający rozładowują broń i przedstawiają ją prowadzącemu strzelanie",
              "isCorrect": false
            }
          ]
        }
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final double cmToPixels =
        2 * MediaQuery.of(context).devicePixelRatio * 37.795275591;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.category}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    questions[_currentQuestionIndex]['question'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...questions[_currentQuestionIndex]['answers']
                    .asMap()
                    .entries
                    .map<Widget>((entry) {
                  int idx = entry.key;
                  var answer = entry.value;
                  return InkWell(
                    onTap: () => _selectAnswer(idx),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: _selectedAnswerIndex == idx
                            ? (answer['isCorrect']
                                ? Colors.green
                                    .withOpacity(_isAnswerSelected ? 1 : 0)
                                : Colors.red
                                    .withOpacity(_isAnswerSelected ? 1 : 0))
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.2)),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: ListTile(
                        title: Text(answer['text']),
                        leading: Radio(
                          value: idx,
                          groupValue: _selectedAnswerIndex,
                          onChanged: (int? value) {},
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: cmToPixels),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _previousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 247, 82, 70),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      textStyle: TextStyle(fontSize: 20),
                      shadowColor: Colors.black,
                      elevation: 10,
                    ),
                    child: Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 230, 43),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      textStyle: TextStyle(fontSize: 20),
                      shadowColor: Colors.black,
                      elevation: 10,
                    ),
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
