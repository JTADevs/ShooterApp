import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  final String category;

  QuizPage({required this.category});

  @override
  Widget build(BuildContext context) {
    // Tymczasowe przykładowe pytania, powinieneś zastąpić je rzeczywistymi danymi
    List<String> questions = ["Pytanie 1", "Pytanie 2", "Pytanie 3"];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: $category'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(questions[index]),
            onTap: () {},
          );
        },
      ),
    );
  }
}
