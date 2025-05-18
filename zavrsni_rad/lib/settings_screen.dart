import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni_rad/settings_provider.dart';
import 'package:zavrsni_rad/music_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
  late String _tempLanguageCode;
  static const Map<String, String> languageMap = {
    'hr': 'Hrvatski',
    'en': 'English',
  };


  late bool _originalBackgroundSound;
  bool _applied = false;

  final List<String> _fonts = ['Sans', 'Monospace', 'Serif', 'OpenDyslexic'];

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _tempFontSize = settings.fontSize;
    _tempFontFamily = settings.fontFamily;
    _tempBackgroundSound = settings.backgroundSound;
    _tempQuizSound = settings.quizSound;
    _tempLanguageCode = settings.locale.languageCode;
    _originalBackgroundSound = settings.backgroundSound;
  }

  @override
  void dispose() {
    if (!_applied && _tempBackgroundSound != _originalBackgroundSound) {
      // revert previewed sound
      MusicController().updateMusic(_originalBackgroundSound);
    }
    super.dispose();
  }

  Future<bool> _handleBack() async {
    if (!_applied && _tempBackgroundSound != _originalBackgroundSound) {
      MusicController().updateMusic(_originalBackgroundSound);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingsTitle, style: TextStyle(fontSize: settings.fontSize + 6, fontFamily: settings.fontFamily)),
          backgroundColor: const Color(0XFFC4E2FF),
          foregroundColor: const Color(0xFF9D3D25),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 40.0),
            onPressed: () {
              _handleBack();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.selectFont, style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold, fontFamily: settings.fontFamily)),
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
                    child: Text(font, style: TextStyle(fontSize: settings.fontSize, fontFamily: font.toLowerCase())),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.adjustFontSize, style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold, fontFamily: settings.fontFamily)),
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
              Text(AppLocalizations.of(context)!.preview, style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold, fontFamily: settings.fontFamily)),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.previewText,
                style: TextStyle(fontSize: _tempFontSize, fontFamily: _tempFontFamily),
              ),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.chooseLanguage, style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold, fontFamily: settings.fontFamily)),
              DropdownButton<String>(
                value: _tempLanguageCode,
                isExpanded: true,
                iconSize: 40,
                onChanged: (String? newCode) {
                  if (newCode != null) {
                    setState(() {
                      _tempLanguageCode = newCode;
                    });
                  }
                },
                items: languageMap.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value, style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
                  );
                }).toList(),
              ),

              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.backgroundSound, style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
                value: _tempBackgroundSound,
                onChanged: (bool value) {
                  setState(() {
                    _tempBackgroundSound = value;
                  });
                  // Preview only, not saved yet
                  MusicController().updateMusic(value);
                },
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.quizSound, style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
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
                    settings.setLocale(Locale(_tempLanguageCode));
                    await settings.saveSettings();

                    _applied = true;
                    _originalBackgroundSound = _tempBackgroundSound;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.settingsSaved, style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: const Color(0XFFC4E2FF),
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                  ),
                  child: Text(AppLocalizations.of(context)!.apply),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
