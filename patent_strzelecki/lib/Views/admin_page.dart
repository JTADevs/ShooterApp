import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<Map<String, String>> _userDataFuture;
  String? _formattedDate;

  @override
  void initState() {
    super.initState();
    _userDataFuture = getUserData();
  }

  Future<Map<String, String>> getUserData() async {
    User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference referencja =
        firestore.collection('account').doc(user.uid);
    DocumentSnapshot account = await referencja.get();
    Map<String, dynamic>? dane = account.data() as Map<String, dynamic>?;
    String nickname = dane?['nickname'] ?? 'No nickname';
    String gender =
        dane?['gender'] ?? 'male'; // Domyślnie 'male' jeśli nie podano płci
    String examDate = dane?['examDate'] ?? 'No exam date set';

    _formattedDate = 'No date set';
    try {
      _formattedDate =
          DateFormat('dd/MM/yyyy').format(DateTime.parse(examDate));
    } catch (e) {
      _formattedDate = 'Invalid date';
    }

    return {
      'nickname': nickname,
      'gender': gender,
      'examDate': examDate,
    };
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
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference referencja =
          firestore.collection('account').doc(user.uid);
      await referencja.update({
        'examDate': pickedDate.toIso8601String(),
      });
      setState(() {
        _formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://jtadevs.pl');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut(); // Wylogowanie użytkownika z Firebase

    if (!mounted) return;
    Navigator.of(context)
        .pushReplacementNamed('/login'); // Przekierowanie na stronę logowania
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        cardColor: Colors.grey[850], // Dark background for cards
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
            child: FutureBuilder<Map<String, String>>(
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

                Map<String, String> data = snapshot.data!;
                String nickname = data['nickname'] ?? 'No nickname';
                String gender = data['gender'] ?? 'male';

                String avatarImage;
                if (gender.toLowerCase() == 'female') {
                  avatarImage = 'Assets/images/female.webp';
                } else {
                  avatarImage = 'Assets/images/male.webp';
                }

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
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(avatarImage),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              nickname,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                          style: TextStyle(
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
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
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
