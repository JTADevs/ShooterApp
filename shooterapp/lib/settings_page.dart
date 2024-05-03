import 'package:flutter/material.dart';
import 'home_page.dart'; // Import class HomePageState

class SettingsPage extends StatefulWidget {
  final HomePageState parent;

  SettingsPage(this.parent);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController? _nameController; // Controller for name input
  DateTime? _examDate; // Local state for exam date

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: widget.parent.savedName); // Initialize with saved name
    _examDate = widget.parent.examDate; // Initialize with saved exam date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Change your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickExamDate(context),
              child: const Text('Change Exam Date'),
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

  void _pickExamDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _examDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _examDate = pickedDate;
      });
    }
  }

  void _saveSettings() {
    widget.parent.savedName = _nameController!.text;
    widget.parent.examDate = _examDate;
    Navigator.pop(context);
  }
}
