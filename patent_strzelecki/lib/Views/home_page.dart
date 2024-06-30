import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:patent_strzelecki/Views/statsPage.dart';
import 'package:patent_strzelecki/Views/admin_page.dart';
import 'package:patent_strzelecki/Views/question_page.dart';
import 'package:patent_strzelecki/Views/score/testListPage.dart';
import 'package:patent_strzelecki/Views/test/test_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    StatisticsPage(),
    TestPage(),
    QuestionPage(),
    TestListPage(),
    AdminPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut(); // Wylogowanie użytkownika z Firebase

    if (!mounted) return; // Ensure the widget is still in the widget tree
    // Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 69, 63, 63),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: Offset(0, -1),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: ClipRRect(
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Strona Główna',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.quiz),
                label: 'Test',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.question_answer),
                label: 'Pytania',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.score),
                label: 'Wyniki',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color.fromARGB(255, 116, 111, 111),
            unselectedItemColor: const Color.fromARGB(255, 7, 6, 6),
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
