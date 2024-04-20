import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'settings_page.dart'; // Użycie SettingsPage
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _notificationsEnabled = false;
  bool _dataLoaded = false;
  DateTime? _examDate;
  File? _image;
  String? _savedName, _savedAge, _savedEmail, _savedImagePath;

  // Public getters and setters
  String? get savedAge => _savedAge;
  String? get savedName => _savedName;
  String? get savedEmail => _savedEmail;
  bool get notificationsEnabled => _notificationsEnabled;
  DateTime? get examDate => _examDate;
  File? get image => _image;
  String? get savedImagePath => _savedImagePath;

  set savedAge(String? value) {
    setState(() {
      _savedAge = value;
    });
  }

  set examDate(DateTime? value) {
    setState(() {
      _examDate = value;
    });
  }

  set notificationsEnabled(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
  }

  set image(File? value) {
    setState(() {
      _image = value;
    });
  }

  set savedImagePath(String? value) {
    setState(() {
      _savedImagePath = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;
    if (!isFirstLaunch) {
      setState(() {
        _savedName = prefs.getString('name');
        _savedAge = prefs.getString('age');
        _savedEmail = prefs.getString('email');
        _savedImagePath = prefs.getString('imagePath');
        if (_savedImagePath != null) {
          _image = File(_savedImagePath!);
        }
        _dataLoaded = true;
      });
    }
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    await prefs.setString('name', _nameController.text);
    await prefs.setString('age', _ageController.text);
    await prefs.setString('email', _emailController.text);
    if (_image != null) {
      await prefs.setString('imagePath', _image!.path);
    }
    setState(() {
      _dataLoaded = true;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_dataLoaded) ...[
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Icon(Icons.upload, size: 30),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.all(24),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter your name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'Enter your age',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter your email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage(this)),
                      );
                    },
                    child: Text('Settings'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveData,
                    child: Text('Save Data'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_image != null)
                        Image.file(_image!,
                            width: 100, height: 100, fit: BoxFit.cover),
                      Column(
                        children: [
                          Text('$_savedName, $_savedAge',
                              style: TextStyle(fontSize: 18)),
                          Text('$_savedEmail', style: TextStyle(fontSize: 16)),
                          if (_examDate != null)
                            Text('Exam Date: ${_examDate!.toLocal()}'
                                .split(' ')[0]),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage(this)),
                      );
                    },
                    child: Text('Settings'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
