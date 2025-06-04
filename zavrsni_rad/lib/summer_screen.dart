import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mjesec_po_mjesec/music_controller.dart';
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
            AppLocalizations.of(context)!.summerBg,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Icon(Icons.arrow_back, size: 40, color: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamed('/settings'),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                          backgroundColor: Colors.grey[800],
                        ),
                        child: const Icon(Icons.settings, size: 40, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.topRight,
                child: _buildBox(
                    context,
                    settings,
                    AppLocalizations.of(context)!.julButtonText,
                    AppLocalizations.of(context)!.julTitle,
                    AppLocalizations.of(context)!.julMonthNumber,
                    "srpanj_slika.png",
                    "31",
                    AppLocalizations.of(context)!.julInstruction,
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
                    AppLocalizations.of(context)!.augButtonText,
                    AppLocalizations.of(context)!.augTitle,
                    AppLocalizations.of(context)!.augMonthNumber,
                    "kolovoz_slika.png",
                    "31",
                    AppLocalizations.of(context)!.augInstruction,
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
                    AppLocalizations.of(context)!.sepButtonText,
                    AppLocalizations.of(context)!.sepTitle,
                    AppLocalizations.of(context)!.sepMonthNumber,
                    "rujan_slika.png",
                    "30",
                    AppLocalizations.of(context)!.sepInstruction,
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
                    AppLocalizations.of(context)!.summer_check,
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
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 115, 175, 227).withOpacity(0.7),
              borderRadius: BorderRadius.circular(10), // Adjust radius as needed
            ),
            padding: EdgeInsets.symmetric(horizontal: 4),// Optional: adds padding inside
            child: Text(
              instructionText,
              style: TextStyle(
                fontSize: settings.fontSize < 29
                    ? settings.fontSize - 4
                    : settings.fontSize - 10,
                fontFamily: settings.fontFamily,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
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
                                        AppLocalizations.of(context)!.ordinalNumber,
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
                                        AppLocalizations.of(context)!.numberOfDays,
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
                        child: Text(AppLocalizations.of(context)!.closeButton, style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily)),
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
    
    if (title == "SRPANJ" || title == "JULY") {
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.jul1,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.jul2,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.jul3,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.jul4,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.jul5,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.jul6,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.jul7,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.jul8,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.jul9,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.jul10,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: "!",
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
}

if (title == "KOLOVOZ" || title == "AUGUST") {
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug1,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug2,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug3,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug4,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug5,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug6,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug7,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug8,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug9,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug10,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.aug11,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
}

if (title == "RUJAN" || title == "SEPTEMBER") {
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.sep1,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.sep2,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.sep3,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.sep4,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.sep5,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, color: Colors.black),
  ));
  spans.add(TextSpan(
    text: AppLocalizations.of(context)!.sep6,
    style: TextStyle(fontFamily: settings.fontFamily, fontSize: settings.fontSize, fontWeight: FontWeight.bold, color: Colors.black),
  ));
}

    return spans;
  }
}
  void _showMatchingGameDialog(BuildContext context, SettingsProvider settings) {
    final months = [AppLocalizations.of(context)!.gameJulName, AppLocalizations.of(context)!.gameAugName, AppLocalizations.of(context)!.gameSepName];
    final correctDescriptionsMap = {
      AppLocalizations.of(context)!.gameJulName: AppLocalizations.of(context)!.gameJulNum,
      AppLocalizations.of(context)!.gameAugName: AppLocalizations.of(context)!.gameAugNum,
      AppLocalizations.of(context)!.gameSepName: AppLocalizations.of(context)!.gameSepNum,
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
          title: Text(AppLocalizations.of(context)!.gameInstructionTitle, textAlign: TextAlign.center, style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Text.rich(
              buildInstructionsTextSpan(settings, context),
            ),
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

TextSpan buildInstructionsTextSpan(SettingsProvider settings, BuildContext context) {
  return TextSpan(children: [
    TextSpan(
      text: AppLocalizations.of(context)!.gameInstructions1,
      style: TextStyle(
        fontSize: settings.fontSize,
        fontFamily: settings.fontFamily,
        color: Colors.black,
      ),
    ),
    TextSpan(
      text: AppLocalizations.of(context)!.gameInstructions2,
      style: TextStyle(
        fontSize: settings.fontSize,
        fontFamily: settings.fontFamily,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    TextSpan(
      text: AppLocalizations.of(context)!.gameInstructions3,
      style: TextStyle(
        fontSize: settings.fontSize,
        fontFamily: settings.fontFamily,
        color: Colors.black,
      ),
    ),
    TextSpan(
      text: AppLocalizations.of(context)!.gameInstructions4,
      style: TextStyle(
        fontSize: settings.fontSize,
        fontFamily: settings.fontFamily,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    TextSpan(
      text: AppLocalizations.of(context)!.gameInstructions5,
      style: TextStyle(
        fontSize: settings.fontSize,
        fontFamily: settings.fontFamily,
        color: Colors.black,
      ),
    ),
    TextSpan(
      text: AppLocalizations.of(context)!.gameInstructions6,
      style: TextStyle(
        fontSize: settings.fontSize,
        fontFamily: settings.fontFamily,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    TextSpan(
      text: AppLocalizations.of(context)!.gameInstructions7,
      style: TextStyle(
        fontSize: settings.fontSize,
        fontFamily: settings.fontFamily,
        color: Colors.black,
      ),
    ),
    TextSpan(
      text: AppLocalizations.of(context)!.gameInstructions8,
      style: TextStyle(
        fontSize: settings.fontSize,
        fontFamily: settings.fontFamily,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  ]);
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
    final localizations = AppLocalizations.of(context)!;

    if (month == localizations.gameJulName) {
      return localizations.gameJulNum;
    } else if (month == localizations.gameAugName) {
      return localizations.gameAugNum;
    } else if (month == localizations.gameSepName) {
      return localizations.gameSepNum;
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
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
              backgroundColor: Colors.blueAccent,
            ),
            child: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        Text(AppLocalizations.of(context)!.smallInstruction, textAlign: TextAlign.center, style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily, fontWeight: FontWeight.w500)),
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
              child: Text(AppLocalizations.of(context)!.playAgain, style: TextStyle(fontSize: settings.fontSize - 6, fontFamily: settings.fontFamily)),
            ),
            ElevatedButton(
              onPressed: matchedPairs.length == widget.months.length ?() {
                setState(() {
                  showResults = true;
                });

                if (settings.quizSound) {
                  final allCorrect = widget.months.every((month) {
                    final correct = widget.correctDescriptionsMap[month];
                    final matched = matchedPairs[month];
                    return matched == correct;
                  });

                  final soundPath = allCorrect
                      ? 'audio/right_feedback.mp3'
                      : 'audio/fail_feedback.mp3';

                  MusicController().playFeedbackSound(soundPath);
                }
                
                // Pokreni timer koji zatvara dijalog nakon 6 sekundi
                _autoCloseTimer?.cancel(); // Ako već postoji, otkaži ga
                _autoCloseTimer = Timer(const Duration(seconds: 3), () {
                  if (mounted && Navigator.canPop(context)) {
                    Navigator.of(context).pop(); // Zatvori popup
                  }
                });
              } : null,
              child: Text(AppLocalizations.of(context)!.checkResults, style: TextStyle(fontSize: settings.fontSize - 6, fontFamily: settings.fontFamily)),
            ),
          ],
        )
      ],
    );
  }
}
