import 'package:flutter/material.dart';
import 'package:mjesec_po_mjesec/music_controller.dart';
import 'package:provider/provider.dart';
import 'package:mjesec_po_mjesec/settings_provider.dart';
import 'package:mjesec_po_mjesec/settings_screen.dart';
import 'info_screen.dart';
import 'about_app_screen.dart';
import 'winter_screen.dart';
import 'checking_knowledge.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Make sure preferences load first
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    //DeviceOrientation.portraitDown,  // Optional: if you want to allow upside-down portrait
  ]);

  runApp(
    ChangeNotifierProvider<SettingsProvider>.value(
      value: settingsProvider,
      child: const NavigatorApp(),
    ),
  );
}

class NavigatorApp extends StatefulWidget {
  const NavigatorApp({super.key});

  @override
  State<NavigatorApp> createState() => _NavigatorAppState();
}

class _NavigatorAppState extends State<NavigatorApp> with WidgetsBindingObserver {
  bool _wasPlayingMusic = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    MusicController().dispose(); // Stops and disposes music on app exit
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Save the music state before pausing
      _wasPlayingMusic = settings.backgroundSound;
      MusicController().stopMusic();
    }

    if (state == AppLifecycleState.resumed) {
      // Resume music only if it was playing before
      if (_wasPlayingMusic && settings.backgroundSound) {
        MusicController().startMusic();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: settings.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hr'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: "/",
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppLocalizations.of(context)!.homeBg),
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
                      child: Text(
                        AppLocalizations.of(context)!.learnAndPractice,
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
                      child: Text(
                        AppLocalizations.of(context)!.testKnowledge,
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