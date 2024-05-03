import 'package:flutter/material.dart';
import 'home_page.dart';
import 'test_page.dart';
import 'question_page.dart';
import 'score_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navbar App',
      home: MyNavigationBar(),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    TestPage(),
    QuestionPage(),
    ScorePage(
      wrongAnswers: [],
    ),
  ];

  static get questions => null;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Question',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'My Score',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 11, 19,
            11), // Kolor dla aktualnie wybranej ikony (po kliknięciu)
        unselectedItemColor: Color.fromARGB(255, 104, 101,
            101), // Kolor dla nieaktywnych ikon (zawsze podświetlone)
        onTap: _onItemTapped,
      ),
    );
  }
}
