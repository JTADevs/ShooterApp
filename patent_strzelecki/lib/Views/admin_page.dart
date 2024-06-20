import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<Map<String, dynamic>> _userDataFuture;
  String? _formattedDate;
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _userDataFuture = getUserData();
    _loadNotificationStatus();
  }

  Future<void> _loadNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _toggleNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_notificationsEnabled) {
      await _cancelNotifications();
      prefs.setBool('notificationsEnabled', false);
    } else {
      await _scheduleNotifications();
      prefs.setBool('notificationsEnabled', true);
    }
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
    });
  }

  Future<Map<String, dynamic>> getUserData() async {
    User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference referencja =
        firestore.collection('account').doc(user.uid);
    DocumentSnapshot account = await referencja.get();
    Map<String, dynamic>? dane = account.data() as Map<String, dynamic>?;
    bool email_verified = user.emailVerified; // Use user's email as nickname
    String nickname = dane?['nickname'] ?? user.email?.split('@')[0]; // Use user's email as nickname
    // String nickname = user.email ?? 'No email'; // Use user's email as nickname
    String examDate = dane?['examDate'] ?? 'No exam date set';

    _formattedDate = 'No date set';
    try {
      _formattedDate =
          DateFormat('dd/MM/yyyy').format(DateTime.parse(examDate));
    } catch (e) {
      _formattedDate = 'Invalid date';
    }

    return {
      'email_verified': email_verified,
      'nickname': nickname,
      'examDate': examDate,
    };
  }

  Future<void> _scheduleNotifications() async {
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        Provider.of<FlutterLocalNotificationsPlugin>(context, listen: false);

    User user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('account')
        .doc(user.uid)
        .get();
    String examDateString = userDoc['examDate'] ?? '';
    DateTime? examDate;
    try {
      examDate = DateFormat('yyyy-MM-dd').parse(examDateString);
    } catch (e) {
      print("Error parsing exam date: $e");
    }

    if (examDate != null) {
      DateTime startDate = examDate.subtract(const Duration(days: 7));
      DateTime now = DateTime.now();
      if (now.isBefore(startDate)) {
        for (int i = 0; i < 7; i++) {
          DateTime notificationDate = startDate.add(Duration(days: i));
          await _scheduleNotification(
              notificationsPlugin, notificationDate, examDate);
        }
      }
    }
  }

  Future<void> _scheduleNotification(FlutterLocalNotificationsPlugin plugin,
      DateTime date, DateTime examDate) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'exam_channel',
      'Exam Notifications',
      channelDescription: 'Notifications about upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    String formattedDate = DateFormat('dd/MM/yyyy').format(examDate);

    await plugin.schedule(
      date.millisecondsSinceEpoch ~/ 1000,
      'Upcoming Exam',
      'Your exam is on $formattedDate. Prepare yourself!',
      date,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> _cancelNotifications() async {
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        Provider.of<FlutterLocalNotificationsPlugin>(context, listen: false);
    await notificationsPlugin.cancelAll();
  }

  Future<void> _selectExamDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      User user = FirebaseAuth.instance.currentUser!;
      DocumentReference referencja = FirebaseFirestore.instance.collection('account').doc(user.uid);
      await referencja.update({
        'examDate': pickedDate.toIso8601String(),
      }).catchError((v) => {
            FirebaseFirestore.instance.collection('account').doc(user.uid).set({
              'examDate': pickedDate.toIso8601String(),
            })
          });
      setState(() {
        _formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _sendVerifyEmail() async {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pomyślnie wysłano wiadomość', 
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          )
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://jtadevs.pl');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        cardColor: Colors.grey[850],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profil',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.grey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                }

                Map<String, dynamic> data = snapshot.data!;
                String nickname = data['nickname'] ?? 'No email';

                return Column(
                  children: <Widget>[
                    Card(
                      margin: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      color: Colors.grey[850],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                nickname,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    data['email_verified'] == false ?
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      color: Colors.grey[850],
                      child: ListTile(
                        leading: const Icon(Icons.mail,
                            color: Colors.red),
                        title: const Text(
                          'Zweryfikuj adres email',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'Wyślij ponownie email weryfikacyjny',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _sendVerifyEmail(),
                      ),
                    ): Container(),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      color: Colors.grey[850],
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today,
                            color: Colors.blue),
                        title: const Text(
                          'Data egzaminu',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          _formattedDate ?? 'No date set',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _selectExamDate(context),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      color: Colors.grey[850],
                      child: ListTile(
                        leading: const Icon(Icons.info, color: Colors.purple),
                        title: const Text(
                          'O nas',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'Dowiedz się więcej o JTA Dev',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _launchURL,
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      color: Colors.grey[850],
                      child: ListTile(
                        leading: const Icon(Icons.notifications,
                            color: Colors.yellow),
                        title: const Text(
                          'Włącz powiadomienia',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'Pozwól nam informować Cię na bieżąco',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: Switch(
                          value: _notificationsEnabled,
                          onChanged: (bool value) {
                            _toggleNotifications();
                          },
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: _logout,
                          child: const Text(
                            'Wyloguj',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
