import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:patent_strzelecki/Views/admin_page.dart';
import 'package:patent_strzelecki/Views/question_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    AdminPage(),
    Text('Test'),
    QuestionPage(),
    Text('Wyniki'),
  ];

  final List<String> _appBarTitles = [
    'Strona Główna',
    'Test',
    'Pytania',
    'Wyniki',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Poprawiona funkcja wylogowania
  void _logout() async {
    await FirebaseAuth.instance.signOut(); // Wylogowanie użytkownika z Firebase

 
    Navigator.of(context).pushReplacementNamed(
        '/login'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 69, 63, 63),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(0, 2),
                  blurRadius: 4.0)
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(_appBarTitles[_selectedIndex],
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app, size: 30, color: Colors.white),
                onPressed: _logout, // Użycie poprawionej funkcji wylogowania
              ),
            ],
          ),
        ),
      ),
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
                blurRadius: 4.0)
          ],
        ),
        child: ClipRRect(
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Strona Główna'),
              BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Test'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.question_answer), label: 'Pytania'),
              BottomNavigationBarItem(icon: Icon(Icons.score), label: 'Wyniki'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color.fromARGB(255, 0, 0, 0),
            unselectedItemColor:
                Color.fromARGB(255, 64, 49, 49).withOpacity(0.6),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
