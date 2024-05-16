import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  Future<Map<String, String>> getUserData() async {
    // User user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot account = await FirebaseFirestore.instance.collection('account').doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic>? dane = account.data() as Map<String, dynamic>?;
    String nickname = dane?['nickname'] ?? 'No nickname';
    String gender = dane?['gender'] ?? 'No gender';
    String examDate = dane?['examDate'] ?? 'No exam date set';

    return {
      'nickname': nickname,
      'gender': gender,
      'examDate': examDate,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, String>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }

            Map<String, String> data = snapshot.data!;
            String formattedDate = 'No date set';
            try {
              formattedDate = DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(data['examDate']!));
            } catch (e) {
              formattedDate = 'Invalid date';
            }

            return Column(
              children: <Widget>[
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(data['gender'] == 'Female'
                          ? 'Assets/images/female.webp'
                          : 'Assets/images/male.webp'),
                    ),
                    title: Text('${data['nickname']} (${data['gender']})'),
                    subtitle: Text('Admin'),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 8.0, // space between cards
                  runSpacing: 4.0, // space between rows
                  children: <Widget>[
                    statCard(context, 'Użytkownicy', '150'),
                    statCard(context, 'Aktywne Sesje', '40'),
                    statCard(context, 'Błędy', '5'),
                    statCard(context, 'Data Egzaminu', formattedDate,
                        icon: Icons.calendar_today),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget statCard(BuildContext context, String title, String value,
      {IconData? icon}) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width / 2 -
            20, // Adjusts width dynamically
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null)
              Icon(icon,
                  color: Colors.grey[700],
                  size: 30), // Display an icon if provided
            Text(title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14.0)),
            SizedBox(height: 8.0),
            Text(value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
