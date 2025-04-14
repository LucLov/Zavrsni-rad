import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    home: SummerScreen(),
    debugShowCheckedModeBanner: false,
  ));
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
    return Scaffold(
      body: PageView(
        children: [
          _buildSummerPage(context),
        ],
      ),
    );
  }

  Widget _buildSummerPage(BuildContext context) {
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
                    "1. SRPANJ",
                    "SRPANJ",
                    "7.",
                    "31",
                    "Ljetni praznici su u punom jeku, a često se baš srpanj i kolovoz smatraju najtoplijim mjesecima u godini.",
                    24,
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
                    "8. KOLOVOZ",
                    "KOLOVOZ",
                    "8.",
                    "31",
                    "Vrijeme je žetve, a i početka berbe nekih voćnih kultura. \nŠto se tiče obale i otoka, sve vrvi od turista.",
                    24,
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
                    "9. RUJAN",
                    "RUJAN",
                    "9.",
                    "30",
                    "Jesen je na vidiku - dani su još uvijek topli, a noći postaju svježije. Đaci su ponovno krenuli u školske klupe.",
                    24,
                    "Klikni za informacije o rujnu!",
                    isRujanSelected,
                    (bool isSelected) {
                      setState(() {
                        isRujanSelected = isSelected;
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
                    "Provježbaj znanje o ljetnim mjesecima!",
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
    final months = ["srpanj", "kolovoz", "rujan"];
    final descriptions = [
      "Ljetne praznike provodimo opuštajući se.",
      "Vrijeme je žetve za razne poljoprivredne kulture.",
      "Đaci kreću u školske klupe."
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
      case "srpanj":
        return "Ljetne praznike provodimo opuštajući se.";
      case "kolovoz":
        return "Vrijeme je žetve za razne poljoprivredne kulture.";
      case "rujan":
        return "Đaci kreću u školske klupe.";
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
