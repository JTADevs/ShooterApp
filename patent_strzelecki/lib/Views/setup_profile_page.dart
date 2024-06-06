import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SetupProfilePage extends StatefulWidget {
  const SetupProfilePage({super.key});

  @override
  _SetupProfilePageState createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> {
  final TextEditingController _nicknameController = TextEditingController();
  DateTime? _examDate;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    FirebaseFirestore.instance
        .collection('account')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      Map<String, dynamic>? data = value.data();
      if (data != null) {
        _nicknameController.text = data['nickname'] ?? '';
        if (data['examDate'] != null) {
          _examDate = DateTime.parse(data['examDate']);
        }
      }
    });
  }

  Future<void> _saveData() async {
    User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('account').doc(user.uid).set({
      'nickname': _nicknameController.text,
      'examDate': _examDate != null ? _examDate!.toIso8601String() : null,
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Profile'),
        backgroundColor: Colors.grey[800], // Dark grey color for the AppBar
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey, Colors.black], // Grey gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Complete your profile',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white), // White text for header
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
              style: const TextStyle(color: Colors.white), // White text
              decoration: InputDecoration(
                labelText: 'Nickname',
                labelStyle: const TextStyle(color: Colors.white), // White label
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // White border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white), // White border when focused
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                'Exam Date: ${_examDate?.toString().split(' ')[0] ?? 'Not Set'}',
                style: const TextStyle(color: Colors.white), // White text
              ),
              trailing: const Icon(
                Icons.calendar_today,
                color: Colors.white, // White icon
              ),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _examDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _examDate = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700], // Dark grey button color
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text(
                'Start',
                style: TextStyle(
                    fontSize: 18.0, color: Colors.white), // White text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
