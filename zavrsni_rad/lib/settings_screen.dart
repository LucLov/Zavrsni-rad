import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{
  double _fontSize = 20.0;
  String _selectedFont = 'Sans';
  List<String> _fonts = ['Sans', 'Monospace', 'Serif'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved settings
  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 20.0;
      _selectedFont = prefs.getString('font') ?? 'Sans';
    });
  }

  // Save font size
  void _saveFontSize(double size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', size);
    setState(() {
      _fontSize = size;
    });
  }

  // Save font
  void _saveFont(String font) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('font', font);
    setState(() {
      _selectedFont = font;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Postavke",
      style: TextStyle(fontSize: 30)),
      backgroundColor: Color(0XFFC4E2FF),
      foregroundColor: Color(0xFF9D3D25),
      leading: IconButton(
        icon: Icon (Icons.arrow_back,
        size: 40.0),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
        ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Izaberi font:", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedFont,
              isExpanded: true,
              iconSize: 40,
              onChanged: (String? newFont) {
                if (newFont != null) _saveFont(newFont);
              },
              items: _fonts.map<DropdownMenuItem<String>>((String font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child: Text(font, style: TextStyle(fontSize: 24, fontFamily: font)),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text("Prilagodi veličinu fonta:", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Slider(
              value: _fontSize,
              min: 24.0,
              max: 40.0,
              divisions: 10,
              label: _fontSize.round().toString(),
              onChanged: (double value) {
                _saveFontSize(value);
              },
            ),
            Text("Izgled odabranih opcija", 
            style: TextStyle(fontSize: _fontSize, fontFamily: _selectedFont),),
          ],
        ),
      ),
    );
  }
}
