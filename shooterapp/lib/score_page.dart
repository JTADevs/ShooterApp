import 'package:flutter/material.dart';
import 'Model/questiondata.dart';

class ScorePage extends StatelessWidget {
  final List<QuestionData> wrongAnswers;

  const ScorePage({Key? key, required this.wrongAnswers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wrong Answers'),
      ),
      body: ListView.builder(
        itemCount: wrongAnswers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(wrongAnswers[index].question),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Text(
                  'Correct answer(s):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                ...wrongAnswers[index].options.asMap().entries.map((entry) {
                  if (wrongAnswers[index].correctAnswers[entry.key]) {
                    return Text(entry.value,
                        style: TextStyle(color: Colors.green));
                  } else {
                    return SizedBox.shrink();
                  }
                }).toList(),
                SizedBox(height: 8),
                Text(
                  'Your answer(s):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                ...wrongAnswers[index].options.asMap().entries.map((entry) {
                  if (!wrongAnswers[index].correctAnswers[entry.key]) {
                    return Text(entry.value,
                        style: TextStyle(color: Colors.red));
                  } else {
                    return SizedBox.shrink();
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
