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
      initialRoute: "/spring", // Set initial route
      routes: {
        "/spring" : (context) => const SpringScreen(),
        "/settings" : (context) => const SettingsScreen(),
      },
    );
  }
}

class SpringScreen extends StatefulWidget {
  const SpringScreen({super.key});

  @override
  _SpringScreenState createState() => _SpringScreenState();
}

class _SpringScreenState extends State<SpringScreen> {
  bool isTravanjSelected = false;
  bool isSvibanjSelected = false;
  bool isLipanjSelected = false;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final fontSize = settings.fontSize;
    final fontFamily = settings.fontFamily;

    return Scaffold(
      body: PageView(
        children: [
          _buildSpringPage(context, settings),
        ],
      ),
    );
  }

  Widget _buildSpringPage(BuildContext context, SettingsProvider settings) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/4.png',
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
                    "4. TRAVANJ",
                    "TRAVANJ",
                    "4.",
                    "travanj_slika.png",
                    "30",
                    "Klikni za informacije o travnju!",
                    isTravanjSelected,
                    (bool isSelected) {
                      setState(() {
                        isTravanjSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildBox(
                    context,
                    settings,
                    "5. SVIBANJ",
                    "SVIBANJ",
                    "5.",
                    "svibanj_slika.png",
                    "30",
                    "Klikni za informacije o svibnju!",
                    isSvibanjSelected,
                    (bool isSelected) {
                      setState(() {
                        isSvibanjSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.centerRight,
                child: _buildBox(
                    context,
                    settings,
                    "6. LIPANJ",
                    "LIPANJ",
                    "6.",
                    "lipanj_slika.png",
                    "31",
                    "Klikni za informacije o lipnju!",
                    isLipanjSelected,
                    (bool isSelected) {
                      setState(() {
                        isLipanjSelected = isSelected;
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
                    "Provježbaj znanje o proljetnim mjesecima!",
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

  List<TextSpan> _buildActivityText(String title, SettingsProvider settings) {
    List<TextSpan> spans = [];
    
    // Example of splitting and applying styles to specific parts of the text
    if (title == "TRAVANJ") {
      spans.add(TextSpan(text: "U travnju su", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: " dani sve topliji", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: " što znači da sve više vremena možemo provoditi vani na otvorenom. Osim toga, vrijeme može biti nepredvidivo zbog pokojeg kišnog oblaka na nebu.\nU travnju se najčešće obilježava ", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: "Uskrs", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: " kojem se sva djeca vesele jer s njime dolaze i proljetni praznici.\nPrvi dan ovog mjeseca poznatiji je kao", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: " Dan šale", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: " ili", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: " Prvi April", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: " stoga nemoj zaboraviti nasamariti nekoga!", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));


    }
    
    if (title == "SVIBANJ") {
      spans.add(TextSpan(text: "Proljeće je u punom jeku i", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: " dani su sve duži", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: ". Livade, vrtovi i parkovi su puni boja i mirisa koje obogaćuju pčelice i leptiri. U svibnju uživamo u slatkim", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: " jagodama", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: " i ostalim voćkama koje sazrijevaju.", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));

    }
    if (title == "LIPANJ") {
      spans.add(TextSpan(text: "Dani su jako dugi i sunce sija po cijele dane. Učenici nestrpljivo čekaju kraj školske godine i početak ljetnih praznika.\n", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: "Krajem lipnja započinje ljeto", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: " - tada je dan najduži, a noć najkraća. Taj dan nazivamo", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: " ljetni solsticij", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: ".", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
    }
    //spans.add(TextSpan(text: activityText, style: TextStyle(fontSize: 24, color: Colors.black)));
    
    return spans;
  }
}
  void _showMatchingGameDialog(BuildContext context, SettingsProvider settings) {
  final months = ["travanj", "svibanj", "lipanj"];
  final correctDescriptionsMap = {
      "travanj": "4. mjesec",
      "svibanj": "5. mjesec",
      "lipanj": "6. mjesec",
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
                maxWidth: 700, // Increase width here to avoid overflow
              ),
              child: SingleChildScrollView(
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

  // Delay the second dialog to show instructions
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
      case "travanj":
        return "4. mjesec";
      case "svibanj":
        return "5. mjesec";
      case "lipanj":
        return "6. mjesec";
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