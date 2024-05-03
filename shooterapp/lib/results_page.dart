import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final String type;  // 'tests' lub konkretna kategoria quizu

  


  ResultsPage({required this.type});

  @override
  Widget build(BuildContext context) {
    List<String> results = getResultsForType(type); // Załóżmy, że ta funkcja pobiera wyniki z bazy danych

    return Scaffold(
      appBar: AppBar(
        title: Text('Wyniki dla: $type'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(results[index]),
          );
        },
      ),
    );
  }

  List<String> getResultsForType(String type) {
    // Tymczasowo zwracamy przykładowe dane
    return ["Odpowiedź 1", "Odpowiedź 2", "Odpowiedź 3"];
  }
}
