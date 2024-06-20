import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patent_strzelecki/Views/quiz_page.dart';
// Assuming this is the page that handles quizzes.

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final List<String> categories = [
    "Prawo Karne",
    "Ustawa o broni i amunicji",
    "Regulamin Strzelecki",
    "Bezpieczeństwo w strzelectwie",
    "Budowa Broni",
  ];

  int?
      _selectedItem; // Keep track of the temporarily selected item for animation

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.emailVerified ? Scaffold(
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
              Color.fromARGB(255, 33, 30, 30)!,
              Color.fromARGB(255, 87, 80, 80)!
            ];
          } else if (index % 3 == 1) {
            gradientColors = [
              Color.fromARGB(255, 78, 99, 69)!,
              Color.fromARGB(255, 70, 70, 69)!
            ];
          } else {
            gradientColors = [
              Color.fromARGB(255, 18, 35, 14)!,
              Color.fromARGB(255, 123, 142, 121)!
            ];
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
    ): const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.email, // Użyj ikony odpowiedniej dla testu
          size: 100,
          color: Colors.red,
        ),
        SizedBox(height: 20),
        Card(
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Aby korzystać z aplikacji zweryfikuj swój adres email.',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
