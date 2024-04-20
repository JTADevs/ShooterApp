import 'package:flutter/material.dart';
import 'quiz_page.dart'; // Assuming this is the page that handles quizzes.

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final List<String> categories = [
    "Prawo Karne",
    "Obrona Konieczna",
    "Ustawa o broni i amunicji",
    "Dodatkowe akty prawne",
    "Bezpieczeństwo w strzelectwie",
    "Przepisy sportowe ISSF",
  ];

  int?
      _selectedItem; // Keep track of the temporarily selected item for animation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wybierz Kategorię'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          // Define gradient colors for each category
          List<Color> gradientColors;
          if (index % 3 == 0) {
            gradientColors = [
              const Color.fromARGB(255, 157, 25, 25)!,
              Colors.redAccent[400]!
            ];
          } else if (index % 3 == 1) {
            gradientColors = [
              const Color.fromARGB(255, 220, 147, 28)!,
              const Color.fromARGB(255, 235, 216, 8)!
            ];
          } else {
            gradientColors = [Colors.orange[800]!, Colors.orangeAccent[400]!];
          }

          return InkWell(
            onTap: () {
              setState(() {
                _selectedItem = index; // Temporarily highlight selected item
              });
              // Wait for animation to finish before navigating
              Future.delayed(Duration(milliseconds: 300), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(category: categories[index]),
                  ),
                ).then((_) => setState(() {
                      _selectedItem = null; // Reset selection on return to page
                    }));
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                gradient: LinearGradient(
                  colors: _selectedItem == index
                      ? gradientColors.reversed
                          .toList() // Reverse gradient temporarily
                      : gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                title: Text(
                  categories[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
