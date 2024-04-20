import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  String testResults = "";

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  void loadResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      testResults = prefs.getString('testResults') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> results = testResults.split(",");
    return Scaffold(
      appBar: AppBar(
        title: Text('Twoje Wyniki'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          bool correct = results[index] == "true";
          return ListTile(
            title: Text(
                "Pytanie ${index + 1}: ${correct ? "Poprawne" : "Błędne"}"),
            tileColor: correct ? Colors.green[100] : Colors.red[100],
          );
        },
      ),
    );
  }
}
