import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni_rad/settings_provider.dart';
import 'package:zavrsni_rad/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Make sure preferences load first
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    ChangeNotifierProvider<SettingsProvider>.value(
      value: settingsProvider,
      child: const AboutAppScreen(),
    ),
  );
  //runApp(const NavigatorApp());
}
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutTitle,
        style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
        backgroundColor: Color(0XFFC4E2FF),
        foregroundColor: Color(0xFF9D3D25),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 40.0),
          onPressed: () {
            Navigator.of(context).pop(); // Vraća korisnika na prethodnu stranicu
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView (
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Optional, depending on the layout you want
            children: [
              Text(
                AppLocalizations.of(context)!.about1,
                style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Optional space between text blocks
              Text(
                AppLocalizations.of(context)!.about2,
                style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Optional space between text blocks
              Text(
                AppLocalizations.of(context)!.about3,
                style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Optional space between text blocks
              Text(
                AppLocalizations.of(context)!.about4,
                style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Optional space between text blocks
              Text(
                AppLocalizations.of(context)!.about5,
                style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                textAlign: TextAlign.center,
              ),
            ],
          ),),
      ),
    );
  }
}
