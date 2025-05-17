import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni_rad/settings_provider.dart';
import 'package:zavrsni_rad/settings_screen.dart';
import 'info_screen.dart';
import 'about_app_screen.dart';
import 'winter_screen.dart';
import 'checking_knowledge.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Make sure preferences load first
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    ChangeNotifierProvider<SettingsProvider>.value(
      value: settingsProvider,
      child: const NavigatorApp(),
    ),
  );
}

class NavigatorApp extends StatelessWidget {
  const NavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/", // Set initial route
      routes: {
        "/" : (context) => const HomeScreen(),
        "/settings" : (context) => const SettingsScreen(),
        "/info" : (context) => const InfoScreen(),
        "/about" : (context) => const AboutAppScreen(),
        "/winter" : (context) => const WinterScreen(),
        "/checkingKnowledge" : (context) => const CheckingKnowledge(),
      },
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final fontSize = settings.fontSize;
    final fontFamily = settings.fontFamily;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/naslovnica2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.65, 
            left: 10,
            right: 10,
            child: Column(
              children: [
                IntrinsicWidth(
                  child: IntrinsicHeight(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/winter');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF9D3D25),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(
                        "Nauči i provježbaj znanje o mjesecima",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                IntrinsicWidth(
                  child: IntrinsicHeight(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/checkingKnowledge');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF9D3D25),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(
                        "Ispitaj znanje o mjesecima",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Positioned(
            bottom: 20, 
            left: 20,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/info');
              },
              icon: const Icon(Icons.info, size: 80, color: Color(0xFFA93741)),
              tooltip: "Info",
            ),
          ),
          Positioned(
            bottom: 20, 
            right: 20,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/about');
              },
              icon: const Icon(Icons.help, size: 80, color: Color(0xFFA93741)),
              tooltip: "Help",
            ),
          ),
          Positioned(
            top: 20, 
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
                backgroundColor: Colors.grey[800],
              ),
              child: const Icon(Icons.settings, size: 40, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}