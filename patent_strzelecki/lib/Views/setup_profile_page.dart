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
    FirebaseFirestore.instance.collection('account').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      Map<String, dynamic>? dane = value.data();
      print(dane);
      if (dane != null){
        _nicknameController.text = dane['nickname'] ?? 'No nickname';
        _gender = dane['gender'] ?? 'Male';
        _examDate = DateTime.parse(dane['examDate']);
      }
    });

    super.initState();
    updateImage(_gender);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   updateImage(_gender);
  // }

  void updateImage(String gender) {
    if (gender == 'Male') {
      _imagePath = 'Assets/images/male.webp';
    } else {
      _imagePath = 'Assets/images/female.webp';
    }
  }

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

  Future<void> saveData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    User user = FirebaseAuth.instance.currentUser!;
    firestore.collection('account').doc(user.uid).set({
      'nickname': _nicknameController.text,
      'gender': _gender,
      'examDate': _examDate != null ? _examDate!.toIso8601String() : null
    });

    // Navigate to HomePage after saving
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, String>>(
          future: getUserData(),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(_imagePath),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    labelText: 'Nickname',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                      'Exam Date: ${_examDate?.toString().split(' ')[0] ?? 'Not Set'}'),
                  trailing: const Icon(Icons.calendar_today),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveData,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor, // text color
                  ),
                  child: const Text('Save and Finish'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
