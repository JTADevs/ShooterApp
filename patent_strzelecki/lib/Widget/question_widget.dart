import 'package:flutter/material.dart';

typedef SelectAnswerCallback = void Function(int index);

class QuestionPageWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final int index;
  final int totalQuestions;
  final SelectAnswerCallback selectAnswer;

  const QuestionPageWidget({
    Key? key,
    required this.question,
    required this.index,
    required this.totalQuestions,
    required this.selectAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Wyświetlanie licznika pytań
            Text(
              'Question ${index + 1} of $totalQuestions',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Wyświetlanie pytania
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                question['question'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Wyświetlanie odpowiedzi
            Column(
              mainAxisSize: MainAxisSize.min,
              children: (question['answers'] as List).map<Widget>((answer) {
                int idx = question['answers'].indexOf(answer);
                return InkWell(
                  onTap: () => selectAnswer(idx),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: question["select"] == idx
                            ? (answer['isCorrect'] ? Colors.green : Colors.red)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          child: Text(
                            answer['text'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
