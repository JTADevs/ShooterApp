import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'home_page.dart'; // Import klasy HomePageState

class SettingsPage extends StatefulWidget {
  final HomePageState parent;

  SettingsPage(this.parent);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController? _ageController;
  DateTime? _examDate;
  bool? _notificationsEnabled;
  File? _newImage;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(text: widget.parent.savedAge);
    _examDate = widget.parent.examDate; // używanie gettera
    _notificationsEnabled =
        widget.parent.notificationsEnabled; // używanie gettera
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            if (_newImage != null)
              Image.file(_newImage!,
                  width: 100, height: 100, fit: BoxFit.cover),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Change Image'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Change your age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _pickExamDate(context),
              child: const Text('Change Exam Date'),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Notifications'),
              value: _notificationsEnabled ?? false,
              onChanged: (val) {
                setState(() {
                  _notificationsEnabled = val;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
    }
  }

  void _pickExamDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _examDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _examDate = pickedDate;
        });
      }
    });
  }

  void _saveSettings() {
    widget.parent.savedAge = _ageController!.text; // Używanie settera
    widget.parent.examDate = _examDate; // Używanie settera
    widget.parent.notificationsEnabled =
        _notificationsEnabled!; // Używanie settera
    widget.parent.image = _newImage; // Używanie settera
    if (_newImage != null) {
      widget.parent.savedImagePath = _newImage!.path; // Używanie settera
    }
    Navigator.pop(context);
  }
}
