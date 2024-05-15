import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart'; // Załóżmy, że taki jest poprawny import Twojego HomePage

class SetupProfilePage extends StatefulWidget {
  const SetupProfilePage({super.key});

  @override
  _SetupProfilePageState createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> {
  final TextEditingController _nicknameController = TextEditingController();
  String _gender = 'Male'; // Default value
  DateTime? _examDate;
  String _imagePath = 'Assets/images/male.jpg'; // Default image path

  @override
  void initState() {
    super.initState();
    updateImage(_gender);
  }

  void updateImage(String gender) {
    if (gender == 'Male') {
      _imagePath = 'Assets/images/male.webp';
    } else {
      _imagePath = 'Assets/images/female.webp';
    }
  }

  Future<void> saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    User user = FirebaseAuth.instance.currentUser!;
    firestore.collection('account').doc(user.uid).set({
      'nickname': _nicknameController.text,
      'gender': _gender,
      'examDate': _examDate != null ? _examDate!.toIso8601String() : null
    });

    await prefs.setString('nickname', _nicknameController.text);
    await prefs.setString('gender', _gender);
    if (_examDate != null) {
      await prefs.setString('examDate', _examDate!.toIso8601String());
    }

    // Navigate to HomePage after saving
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Your Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(_imagePath),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: 'Nickname',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _gender,
              isExpanded: true,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _gender = newValue;
                    updateImage(newValue);
                  });
                }
              },
              items: <String>['Male', 'Female', 'Other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                  'Exam Date: ${_examDate?.toString().split(' ')[0] ?? 'Not Set'}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _examDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != _examDate) {
                  setState(() {
                    _examDate = picked;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveData,
              child: Text('Save and Finish'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor, // text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
