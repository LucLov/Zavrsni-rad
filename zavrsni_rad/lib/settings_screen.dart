import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni_rad/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _tempFontSize;
  late String _tempFontFamily;
  late bool _tempBackgroundSound;
  late bool _tempQuizSound;

  final List<String> _fonts = ['Sans', 'Monospace', 'Serif'];

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _tempFontSize = settings.fontSize;
    _tempFontFamily = settings.fontFamily;
    _tempBackgroundSound = settings.backgroundSound;
    _tempQuizSound = settings.quizSound;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Postavke", style: TextStyle(fontSize: settings.fontSize + 6, fontFamily: settings.fontFamily)),
        backgroundColor: const Color(0XFFC4E2FF),
        foregroundColor: const Color(0xFF9D3D25),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40.0),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Izaberi font:", style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold, fontFamily: settings.fontFamily)),
            DropdownButton<String>(
              value: _tempFontFamily,
              isExpanded: true,
              iconSize: 40,
              onChanged: (String? newFont) {
                if (newFont != null) {
                  setState(() {
                    _tempFontFamily = newFont;
                  });
                }
              },
              items: _fonts.map((String font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child: Text(font, style: TextStyle(fontSize: 24, fontFamily: font)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text("Prilagodi veličinu fonta:", style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold, fontFamily: settings.fontFamily)),
            Slider(
              value: _tempFontSize,
              min: 24.0,
              max: 34.0,
              divisions: 8,
              label: _tempFontSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  _tempFontSize = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Text("Izgled odabranih opcija:", style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold, fontFamily: settings.fontFamily)),
            const SizedBox(height: 10),
            Text(
              "Ovo je primjer teksta",
              style: TextStyle(fontSize: _tempFontSize, fontFamily: _tempFontFamily),
            ),
            SwitchListTile(
              title: Text("Zvuk u pozadini", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
              value: _tempBackgroundSound,
              onChanged: (bool value) {
                setState(() {
                  _tempBackgroundSound = value;
                });
              },
            ),

            SwitchListTile(
              title: Text("Zvuk pri odgovoru", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
              value: _tempQuizSound,
              onChanged: (bool value) {
                setState(() {
                  _tempQuizSound = value;
                });
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  settings.updateFontFamily(_tempFontFamily);
                  settings.updateFontSize(_tempFontSize);
                  settings.setBackgroundSound(_tempBackgroundSound);
                  settings.setQuizSound(_tempQuizSound);
                  await settings.saveSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Postavke su spremljene", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily))),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: const Color(0XFFC4E2FF),
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                ),
                child: const Text("Primijeni"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
