import 'package:flutter/material.dart';
import 'quiz_page.dart'; // Załóżmy, że to jest strona, która obsługuje quizy.

class QuestionPage extends StatelessWidget {
  final List<String> categories = [
    "Prawo Karne",
    "Obrona Konieczna",
    "Ustawa o broni i amunicji",
    "Dodatkowe akty prawne",
    "Bezpieczeństwo w strzelectwie",
    "Przepisy sportowe ISSF",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wybierz Kategorię'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(categories[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(category: categories[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
