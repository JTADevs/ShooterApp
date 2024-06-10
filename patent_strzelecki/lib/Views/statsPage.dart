import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Statystyki',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.black54],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: const Center(
          child: Text('No user logged in!'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statystyki',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.black54],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('test_results')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Brak wyników testów.'));
          }

          final testResults = snapshot.data!.docs;

          // Get the start and end dates of the current week
          DateTime now = DateTime.now();
          DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

          // Filter test results to only include those from the current week
          List<QueryDocumentSnapshot> currentWeekResults =
              testResults.where((result) {
            Timestamp? timestamp = result['timestamp'] as Timestamp?;
            if (timestamp != null) {
              DateTime date = timestamp.toDate();
              return date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                  date.isBefore(endOfWeek.add(Duration(days: 1)));
            }
            return false;
          }).toList();

          int totalTests = currentWeekResults.length;
          int passedTests = currentWeekResults
              .where((result) => (result['correctAnswers'] ?? 0) >= 9)
              .length;
          int failedTests = totalTests - passedTests;

          int totalCorrectAnswers = currentWeekResults.fold(
              0, (sum, result) => sum + (result['correctAnswers'] as int ?? 0));
          double averageScore =
              totalTests > 0 ? totalCorrectAnswers / totalTests : 0.0;

          int highestScore = currentWeekResults.fold(
              0,
              (highest, result) => (result['correctAnswers'] ?? 0) > highest
                  ? (result['correctAnswers'] ?? 0)
                  : highest);

          int lowestScore = currentWeekResults.fold(
              (currentWeekResults.isNotEmpty
                  ? (currentWeekResults.first['correctAnswers'] ?? 0)
                  : 0),
              (lowest, result) => (result['correctAnswers'] ?? 0) < lowest
                  ? (result['correctAnswers'] ?? 0)
                  : lowest);

          double passRate =
              totalTests > 0 ? (passedTests / totalTests) * 100 : 0.0;

          Map<int, Map<String, int>> testsByDayOfWeek = {
            1: {'passed': 0, 'failed': 0}, // Monday
            2: {'passed': 0, 'failed': 0}, // Tuesday
            3: {'passed': 0, 'failed': 0}, // Wednesday
            4: {'passed': 0, 'failed': 0}, // Thursday
            5: {'passed': 0, 'failed': 0}, // Friday
            6: {'passed': 0, 'failed': 0}, // Saturday
            7: {'passed': 0, 'failed': 0}, // Sunday
          };

          for (var result in currentWeekResults) {
            Timestamp? timestamp = result['timestamp'] as Timestamp?;
            if (timestamp != null) {
              DateTime date = timestamp.toDate();
              int dayOfWeek = date.weekday;
              if ((result['correctAnswers'] ?? 0) >= 9) {
                testsByDayOfWeek[dayOfWeek]!['passed'] =
                    testsByDayOfWeek[dayOfWeek]!['passed']! + 1;
              } else {
                testsByDayOfWeek[dayOfWeek]!['failed'] =
                    testsByDayOfWeek[dayOfWeek]!['failed']! + 1;
              }
            }
          }

          Map<String, int> missedQuestionsCount = {};

          for (var result in currentWeekResults) {
            List<dynamic>? answers = result['answers'] as List<dynamic>?;
            if (answers != null) {
              for (var answer in answers) {
                if (!(answer['isCorrect'] ?? true)) {
                  String questionText =
                      answer['question'] ?? 'Unknown question';
                  if (missedQuestionsCount.containsKey(questionText)) {
                    missedQuestionsCount[questionText] =
                        missedQuestionsCount[questionText]! + 1;
                  } else {
                    missedQuestionsCount[questionText] = 1;
                  }
                }
              }
            }
          }

          var sortedMissedQuestions = missedQuestionsCount.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          var topMissedQuestions = sortedMissedQuestions.take(5);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Highest and lowest scores on the top
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.grey[850],
                        margin: const EdgeInsets.only(right: 8.0),
                        elevation: 8,
                        shadowColor: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Najwyższy wynik',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$highestScore',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.grey[850],
                        margin: const EdgeInsets.only(left: 8.0),
                        elevation: 8,
                        shadowColor: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Najniższy wynik',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$lowestScore',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Bar chart showing tests by day of the week
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.grey[850],
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 8,
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: testsByDayOfWeek.entries.map((entry) {
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value['passed']!.toDouble(),
                                  color: Colors.green,
                                  width: 12,
                                ),
                                BarChartRodData(
                                  toY: entry.value['failed']!.toDouble(),
                                  color: Colors.red,
                                  width: 12,
                                ),
                              ],
                              barsSpace: 4,
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      color: Colors.grey.shade300,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  switch (value.toInt()) {
                                    case 1:
                                      return Text('Pon',
                                          style: TextStyle(
                                              color: Colors.grey.shade300));
                                    case 2:
                                      return Text('Wt',
                                          style: TextStyle(
                                              color: Colors.grey.shade300));
                                    case 3:
                                      return Text('Śr',
                                          style: TextStyle(
                                              color: Colors.grey.shade300));
                                    case 4:
                                      return Text('Czw',
                                          style: TextStyle(
                                              color: Colors.grey.shade300));
                                    case 5:
                                      return Text('Pt',
                                          style: TextStyle(
                                              color: Colors.grey.shade300));
                                    case 6:
                                      return Text('Sob',
                                          style: TextStyle(
                                              color: Colors.grey.shade300));
                                    case 7:
                                      return Text('Ndz',
                                          style: TextStyle(
                                              color: Colors.grey.shade300));
                                    default:
                                      return Text('');
                                  }
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipPadding: EdgeInsets.all(8),
                              tooltipRoundedRadius: 4,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                String day;
                                switch (group.x.toInt()) {
                                  case 1:
                                    day = 'Poniedziałek';
                                    break;
                                  case 2:
                                    day = 'Wtorek';
                                    break;
                                  case 3:
                                    day = 'Środa';
                                    break;
                                  case 4:
                                    day = 'Czwartek';
                                    break;
                                  case 5:
                                    day = 'Piątek';
                                    break;
                                  case 6:
                                    day = 'Sobota';
                                    break;
                                  case 7:
                                    day = 'Niedziela';
                                    break;
                                  default:
                                    day = '';
                                    break;
                                }
                                return BarTooltipItem(
                                  '$day\n',
                                  TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: rod.toY.toString(),
                                      style: TextStyle(
                                        color: rod.color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Pass rate
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.grey[850],
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 8,
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Procent zaliczonych testów',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${passRate.toStringAsFixed(2)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Most missed questions
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.grey[850],
                  elevation: 8,
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Najczęściej pomijane pytania:',
                          style: TextStyle(
                            color: Color.fromARGB(255, 223, 9, 9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 150,
                          child: ListView.builder(
                            itemCount: topMissedQuestions.length,
                            itemBuilder: (context, index) {
                              final entry = topMissedQuestions.elementAt(index);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pytanie Nr ${index + 1}:',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      color: Color.fromARGB(179, 198, 194, 194),
                                    ),
                                  ),
                                  Text(
                                    'Pominięcia: ${entry.value}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(179, 255, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
