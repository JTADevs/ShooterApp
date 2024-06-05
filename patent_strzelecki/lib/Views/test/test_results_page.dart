import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> questions;

  TestResultsPage({required this.questions});

  Future<void> _saveTestResults(BuildContext context) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userRef = _firestore.collection('users').doc(user.uid);

      List<Map<String, dynamic>> answers = questions.map((question) {
        final selectedAnswer = question['select'];
        final isCorrect = selectedAnswer != -1 &&
            question['answers'][selectedAnswer]['isCorrect'] == true;

        return {
          'question': question['question'],
          'selectedAnswer': selectedAnswer,
          'isCorrect': isCorrect,
          'answers': question['answers'],
        };
      }).toList();

      await userRef.collection('test_results').add({
        'timestamp': Timestamp.now(),
        'answers': answers,
        'correctAnswers': answers.where((answer) => answer['isCorrect']).length,
        'totalQuestions': questions.length,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test results saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user logged in!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Results'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final selectedAnswer = question['select'];
          final isCorrect = selectedAnswer != -1 &&
              question['answers'][selectedAnswer]['isCorrect'] == true;

          return Card(
            child: ListTile(
              title: Text(question['question']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...question['answers'].map<Widget>((answer) {
                    final answerIndex = question['answers'].indexOf(answer);
                    final isSelected = answerIndex == selectedAnswer;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        '${answer['text']}',
                        style: TextStyle(
                          color: isSelected
                              ? (isCorrect ? Colors.green : Colors.red)
                              : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _saveTestResults(context);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
