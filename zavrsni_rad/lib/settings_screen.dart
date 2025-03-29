import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> fonts = ["Sans", "Serif", "Monospace"];
  String selectedFont = "Sans";
  double fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved font and font size
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedFont = prefs.getString("font") ?? "Sans";
      fontSize = prefs.getDouble("fontSize") ?? 16.0;
    });
  }

  // Save font and font size
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("font", selectedFont);
    await prefs.setDouble("fontSize", fontSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Font Selection
            Text("Choose Font:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedFont,
              items: fonts.map((String font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child: Text(font, style: TextStyle(fontFamily: font)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedFont = newValue;
                  });
                  _saveSettings();
                }
              },
            ),
            SizedBox(height: 20),

            // Font Size Adjustment
            Text("Font Size: ${fontSize.toInt()}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Slider(
              value: fontSize,
              min: 12.0,
              max: 32.0,
              divisions: 10,
              label: fontSize.toInt().toString(),
              onChanged: (double value) {
                setState(() {
                  fontSize = value;
                });
                _saveSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}
