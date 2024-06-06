import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:patent_strzelecki/Views/home_page.dart';
import 'package:patent_strzelecki/Views/registration_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inicjalizacja Firebase

  // Inicjalizacja powiadomień
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
    onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp(notificationsPlugin: flutterLocalNotificationsPlugin));
}

Future onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // Możesz dodać tutaj logikę do obsługi powiadomień otrzymanych w aplikacji iOS
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  MyApp({required this.notificationsPlugin});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FlutterLocalNotificationsPlugin>.value(
            value: notificationsPlugin),
      ],
      child: MaterialApp(
        title: 'Patent Strzelecki',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Sprawdzamy, czy sesja użytkownika istnieje
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

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
