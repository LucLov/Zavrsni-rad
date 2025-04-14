import 'package:flutter/material.dart';
import 'checking_knowledge.dart';

void main() {
  runApp(const NavigatorApp());
}

class NavigatorApp extends StatelessWidget {
  const NavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/fall", // Set initial route
      routes: {
        "/fall" : (context) => const FallScreen(),
        //"/fallPractice" : (context) => const SettingsScreen(),
        "/checkingKnowledge" : (context) => const CheckingKnowledge(),
      },
    );
  }
}

class FallScreen extends StatefulWidget {
  const FallScreen({super.key});

  @override
  _FallScreenState createState() => _FallScreenState();
}

class _FallScreenState extends State<FallScreen> {
  bool isListopadSelected = false;
  bool isStudeniSelected = false;
  bool isProsinacSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          _buildFallPage(context),
        ],
      ),
    );
  }

  Widget _buildFallPage(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/6.png',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 100),
              Align(
                alignment: Alignment.topRight,
                child: _buildBox(
                    context,
                    "10. LISTOPAD",
                    "LISTOPAD",
                    "10.",
                    "31",
                    "Došlo je hladnije vrijeme, a lišće mijenja boje u crvene, narančaste i žute nijanse. Uživanje u specijalitetima od kestena i bundeva.",
                    24,
                    "Klikni za informacije o listopadu!",
                    isListopadSelected,
                    (bool isSelected) {
                      setState(() {
                        isListopadSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildBox(
                    context,
                    "11. STUDENI",
                    "STUDENI",
                    "11.",
                    "30",
                    "Jesen se bliži kraju - dani postaju kraći, a temperature sve niže.",
                    24,
                    "Klikni za informacije o studenom!",
                    isStudeniSelected,
                    (bool isSelected) {
                      setState(() {
                        isStudeniSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.centerRight,
                child: _buildBox(
                    context,
                    "12. PROSINAC",
                    "PROSINAC",
                    "12.",
                    "31",
                    "Krenuo je advent - vrijeme blagdana i darivanja. Odbrojavamo dane do Božića i Nove godine.\n Krajem prosinca kreće zima, a taj isti dan je i najdulji u godini.",
                    24,
                    "Klikni za informacije o prosincu!",
                    isProsinacSelected,
                    (bool isSelected) {
                      setState(() {
                        isProsinacSelected = isSelected;
                      });
                    }),
              ),
              const SizedBox(height: 70),
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
                    "Provježbaj znanje o jesenskim mjesecima!",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: FilledButton(
                  onPressed: () {
                      Navigator.of(context).pushNamed('/checkingKnowledge');
                    },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Color(0xFF497F03),
                    ),
                  ),
                  child: const Text(
                    "Ispitaj znanje o svim mjesecima!",
                    style: TextStyle(
                      fontSize: 24, // Set the font size
                      color: Colors.white, // Set the text color
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
                    color: Colors.transparent, // Blue border when selected
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
                    title: Text(title, textAlign: TextAlign.center,),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Redni broj u godini: $monthNumber", style: TextStyle(fontSize: 24)),
                        Text("Broj dana: $daysInMonth", style: TextStyle(fontSize: 24)),
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
    final months = ["listopad", "studeni", "prosinac"];
    final descriptions = [
      "Američke Maškare (Haloween)",
      "Kišno i oblačno vrijeme",
      "Božični mjesec"
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
      case "listopad":
        return "Američke Maškare (Haloween)";
      case "studeni":
        return "Kišno i oblačno vrijeme";
      case "prosinac":
        return "Božični mjesec";
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
