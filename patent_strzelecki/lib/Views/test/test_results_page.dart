import 'package:flutter/material.dart';

class TestResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> questions;

  TestResultsPage({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Test Results',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 76, 74, 73),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final question = questions[index];
            final selectedAnswer = question['select'];
            final isCorrect = selectedAnswer != -1 &&
                question['answers'][selectedAnswer]['isCorrect'] == true;

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
                      question['question'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(),
                    ...question['answers'].map<Widget>((answer) {
                      final answerIndex = question['answers'].indexOf(answer);
                      final isSelected = answerIndex == selectedAnswer;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? (isCorrect
                                      ? Icons.check_circle_outline
                                      : Icons.highlight_off)
                                  : Icons.circle_outlined,
                              color: isSelected
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                answer['text'],
                                style: TextStyle(
                                  color: isSelected
                                      ? (isCorrect ? Colors.green : Colors.red)
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
