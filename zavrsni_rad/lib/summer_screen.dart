import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni_rad/settings_provider.dart';
import 'package:zavrsni_rad/settings_screen.dart';
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
  //runApp(const NavigatorApp());
}

class NavigatorApp extends StatelessWidget {
  const NavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/summer", // Set initial route
      routes: {
        "/summer" : (context) => const SummerScreen(),
        "/settings" : (context) => const SettingsScreen(),
      },
    );
  }
}

class SummerScreen extends StatefulWidget {
  const SummerScreen({super.key});

  @override
  _SummerScreenState createState() => _SummerScreenState();
}

class _SummerScreenState extends State<SummerScreen> {
  bool isSrpanjSelected = false;
  bool isKolovozSelected = false;
  bool isRujanSelected = false;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final fontSize = settings.fontSize;
    final fontFamily = settings.fontFamily;

    return Scaffold(
      body: PageView(
        children: [
          _buildSummerPage(context, settings),
        ],
      ),
    );
  }

  Widget _buildSummerPage(BuildContext context, SettingsProvider settings) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/5.png',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                    ElevatedButton(
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
                ],
              )
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.topRight,
                child: _buildBox(
                    context,
                    settings,
                    "7. SRPANJ",
                    "SRPANJ",
                    "7.",
                    "srpanj_slika.png",
                    "31",
                    "Klikni za informacije o srpnju!",
                    isSrpanjSelected,
                    (bool isSelected) {
                      setState(() {
                        isSrpanjSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildBox(
                    context,
                    settings,
                    "8. KOLOVOZ",
                    "KOLOVOZ",
                    "8.",
                    "kolovoz_slika.png",
                    "31",
                    "Klikni za informacije o kolovozu!",
                    isKolovozSelected,
                    (bool isSelected) {
                      setState(() {
                        isKolovozSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.centerRight,
                child: _buildBox(
                    context,
                    settings,
                    "9. RUJAN",
                    "RUJAN",
                    "9.",
                    "rujan_slika.png",
                    "30",
                    "Klikni za informacije o rujnu!",
                    isRujanSelected,
                    (bool isSelected) {
                      setState(() {
                        isRujanSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 115),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: FilledButton(
                  onPressed: () {
                    _showMatchingGameDialog(context, settings);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.deepOrange,
                    ),
                  ),
                  child: Text(
                    "Provježbaj znanje o ljetnim mjesecima!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: settings.fontSize,
                      fontFamily: settings.fontFamily,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBox(
    BuildContext context,
    SettingsProvider settings,
    String buttonText,
    String title,
    String monthNumber,
    String monthPicture,
    String daysInMonth,
    String instructionText,
    bool isSelected,
    Function(bool) onSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            instructionText,
            style: TextStyle(fontSize: settings.fontSize < 29 ? settings.fontSize - 4 : settings.fontSize - 10, fontFamily: settings.fontFamily, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 200,
              maxWidth: 480,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.8),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  onSelected(!isSelected); // Toggle the selection state
                });
                // Show the dialog when button is pressed
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontFamily: settings.fontFamily, fontSize: settings.fontSize)),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Ensures the row only takes up as much space as needed
                              mainAxisAlignment: MainAxisAlignment.center, // Ensures the children are centered within the row
                              children: [
                                // Left container
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Redni broj u godini:",
                                        style: TextStyle(
                                          fontFamily: settings.fontFamily,
                                          fontSize: settings.fontSize - 6,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        monthNumber,
                                        style: TextStyle(
                                          fontFamily: settings.fontFamily,
                                          fontSize: settings.fontSize - 6,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20), // Space between items
                                // Image in the center
                                Container(
                                  width: 200,
                                  height: 200,
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Image.asset('assets/images/$monthPicture'),
                                ),
                                const SizedBox(width: 20), // Space between items
                                // Right container
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Broj dana:",
                                        style: TextStyle(
                                          fontFamily: settings.fontFamily,
                                          fontSize: settings.fontSize - 6,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        daysInMonth,
                                        style: TextStyle(
                                          fontFamily: settings.fontFamily,
                                          fontSize: settings.fontSize - 6,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: settings.fontSize,
                                fontFamily: settings.fontFamily,
                                color: Colors.black,
                              ),
                              children: _buildActivityText(title, settings),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Zatvori', style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                buttonText,
                style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildActivityText(String title, settings) {
    List<TextSpan> spans = [];
    
    // Example of splitting and applying styles to specific parts of the text
    if (title == "SRPANJ") {
      spans.add(TextSpan(text: "Srpanj je mjesec kada ljeto prelazi u svoju najživlju fazu. Dani su dugi i vrući, a more i rijeke postaju spas od vrućine. To je vrijeme bezbrižnosti i uživanja.\nSunce neumorno grije, bez oblaka na nebu - takvo stanje visokih temperatura nazivamo ", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black)));
      spans.add(TextSpan(text: "toplinski val", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: ". Tada je najbolje rashladiti se uz", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black)));
      spans.add(TextSpan(text: " lubenicu", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: "!", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black)));
    }
    
    if (title == "KOLOVOZ") {
      spans.add(TextSpan(text: "Vrijeme je žetve, a i početka berbe nekih voćnih kultura. Sazrijevaju", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black)));
      spans.add(TextSpan(text: " rajčice, krastavci i kukuruz", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight : FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: ".\nVisoke temperature i dalje traju, što možemo vidjeti po treperenju zraka. Tu pojavu nazivamo ", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black)));
      spans.add(TextSpan(text: "vrela izmaglica (ljetna fatamorgana)", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: ".\nPreporuka je", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black)));
      spans.add(TextSpan(text: " zaštititi se od sunca", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight : FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: " kapom, svijetlom odjećom i kremom za sunce.", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black)));
    }

    if (title == "RUJAN") {
      spans.add(TextSpan(text: "Jesen je na vidiku - dani su još uvijek topli, a noći postaju svježije. Vrijeme je berbe", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black)));
      spans.add(TextSpan(text: " grožđa, jabuka i krušaka", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: ".\nNakon dugačkog odmora učenici ponovno kreću u školske klupe.\n", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black)));
      spans.add(TextSpan(text: "Jesen započinje krajem ovog mjeseca jesenskom ravnodnevnicom.", style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black)));    }

    return spans;
  }
}
  void _showMatchingGameDialog(BuildContext context, SettingsProvider settings) {
    final months = ["srpanj", "kolovoz", "rujan"];
    final correctDescriptionsMap = {
      "srpanj": "7. mjesec",
      "kolovoz": "8. mjesec",
      "rujan": "9. mjesec",
    };

    final descriptions = correctDescriptionsMap.values.toList()..shuffle();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 700,
                ),
                child: InteractiveViewer(
                  panEnabled: true,
                  child: MatchingGame(
                    months: months,
                    descriptions: descriptions,
                    correctDescriptionsMap: correctDescriptionsMap,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(milliseconds: 100), () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Upute za igru", textAlign: TextAlign.center, style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
          content: Text(
            "Spoji svaki mjesec s odgovarajućim opisom.\n\n"
            "Dovuci opis mjeseca s desne strane do naziva mjeseca s lijeve strane ili klikni mjesec pa zatim klikni na opis mjeseca.\n",
            style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
            ),
          ],
        );
      },
    );
  });
}


