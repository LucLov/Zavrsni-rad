import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'spring_screen.dart';
import 'summer_screen.dart';
import 'fall_screen.dart';
import "settings_screen.dart";

void main() {
  runApp(const NavigatorApp());
}

class NavigatorApp extends StatelessWidget {
  const NavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/winter", // Set initial route
      routes: {
        "/winter" : (context) => const WinterScreen(),
        "/settings" : (context) => const SettingsScreen(),
      },
    );
  }
}

class WinterScreen extends StatefulWidget {
  const WinterScreen({super.key});

  @override
  _WinterScreenState createState() => _WinterScreenState();
}

class _WinterScreenState extends State<WinterScreen> {
  bool isSijecanjSelected = false;
  bool isVeljacaSelected = false;
  bool isOzujakSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          _buildWinterPage(context),
          SpringScreen(),
          SummerScreen(), 
          FallScreen(),
        ],
      ),
    );
  }

  Widget _buildWinterPage(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/3.png',
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
              ),
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.topRight,
                child: _buildBox(
                    context,
                    "1. SIJEČANJ",
                    "SIJEČANJ",
                    "1.",
                    "31",
                    "Sa siječnjem započinjemo novu godinu. Često se prave novogodišnje odluke to jest planovi i želje za godinu koja dolazi. U siječnju se uziva u zadnjim blagdanskim danima i praznicima. Odlazi se na sankanje, grudanje i skijanje. Djeca se vraćaju u školu i nastavljaju učiti.",
                    24,
                    "Klikni za informacije o siječnju!",
                    isSijecanjSelected,
                    (bool isSelected) {
                      setState(() {
                        isSijecanjSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildBox(
                    context,
                    "2. VELJAČA",
                    "VELJAČA",
                    "2.",
                    "28, a svake četvrte godine 29",
                    "Veljača je najkraći mjesec u godini. Svaka četvrta godina u kojoj veljača ima 29 dana zove se prijestupna godina. Zima još traje, ali dani polako počinju biti duži.\nU veljači se obilježavaju Maškare (Fašnik, Poklade). Djeca se maskiraju u svoje omiljene superjunake, princeze i razne druge likove te se održavaju povorke. \nTakođer, obilježava se i Valentinovo - dan kada posebnu pažnju dodjeljujemo ljubavi prema prijateljima, obitelji, a i simpatijama.",
                    24,
                    "Klikni za informacije o veljači!",
                    isVeljacaSelected,
                    (bool isSelected) {
                      setState(() {
                        isVeljacaSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.centerRight,
                child: _buildBox(
                    context,
                    "3. OŽUJAK",
                    "OŽUJAK",
                    "3.",
                    "31",
                    "Cvijeće raste, drveća pupaju, a ptice pjevaju. Ptice selice poput lastavica, roda i grlica se vraćaju iz toplijih krajeva, a proljeće nagovještaju i vjesnici proljeća - visibabe, jaglaci, ljubičice.\nKrajem ožujka počinje proljeće, a baš tada dan i noć traju približno dugo - njega nazivamo proljetni solsticij.",
                    24,
                    "Klikni za informacije o ožujku!",
                    isOzujakSelected,
                    (bool isSelected) {
                      setState(() {
                        isOzujakSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 150),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: FilledButton(
                  onPressed: () {
                    _showMatchingGameDialog(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.deepOrange,
                    ),
                  ),
                  child: const Text(
                    "Provježbaj znanje o zimskim mjesecima!",
                    style: TextStyle(
                      fontSize: 24,
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
    String buttonText,
    String title,
    String monthNumber,
    String daysInMonth,
    String activityText,
    double fontSize,
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
            style: TextStyle(fontSize: fontSize - 4, color: Colors.black),
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
                    //color: isSelected ? Colors.blue : Colors.transparent, // Blue border when selected
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
                    title: Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 24, color: Colors.black, backgroundColor: Colors.amber), // base style
                            children: [
                              TextSpan(
                                text: 'Redni broj u godini: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: '$monthNumber',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        //Text("Broj dana: $daysInMonth", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 24, color: Colors.black, backgroundColor: Colors.amber), // base style
                            children: [
                              TextSpan(
                                text: 'Broj dana: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: '$daysInMonth',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(activityText, style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Zatvori', style: TextStyle(fontSize: 24)),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                buttonText,
                style: TextStyle(fontSize: fontSize, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMatchingGameDialog(BuildContext context) {
    final months = ["Siječanj", "Veljača", "Ožujak"];
    final descriptions = [
      "Oblačimo kostime i slavimo Maškare.",
      "Najavljuju se sunčani dani i dolazi proljeće.",
      "Započinjemo novu godinu i uživamo u zimskim radostima."
    ];

    showDialog(
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
                  maxWidth: 600,
                ),
                child: InteractiveViewer(
                  panEnabled: true,
                  child: MatchingGame(
                    months: months,
                    descriptions: descriptions,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MatchingGame extends StatefulWidget {
  final List<String> months;
  final List<String> descriptions;

  const MatchingGame({super.key, required this.months, required this.descriptions});

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  final Map<String, String> matchedPairs = {};
  final Set<String> usedDescriptions = {};
  bool showResults = false;
  String? selectedMonth;

  String? _correctMatch(String month) {
    switch (month) {
      case "Siječanj":
        return "Započinjemo novu godinu i uživamo u zimskim radostima.";
      case "Veljača":
        return "Oblačimo kostime i slavimo Maškare.";
      case "Ožujak":
        return "Najavljuju se sunčani dani i dolazi proljeće.";
    }
    return null;
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Spoji mjesec s opisom:", style: TextStyle(fontSize: 20)),
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
                            style: TextStyle(fontSize: 20),
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
                children: widget.descriptions.where((desc) => !usedDescriptions.contains(desc)).map((desc) {
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
                        child: Text(desc, style: TextStyle(fontSize: 18, color: Colors.white)),
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
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(desc, style: TextStyle(fontSize: 18)),
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
              onPressed: () {
                setState(() {
                  matchedPairs.clear();
                  usedDescriptions.clear();
                  showResults = false;
                  selectedMonth = null;
                });
              },
              child: Text("Igraj ponovo"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showResults = true;
                });
              },
              child: Text("Provjeri rezultat"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Zatvori"),
            ),
          ],
        )
      ],
    );
  }
}
