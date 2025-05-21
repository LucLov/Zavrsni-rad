import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mjesec_po_mjesec/settings_provider.dart';
import 'package:mjesec_po_mjesec/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Make sure preferences load first
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    ChangeNotifierProvider<SettingsProvider>.value(
      value: settingsProvider,
      child: const InfoScreen(),
    ),
  );
  //runApp(const NavigatorApp());
}

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.infoTitle,
        style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // So it only takes needed space
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.info1,
                style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.info2,
                style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.info3,
                style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.info4,
                style: TextStyle(fontSize: settings.fontSize - 6, fontFamily: settings.fontFamily),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),

    );
  }
}
