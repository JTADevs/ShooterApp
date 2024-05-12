import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patent_strzelecki/Service/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patent_strzelecki/Views/home_page.dart';
import 'package:patent_strzelecki/Views/registration_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicjalizacja Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navbar App',
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Sprawdzamy czy sesja użytkownika istnieje
        if (snapshot.hasData) {
          // Użytkownik jest zalogowany
          return HomePage();
        }
        // Użytkownik nie jest zalogowany
        return RegistrationPage();
      },
    );
  }
}
