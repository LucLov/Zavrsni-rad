import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';

void main() {
  runApp(const NavigatorApp());
}

class NavigatorApp extends StatelessWidget {
  const NavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/", // Set initial route
      routes: {
        "/": (context) => const HomeScreen(),
        "/settings": (context) => const SettingsScreen(),
      },
    );
  }
}


/*class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mjesec po mjesec',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: HomeScreen(),
    );
  }
}
*/
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _fontSize = 20.0;
  String _font = "Sans";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 20.0;
      _font = prefs.getString('font') ?? "Sans";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/naslovnica2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Buttons section
          Positioned(
            top: MediaQuery.of(context).size.height * 0.65, 
            left: 10,
            right: 10,
            child: Column(
              children: [
                SizedBox(
                  width: 800,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[100],
                      foregroundColor: Color(0xFF9D3D25),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontFamily: _font,
                        fontSize: _fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(
                      "Nauči i provježbaj znanje o mjesecima",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 800,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[100],
                      foregroundColor: Color(0xFF9D3D25),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontFamily: _font,
                        fontSize: _fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(
                      "Ispitaj znanje o mjesecima",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info button
          Positioned(
            bottom: 20, 
            left: 20,
            child: IconButton(
              onPressed: () {
                print("Info button pressed");
              },
              icon: Icon(Icons.info, size: 80, color: Color(0xFFA93741)), 
              tooltip: "Info",
            ),
          ),
          // Help button
          Positioned(
            bottom: 20, 
            right: 20,
            child: IconButton(
              onPressed: () {
                print("Help button pressed");
              },
              icon: Icon(Icons.help, size: 80, color: Color(0xFFA93741)), 
              tooltip: "Help",
            ),
          ),
          // Settings button
          Positioned(
            top: 20, 
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(15),
                backgroundColor: Colors.grey[800],
              ),
              child: Icon(Icons.settings, size: 40, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
