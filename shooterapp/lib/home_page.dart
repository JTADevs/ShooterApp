import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_page.dart'; // Use SettingsPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  bool notificationsEnabled = false;

  DateTime? _examDate;
  bool _dataLoaded = false;
  String? _savedName, _savedAge;
  String? _gender;
  String _avatarPath = 'Assets/male.webp'; // default avatar

  // Define getters
  String? get savedName => _savedName;
  String? get savedAge => _savedAge;
  DateTime? get examDate => _examDate;
  String? get gender => _gender;

  // Define setters if needed for modification from SettingsPage
  set savedName(String? value) {
    _savedName = value;
    _savePreferences();
  }

  

  set savedAge(String? value) {
    _savedAge = value;
    _savePreferences();
  }

  set examDate(DateTime? value) {
    _examDate = value;
    _savePreferences();
  }

  set gender(String? value) {
    _gender = value;
    _updateAvatar();
    _savePreferences();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _savedName ?? '');
    await prefs.setString('age', _savedAge ?? '');
    await prefs.setString('gender', _gender ?? 'Male');
    if (_examDate != null) {
      await prefs.setString('examDate', _examDate!.toIso8601String());
    }
    setState(() {});
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _savedName = prefs.getString('name');
    _savedAge = prefs.getString('age');
    _gender = prefs.getString('gender');
    _examDate = DateTime.tryParse(prefs.getString('examDate') ?? '');
    _dataLoaded = _savedName != null; // Data loaded if name is not null
    _updateAvatar();
    setState(() {});
  }

  void _updateAvatar() {
    if (_gender == "Male") {
      _avatarPath = 'Assets/male.webp';
    } else if (_gender == "Female") {
      _avatarPath = 'Assets/female.webp';
    }
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('age', _ageController.text);
    await prefs.setString('gender', _gender ?? 'Male');
    if (_examDate != null) {
      await prefs.setString('examDate', _examDate!.toIso8601String());
    }
    _savedName = _nameController.text;
    _savedAge = _ageController.text;
    _dataLoaded = true;
    _updateAvatar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
      ),
      body: _dataLoaded ? _buildProfileView() : _buildInputForm(),
      floatingActionButton: _dataLoaded
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SettingsPage(this)));
              },
              child: Icon(Icons.settings),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }

  Widget _buildInputForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: _gender,
            hint: Text("Select Gender"),
            items: <String>['Male', 'Female'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _gender = value;
                _updateAvatar();
              });
            },
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _examDate ?? DateTime.now(),
                firstDate: DateTime(2001),
                lastDate: DateTime(2101),
              );
              if (picked != null) setState(() => _examDate = picked);
            },
            child: Text('Set Exam Date'),
          ),
          ElevatedButton(
            onPressed: _saveData,
            child: Text('Save Data'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Increased the size of the avatar image
          Container(
            width: 150, // Increased size from 100 to 150
            height: 150, // Increased size from 100 to 150
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(_avatarPath),
              ),
            ),
          ),
          SizedBox(height: 20), // Added some spacing between the image and text
          // Increased the font size and made text bold
          Text('Name: $_savedName',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10), // Added some spacing between text lines
          Text('Age: $_savedAge',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10), // Added some spacing between text lines

          if (_examDate != null)
            Text('Exam Date: ${_examDate!.toIso8601String().split('T')[0]}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
