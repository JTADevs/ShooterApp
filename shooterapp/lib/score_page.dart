import 'package:flutter/material.dart';
import 'Model/questiondata.dart';

class ScorePage extends StatelessWidget {
  final List<QuestionData> wrongAnswers;

  const ScorePage({Key? key, required this.wrongAnswers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrong Answers'),
      ),
      body: ListView.builder(
        itemCount: wrongAnswers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(wrongAnswers[index].question),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8),
                const Text(
                  'Correct answer(s):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ...wrongAnswers[index].options.asMap().entries.map((entry) {
                  if (wrongAnswers[index].correctAnswers[entry.key]) {
                    return Text(entry.value,
                        style: const TextStyle(color: Colors.green));
                  } else {
                    return const SizedBox.shrink();
                  }
                }).toList(),
                const SizedBox(height: 8),
                const Text(
                  'Your answer(s):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ...wrongAnswers[index].options.asMap().entries.map((entry) {
                  if (!wrongAnswers[index].correctAnswers[entry.key]) {
                    return Text(entry.value,
                        style: const TextStyle(color: Colors.red));
                  } else {
                    return const SizedBox.shrink();
                  }
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
