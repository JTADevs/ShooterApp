import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; // Do losowania pytań
import 'package:shared_preferences/shared_preferences.dart';


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

  List<String> questions = []; // Tutaj będą wszystkie pytania
  List<List<String>> options = []; // Opcje odpowiedzi do wszystkich pytań
  List<bool> answeredCorrectly = List.filled(10, false); // Śledzenie poprawności odpowiedzi

  @override
  void initState() {
    super.initState();
    _timeLeft = _totalTime;
    loadQuestions();
    startTimer();
  }

  void loadQuestions() {
    // Załaduj pytania specyficznie dla "Ustawa o broni i amunicji"
    //questions.addAll([...]);  // Załaduj odpowiednie pytania
    //options.addAll([...]);  // Załaduj odpowiednie opcje

    // Załaduj pytania dla pozostałych kategorii
    //questions.addAll([...]);
    // options.addAll([...]);

    // Shuffle questions for randomness
    var rand = Random();
    questions = List.from(questions)..shuffle(rand);
    options = List.from(options)..shuffle(rand);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer.cancel();
        showTimeUpDialog();
      }
    });
  }

  void checkAnswer(bool correct, int index) {
    setState(() {
      if (!correct) {
        if (index < 4) {
          // Pierwsze 4 pytania bez błędów
          // Automatycznie kończy test, jeśli błąd na pierwszych 4 pytaniach
          showFailureDialog();
          _timer.cancel();
        } else {
          currentMistakes++;
          if (currentMistakes > allowedMistakes) {
            showFailureDialog();
            _timer.cancel();
          }
        }
      }
      answeredCorrectly[index] = correct;
      if (_currentIndex < questions.length - 1) {
        _currentIndex++;
      } else {
        _timer.cancel(); // End the timer on finishing the test
        saveResults();
        Navigator.of(context).pop();
      }
    });
  }

  void saveResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('testresults', answeredCorrectly.join(","));
  }

  void showFailureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Błąd!"),
        content: const Text("Niestety, nie zdałeś/zdałaś testu. Spróbuj ponownie."),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
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
        title: const Text("Czas minął!"),
        content: const Text("Twój czas na wykonanie testu się skończył."),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Zamyka dialog
              Navigator.of(context).pop(); // Wraca do poprzedniej strony
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
            "Test - Pozostały czas: ${_timeLeft ~/ 60}:${(_timeLeft % 60).toString().padLeft(2, '0')}"),
      ),
      body: Column(
        children: <Widget>[
          if (_currentIndex < questions.length) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(questions[_currentIndex],
                  style:
                      const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            for (int i = 0; i < options[_currentIndex].length; i++)
              ListTile(
                title: Text(options[_currentIndex][i]),
                onTap: () => checkAnswer(i == 0,
                    _currentIndex), // Założenie: pierwsza opcja jest poprawna
              ),
          ] else ...[
            Center(
              child: TextButton(
                onPressed: () {
                  // Reset test or go back to main menu
                  Navigator.of(context).pop();
                },
                child: const Text("Zakończ i zobacz wyniki"),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
