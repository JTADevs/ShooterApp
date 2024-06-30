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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: answers.length,
          itemBuilder: (context, index) {
            final answer = answers[index] as Map<String, dynamic>;
            final questionText = answer['question'] ?? 'Brak pytania';
            final selectedAnswer = answer['selectedAnswer'] as int?;
            final isCorrect = answer['isCorrect'] as bool? ?? false;
            final List<dynamic>? possibleAnswers =
                answer['answers'] as List<dynamic>?;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pytanie ${index + 1}:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      questionText,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(),
                    possibleAnswers != null && possibleAnswers.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...possibleAnswers.map<Widget>((possibleAnswer) {
                                final answerIndex =
                                    possibleAnswers.indexOf(possibleAnswer);
                                final isSelected =
                                    answerIndex == selectedAnswer;
                                final answerText =
                                    possibleAnswer['text'] ?? 'Brak odpowiedzi';

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? (isCorrect
                                                ? Icons.check_circle_outline
                                                : Icons.highlight_off)
                                            : Icons.circle_outlined,
                                        color: isSelected
                                            ? (isCorrect
                                                ? Colors.green
                                                : Colors.red)
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          answerText,
                                          style: TextStyle(
                                            color: isSelected
                                                ? (isCorrect
                                                    ? Colors.green
                                                    : Colors.red)
                                                : Colors.black87,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          )
                        : Text('Brak odpowiedzi dla tego pytania.'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
