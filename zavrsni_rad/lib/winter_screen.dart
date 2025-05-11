import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'spring_screen.dart';
import 'summer_screen.dart';
import 'fall_screen.dart';
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
    final settings = Provider.of<SettingsProvider>(context);
    final fontSize = settings.fontSize;
    final fontFamily = settings.fontFamily;

    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          _buildWinterPage(context, settings),
          SpringScreen(),
          SummerScreen(), 
          FallScreen(),
        ],
      ),
    );
  }

  Widget _buildWinterPage(BuildContext context, SettingsProvider settings) {
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
                    settings,
                    "1. SIJEČANJ",
                    "SIJEČANJ",
                    "1.",
                    "sijecanj_slika.png",
                    "31",
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
                    settings,
                    "2. VELJAČA",
                    "VELJAČA",
                    "2.",
                    "veljaca_slika.png",
                    "28, a svake četvrte godine 29",
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
                    settings,
                    "3. OŽUJAK",
                    "OŽUJAK",
                    "3.",
                    "ozujak_slika.png",
                    "31",
                    "Klikni za informacije o ožujku!",
                    isOzujakSelected,
                    (bool isSelected) {
                      setState(() {
                        isOzujakSelected = isSelected;
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
                    "Provježbaj znanje o zimskim mjesecima!",
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
            style: TextStyle(fontSize: settings.fontSize - 4, fontFamily: settings.fontFamily, color: Colors.black),
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
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left container
                            Container(
                              padding: EdgeInsets.all(12),
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
                                      fontSize: settings.fontSize - 4,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    monthNumber,
                                    style: TextStyle(
                                      fontFamily: settings.fontFamily,
                                      fontSize: settings.fontSize - 4,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      backgroundColor: Colors.transparent,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            // Right container
                            Container(
                              width: 200,
                              height: 200,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset('assets/images/$monthPicture'), // <-- replace with your image path
                            ),
                            Container(
                              padding: EdgeInsets.all(12),
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
                                      fontSize: settings.fontSize - 4,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    daysInMonth,
                                    style: TextStyle(
                                      fontFamily: settings.fontFamily,
                                      fontSize: settings.fontSize - 4,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      backgroundColor: Colors.transparent,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black),
                            children: _buildActivityText(title, settings),
                          ),
                        ),
                      ],
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
    if (title == "SIJEČANJ") {
      spans.add(TextSpan(text: "Sa siječnjom ", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: "započinjemo novu godinu", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: ". Često se prave novogodišnje odluke to jest planovi i želje za godinu koja dolazi. U siječnju se uziva u zadnjim blagdanskim danima i praznicima. Odlazi se na sankanje, grudanje i skijanje. Djeca se vraćaju u školu i nastavljaju učiti.", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
    }
    
    if (title == "VELJAČA") {
      spans.add(TextSpan(text: "Veljača je ", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: "najkraći mjesec u godini. Svaka četvrta godina u kojoj veljača ima 29 dana zove se prijestupna godina. ", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: "Zima još traje, ali dani polako počinju biti duži.\nU veljači se obilježavaju ", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: "Maškare (Fašnik, Poklade)", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: ". Djeca se maskiraju u svoje omiljene superjunake, princeze i razne druge likove te se održavaju povorke. \nTakođer, obilježava se i ", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: "Valentinovo", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: " - dan kada posebnu pažnju dodjeljujemo ljubavi prema prijateljima, obitelji, a i simpatijama.", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
    }
    if (title == "OŽUJAK") {
      spans.add(TextSpan(text: "Cvijeće raste, drveća pupaju, a ptice pjevaju. Ptice selice poput ", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: "lastavica, roda i grlica", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: " se vraćaju iz toplijih krajeva, a proljeće nagovještaju i vjesnici proljeća - ", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: "visibabe, jaglaci, ljubičice.\n", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));
      spans.add(TextSpan(text: "Krajem ožujka počinje proljeće, a baš tada dan i noć traju približno dugo - njega nazivamo ", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, color: Colors.black)));
      spans.add(TextSpan(text: "proljetni solsticij.", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold, color: Colors.black)));

    }
    //spans.add(TextSpan(text: activityText, style: TextStyle(fontSize: 24, color: Colors.black)));
    
    return spans;
  }
}


  void _showMatchingGameDialog(BuildContext context, SettingsProvider settings) {
    final months = ["siječanj", "veljača", "ožujak"];
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
                  maxWidth: 700,
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
      case "siječanj":
        return "Započinjemo novu godinu i uživamo u zimskim radostima.";
      case "veljača":
        return "Oblačimo kostime i slavimo Maškare.";
      case "ožujak":
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
                  return DragTarget<String>( // Drag Target to match months
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
                            style: TextStyle(fontSize: settings.fontSize - 4, fontFamily: settings.fontFamily)

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
                  return Draggable<String>( // Draggable for descriptions
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
              onPressed: () {
                setState(() {
                  matchedPairs.clear();
                  usedDescriptions.clear();
                  showResults = false;
                  selectedMonth = null;
                });
              },
              child: Text("Igraj ponovo", style: TextStyle(fontSize: settings.fontSize - 2, fontFamily: settings.fontFamily)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showResults = true;
                });
              },
              child: Text("Provjeri rezultat", style: TextStyle(fontSize: settings.fontSize - 2, fontFamily: settings.fontFamily)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Zatvori", style: TextStyle(fontSize: settings.fontSize - 2, fontFamily: settings.fontFamily)),
            ),
          ],
        ),
      ],
    );
  }
}
