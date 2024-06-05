import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestDetailPage extends StatelessWidget {
  final DocumentSnapshot testResult;

  TestDetailPage({required this.testResult});

  @override
  Widget build(BuildContext context) {
    // Pobierz pole answers i upewnij się, że jest to lista
    final List<dynamic>? answers = testResult['answers'] as List<dynamic>?;

    if (answers == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Szczegóły Testu'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Text('Brak odpowiedzi dla tego testu.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły Testu'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: answers.length,
        itemBuilder: (context, index) {
          final answer = answers[index] as Map<String, dynamic>;
          final questionText = answer['question'] ?? 'Brak pytania';
          final selectedAnswer = answer['selectedAnswer'] as int?;
          final isCorrect = answer['isCorrect'] as bool? ?? false;
          final List<dynamic>? possibleAnswers =
              answer['answers'] as List<dynamic>?;

          return Card(
            child: ListTile(
              title: Text(questionText),
              subtitle: possibleAnswers != null && possibleAnswers.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...possibleAnswers.map<Widget>((possibleAnswer) {
                          final answerIndex =
                              possibleAnswers.indexOf(possibleAnswer);
                          final isSelected = answerIndex == selectedAnswer;
                          final answerText =
                              possibleAnswer['text'] ?? 'Brak odpowiedzi';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                              answerText,
                              style: TextStyle(
                                color: isSelected
                                    ? (isCorrect ? Colors.green : Colors.red)
                                    : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    )
                  : Text('Brak odpowiedzi dla tego pytania.'),
            ),
          );
        },
      ),
    );
  }
}