class MatchingGame extends StatefulWidget {
  final List<String> months;
  final List<String> descriptions;
  final Map<String, String> correctDescriptionsMap;


  const MatchingGame({super.key, required this.months, required this.descriptions, required this.correctDescriptionsMap});

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  Timer? _autoCloseTimer;
  final Map<String, String> matchedPairs = {};
  final Set<String> usedDescriptions = {};
  late List<String> randomizedDescriptions;
  bool showResults = false;
  String? selectedMonth;

  String? _correctMatch(String month) {
    switch (month) {
      case "srpanj":
        return "7. mjesec";
      case "kolovoz":
        return "8. mjesec";
      case "rujan":
        return "9. mjesec";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    randomizedDescriptions = List.from(widget.descriptions)..shuffle();
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  void _onDrop(String month, String description) {
    if (!matchedPairs.containsKey(month) && !usedDescriptions.contains(description)) {
      setState(() {
        matchedPairs[month] = description;
        usedDescriptions.add(description);
        selectedMonth = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Spoji mjesec s opisom:", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                children: widget.months.map((month) {
                  final matchedDesc = matchedPairs[month];
                  final isCorrect = matchedDesc == _correctMatch(month);
                  return DragTarget<String>(
                    onAccept: (desc) => _onDrop(month, desc),
                    builder: (context, candidateData, rejectedData) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMonth = month;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: showResults
                                ? (isCorrect ? Colors.green[300] : Colors.red[300])
                                : (matchedDesc != null ? Colors.grey[400] : (selectedMonth == month ? Colors.yellow[100] : Colors.blue[100])),
                            borderRadius: BorderRadius.circular(10),
                            
                          ),
                          child: Text(
                            matchedDesc != null ? "$month\n $matchedDesc" : month,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: settings.fontSize - 4, fontFamily: settings.fontFamily),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: randomizedDescriptions.where((desc) => !usedDescriptions.contains(desc)).map((desc) {
                  return Draggable<String>(
                    data: desc,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(desc, style: TextStyle(fontSize: settings.fontSize - 4, fontFamily: settings.fontFamily, color: Colors.white)),
                      ),
                    ),
                    childWhenDragging: Container(),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedMonth != null && !matchedPairs.containsKey(selectedMonth) && !usedDescriptions.contains(desc)) {
                          _onDrop(selectedMonth!, desc);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(desc, textAlign: TextAlign.center, style: TextStyle(fontSize: settings.fontSize - 4, fontFamily: settings.fontFamily)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: showResults ? () {
                _autoCloseTimer?.cancel();
                setState(() {
                  matchedPairs.clear();
                  usedDescriptions.clear();
                  showResults = false;
                  selectedMonth = null;
                  randomizedDescriptions = List.from(widget.correctDescriptionsMap.values)..shuffle();
                });
              } : null,
              child: Text("Igraj ponovo", style: TextStyle(fontSize: settings.fontSize - 6, fontFamily: settings.fontFamily)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showResults = true;
                });
                // Pokreni timer koji zatvara dijalog nakon 6 sekundi
                _autoCloseTimer?.cancel(); // Ako već postoji, otkaži ga
                _autoCloseTimer = Timer(const Duration(seconds: 3), () {
                  if (mounted && Navigator.canPop(context)) {
                    Navigator.of(context).pop(); // Zatvori popup
                  }
                });
              },
              child: Text("Provjeri rezultat", style: TextStyle(fontSize: settings.fontSize - 6, fontFamily: settings.fontFamily)),
            ),
          ],
        )
      ],
    );
  }
}
