import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni_rad/music_controller.dart';
import 'package:zavrsni_rad/settings_provider.dart';
import 'package:zavrsni_rad/settings_screen.dart';
import 'dart:math' as math;
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/checkingKnowledge", // Set initial route
      routes: {
        "/settings" : (context) => const SettingsScreen(),
        "/checkingKnowledge" : (context) => const CheckingKnowledge(),
      },
    );
  }
}

class CheckingKnowledge extends StatefulWidget {
  const CheckingKnowledge({super.key});

  @override
  State<CheckingKnowledge> createState() => _CheckingKnowledgeState();
}

class _CheckingKnowledgeState extends State<CheckingKnowledge> with SingleTickerProviderStateMixin {

  List<double> sectors = [1, 2, 3, 4];
  int randomSectorIndex = -1;
  List<double> sectorRadians = [];
  double angle = 0;

  bool spinning = false;
  double earnedValue = 0;
  int spins = 0;

  math.Random random = math.Random();

  late AnimationController controller;
  late Animation<double> animation;

    // Each season gets its own question list
  Map<String, List<Map<String, dynamic>>> getQuestionPools(BuildContext context) {
  return {
    AppLocalizations.of(context)!.winter: [
      {
        "question": AppLocalizations.of(context)!.winter_question_1,
        "correct": AppLocalizations.of(context)!.winter_correct_1,
        "wrong": [
          AppLocalizations.of(context)!.winter_wrong_1_1,
          AppLocalizations.of(context)!.winter_wrong_1_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.winter_question_2,
        "correct": AppLocalizations.of(context)!.winter_correct_2,
        "wrong": [
          AppLocalizations.of(context)!.winter_wrong_2_1,
          AppLocalizations.of(context)!.winter_wrong_2_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.winter_question_3,
        "correct": AppLocalizations.of(context)!.winter_correct_3,
        "wrong": [
          AppLocalizations.of(context)!.winter_wrong_3_1,
          AppLocalizations.of(context)!.winter_wrong_3_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.winter_question_4,
        "correct": AppLocalizations.of(context)!.winter_correct_4,
        "wrong": [
          AppLocalizations.of(context)!.winter_wrong_4_1,
          AppLocalizations.of(context)!.winter_wrong_4_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.winter_question_5,
        "correct": AppLocalizations.of(context)!.winter_correct_5,
        "wrong": [
          AppLocalizations.of(context)!.winter_wrong_5_1,
          AppLocalizations.of(context)!.winter_wrong_5_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.winter_question_6,
        "correct": AppLocalizations.of(context)!.winter_correct_6,
        "wrong": [
          AppLocalizations.of(context)!.winter_wrong_6_1,
          AppLocalizations.of(context)!.winter_wrong_6_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.winter_question_7,
        "correct": AppLocalizations.of(context)!.winter_correct_7,
        "wrong": [
          AppLocalizations.of(context)!.winter_wrong_7_1,
          AppLocalizations.of(context)!.winter_wrong_7_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.winter_question_8,
        "correct": AppLocalizations.of(context)!.winter_correct_8,
        "wrong": [
          AppLocalizations.of(context)!.winter_wrong_8_1,
          AppLocalizations.of(context)!.winter_wrong_8_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.winter_question_9,
        "correct": AppLocalizations.of(context)!.winter_correct_9,
        "wrong": [
          AppLocalizations.of(context)!.winter_wrong_9_1,
          AppLocalizations.of(context)!.winter_wrong_9_2,
        ],
      },
    ],
    AppLocalizations.of(context)!.spring: [
      {
        "question": AppLocalizations.of(context)!.spring_question_1,
        "correct": AppLocalizations.of(context)!.spring_correct_1,
        "wrong": [
          AppLocalizations.of(context)!.spring_wrong_1_1,
          AppLocalizations.of(context)!.spring_wrong_1_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.spring_question_2,
        "correct": AppLocalizations.of(context)!.spring_correct_2,
        "wrong": [
          AppLocalizations.of(context)!.spring_wrong_2_1,
          AppLocalizations.of(context)!.spring_wrong_2_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.spring_question_3,
        "correct": AppLocalizations.of(context)!.spring_correct_3,
        "wrong": [
          AppLocalizations.of(context)!.spring_wrong_3_1,
          AppLocalizations.of(context)!.spring_wrong_3_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.spring_question_4,
        "correct": AppLocalizations.of(context)!.spring_correct_4,
        "wrong": [
          AppLocalizations.of(context)!.spring_wrong_4_1,
          AppLocalizations.of(context)!.spring_wrong_4_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.spring_question_5,
        "correct": AppLocalizations.of(context)!.spring_correct_5,
        "wrong": [
          AppLocalizations.of(context)!.spring_wrong_5_1,
          AppLocalizations.of(context)!.spring_wrong_5_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.spring_question_6,
        "correct": AppLocalizations.of(context)!.spring_correct_6,
        "wrong": [
          AppLocalizations.of(context)!.spring_wrong_6_1,
          AppLocalizations.of(context)!.spring_wrong_6_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.spring_question_7,
        "correct": AppLocalizations.of(context)!.spring_correct_7,
        "wrong": [
          AppLocalizations.of(context)!.spring_wrong_7_1,
          AppLocalizations.of(context)!.spring_wrong_7_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.spring_question_8,
        "correct": AppLocalizations.of(context)!.spring_correct_8,
        "wrong": [
          AppLocalizations.of(context)!.spring_wrong_8_1,
          AppLocalizations.of(context)!.spring_wrong_8_2,
        ],
      },
    ],
    AppLocalizations.of(context)!.summer: [
      {
        "question": AppLocalizations.of(context)!.summer_question_1,
        "correct": AppLocalizations.of(context)!.summer_correct_1,
        "wrong": [
          AppLocalizations.of(context)!.summer_wrong_1_1,
          AppLocalizations.of(context)!.summer_wrong_1_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.summer_question_2,
        "correct": AppLocalizations.of(context)!.summer_correct_2,
        "wrong": [
          AppLocalizations.of(context)!.summer_wrong_2_1,
          AppLocalizations.of(context)!.summer_wrong_2_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.summer_question_3,
        "correct": AppLocalizations.of(context)!.summer_correct_3,
        "wrong": [
          AppLocalizations.of(context)!.summer_wrong_3_1,
          AppLocalizations.of(context)!.summer_wrong_3_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.summer_question_4,
        "correct": AppLocalizations.of(context)!.summer_correct_4,
        "wrong": [
          AppLocalizations.of(context)!.summer_wrong_4_1,
          AppLocalizations.of(context)!.summer_wrong_4_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.summer_question_5,
        "correct": AppLocalizations.of(context)!.summer_correct_5,
        "wrong": [
          AppLocalizations.of(context)!.summer_wrong_5_1,
          AppLocalizations.of(context)!.summer_wrong_5_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.summer_question_6,
        "correct": AppLocalizations.of(context)!.summer_correct_6,
        "wrong": [
          AppLocalizations.of(context)!.summer_wrong_6_1,
          AppLocalizations.of(context)!.summer_wrong_6_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.summer_question_7,
        "correct": AppLocalizations.of(context)!.summer_correct_7,
        "wrong": [
          AppLocalizations.of(context)!.summer_wrong_7_1,
          AppLocalizations.of(context)!.summer_wrong_7_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.summer_question_8,
        "correct": AppLocalizations.of(context)!.summer_correct_8,
        "wrong": [
          AppLocalizations.of(context)!.summer_wrong_8_1,
          AppLocalizations.of(context)!.summer_wrong_8_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.summer_question_9,
        "correct": AppLocalizations.of(context)!.summer_correct_9,
        "wrong": [
          AppLocalizations.of(context)!.summer_wrong_9_1,
          AppLocalizations.of(context)!.summer_wrong_9_2,
        ],
      },
    ],
    AppLocalizations.of(context)!.fall: [
      {
        "question": AppLocalizations.of(context)!.fall_question_1,
        "correct": AppLocalizations.of(context)!.fall_correct_1,
        "wrong": [
          AppLocalizations.of(context)!.fall_wrong_1_1,
          AppLocalizations.of(context)!.fall_wrong_1_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.fall_question_2,
        "correct": AppLocalizations.of(context)!.fall_correct_2,
        "wrong": [
          AppLocalizations.of(context)!.fall_wrong_2_1,
          AppLocalizations.of(context)!.fall_wrong_2_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.fall_question_3,
        "correct": AppLocalizations.of(context)!.fall_correct_3,
        "wrong": [
          AppLocalizations.of(context)!.fall_wrong_3_1,
          AppLocalizations.of(context)!.fall_wrong_3_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.fall_question_4,
        "correct": AppLocalizations.of(context)!.fall_correct_4,
        "wrong": [
          AppLocalizations.of(context)!.fall_wrong_4_1,
          AppLocalizations.of(context)!.fall_wrong_4_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.fall_question_5,
        "correct": AppLocalizations.of(context)!.fall_correct_5,
        "wrong": [
          AppLocalizations.of(context)!.fall_wrong_5_1,
          AppLocalizations.of(context)!.fall_wrong_5_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.fall_question_6,
        "correct": AppLocalizations.of(context)!.fall_correct_6,
        "wrong": [
          AppLocalizations.of(context)!.fall_wrong_6_1,
          AppLocalizations.of(context)!.fall_wrong_6_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.fall_question_7,
        "correct": AppLocalizations.of(context)!.fall_correct_7,
        "wrong": [
          AppLocalizations.of(context)!.fall_wrong_7_1,
          AppLocalizations.of(context)!.fall_wrong_7_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.fall_question_8,
        "correct": AppLocalizations.of(context)!.fall_correct_8,
        "wrong": [
          AppLocalizations.of(context)!.fall_wrong_8_1,
          AppLocalizations.of(context)!.fall_wrong_8_2,
        ],
      },
      {
        "question": AppLocalizations.of(context)!.fall_question_9,
        "correct": AppLocalizations.of(context)!.fall_correct_9,
        "wrong": [
          AppLocalizations.of(context)!.fall_wrong_9_1,
          AppLocalizations.of(context)!.fall_wrong_9_2,
        ],
      },
    ],
  };
}

  int correctAnswers = 0;
  late Map<String, List<int>> usedQuestionIndexes;

  // Track used questions per season
  Map<String, List<int>> getUsedQuestionIndexes(BuildContext context) {
  if (usedQuestionIndexes == null) {
    usedQuestionIndexes = {
      AppLocalizations.of(context)!.winter: [],
      AppLocalizations.of(context)!.spring: [],
      AppLocalizations.of(context)!.summer: [],
      AppLocalizations.of(context)!.fall: [],
    };
  }
  return usedQuestionIndexes!;
}


  // Store current question for display
  Map<String, dynamic>? currentQuestion;
  List<String> answerOptions = [];


  @override
  void initState() {
    super.initState();
    generateSectorRadians();

    /*usedQuestionIndexes ??= {
      AppLocalizations.of(context)!.winter: [],
      AppLocalizations.of(context)!.spring: [],
      AppLocalizations.of(context)!.summer: [],
      AppLocalizations.of(context)!.fall: [],
    };*/


    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000));

    Tween<double> tween = Tween<double>(begin: 0, end: 1);

    CurvedAnimation curve = CurvedAnimation(
      parent: controller, 
      curve: Curves.decelerate,);

    animation = tween.animate(curve);

    controller.addListener(() {
      if (controller.isCompleted) {
        setState(() {
          recordStats();
          spinning = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usedQuestionIndexes = {
      AppLocalizations.of(context)!.winter: [],
      AppLocalizations.of(context)!.spring: [],
      AppLocalizations.of(context)!.summer: [],
      AppLocalizations.of(context)!.fall: [],
    };
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold (
      backgroundColor: Color(0xFFc4e2ff),
      body: _body(settings),
    );
  }
  
  void generateSectorRadians() {
    double sectorRadian = 2 * math.pi / sectors.length;

    for (int i = 0; i < sectors.length; i++) {
      sectorRadians.add((i + 1) * sectorRadian);
    }
  }
  
  void recordStats() {
    // Validate randomSectorIndex to avoid errors
    if (randomSectorIndex < 0 || randomSectorIndex >= sectors.length) {
      // Handle invalid index (fallback to first sector)
      earnedValue = sectors[0];
    } else {
      earnedValue = sectors[randomSectorIndex];
    }

    spins++;

    String season = _getSeasonName(earnedValue);
    final questionPools = getQuestionPools(context);
    List<Map<String, dynamic>> pool = questionPools[season]!;

    List<int> used = usedQuestionIndexes[season]!;

    if (used.length >= pool.length) {
      // Reset used questions if all have been shown
      used.clear();
    }

    int index;
    do {
      index = random.nextInt(pool.length);
    } while (used.contains(index));

    used.add(index);

    currentQuestion = pool[index];
    answerOptions = [
      currentQuestion!["correct"],
      ...currentQuestion!["wrong"]
    ]..shuffle();

    setState(() {});
  }



  _gameContent(SettingsProvider settings) {
    return Stack(
      children: [
        //_gameTitle(),
        _gameWheel(settings),
        if (currentQuestion != null) ...[
        // 👇 Modal barrier blocks interaction below
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withOpacity(0.5),
        ),
        Center(child: _quizUI(settings)), // 👈 Display quiz in center above barrier
      ],
        //_gameActions(),
        //_gameStats(),
        _backButton()  // <-- Add the back button here
      ]
    );
  }

  Widget _backButton() {
    return Positioned(
      top: 40, // Adjust the top position as needed
      left: 10, // Adjust the left position to place it where you want
      child: IconButton(
        icon: Icon(
          Icons.arrow_back, // Back arrow icon
          color: Colors.white, // You can change this color
          size: 30, // You can adjust the size
        ),
        onPressed: () {
          Navigator.pop(context); // This will pop the current screen and go back
        },
      ),
    );
  }

  Widget _gameWheel(SettingsProvider settings) {
  return Padding(
    padding: settings.fontSize < 28 ? EdgeInsets.only(top: 150) : EdgeInsets.only(top: 205), // 👈 Shift down here
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: Offset(0, 0),
            child: Container(
              padding: const EdgeInsets.only(top: 8, left: 1),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.85,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage("assets/images/wheel_belt.png"),
                ),
              ),
              child: InkWell(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: controller.value * angle,
                      child: Container(
                        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.031),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/images/fortune_wheel-removebg-preview.png"),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                onTap: () {
                  setState(() {
                    if (!spinning) {
                      spin();
                      spinning = true;
                    }
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Transform.translate(
            offset: Offset(0, 0),
            child: Text(
              AppLocalizations.of(context)!.testInstructions,
              style: TextStyle(
                fontSize: settings.fontSize,
                fontFamily: settings.fontFamily,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: spinning
                  ? null
                  : () {
                      setState(() {
                        spin();
                        spinning = true;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: Text(spinning ? AppLocalizations.of(context)!.spinning : AppLocalizations.of(context)!.spin, style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
            ),
          ),
        ],
      ),
    ),
  );
}


  
  void spin() {
    randomSectorIndex = random.nextInt(sectors.length);
    double randomRadian = generateRadianToSpinTo();
    controller.reset();
    angle = randomRadian;
    controller.forward();
  }

  double generateRadianToSpinTo() {
    //return (2 * math.pi * sectors.length) + sectorRadians[randomSectorIndex];
    final random = math.Random();

    // Angle per section in radians
    double anglePerSection = (2 * math.pi) / sectors.length;

    // Random offset within a sector (between 0 and 1), converted to radians
    double randomOffset = random.nextDouble() * anglePerSection;

    // Compute total spin to land somewhere inside the selected sector
    double totalSpin = (randomSectorIndex * anglePerSection) + randomOffset;

    // Add multiple full spins (e.g. 3 full turns = 3 * 2π)
    double fullSpins = 3 * 2 * math.pi;

    return fullSpins + totalSpin;
  }

  Widget _gameStats() {
  return Stack(
    children: [
      // Broj okretaja (left side)
      Transform.translate(
        offset: Offset(25, MediaQuery.of(context).size.height * 0.6),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Broj okretaja:",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$spins/10",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),

      // Tema (right side)
      /*Transform.translate(
        offset: Offset(0, MediaQuery.of(context).size.height * 0.54),
        child: Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Tema",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _getSeasonName(earnedValue),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),*/
    ],
  );
}

/*
  Column _titleColumn(String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.yellowAccent),))
      ],);
  }

  Column _valueColumn(var val) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            _getSeasonName(val),
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.yellowAccent),))
      ],);
  }
*/
  String _getSeasonName(var val) {
    switch (val) {
    case 1:
      return AppLocalizations.of(context)!.winter;
    case 2:
      return AppLocalizations.of(context)!.spring;
    case 3:
      return AppLocalizations.of(context)!.summer;
    case 4:
      return AppLocalizations.of(context)!.fall;
    default:
      return ''; // fallback
    }
  }

  Widget _gameActions() {
  return Align(
    alignment: Alignment.bottomRight,
    child: Transform.translate(
      offset: Offset(-25, -390), // fine-tune vertically
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /*SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: spinning
                  ? null
                  : () {
                      setState(() {
                        resetGame();
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text("Pokreni ponovno"),
            ),
          ),*/
          const SizedBox(height: 12),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: spinning
                  ? null
                  : () {
                      setState(() {
                        spin();
                        spinning = true;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: Text(spinning ? "Vrti se..." : "Zavrti"),
            ),
          ),
        ],
      ),
    ),
  );
}
  void resetGame() {
    spinning = false;
    angle = 0;
    earnedValue = 0;
    spins = 0;
    controller.reset();
  }

  Widget _quizUI(SettingsProvider settings) {
  return Center(
    child: Transform.translate(
      offset: Offset(0, 0),
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    RichText(
      textAlign: TextAlign.center,  // This will center the text within the RichText widget
      text: TextSpan(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
        children: [
          // First part of the text (first line)
          TextSpan(
            text: AppLocalizations.of(context)!.theme,
            style: TextStyle(
              fontSize: settings.fontSize,
              fontFamily: settings.fontFamily,
            ),
          ),
          // Second part of the text (second line)
          TextSpan(
            text: _getSeasonName(earnedValue),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: settings.fontSize,
              fontFamily: settings.fontFamily,
            ),
          ),
        ],
      ),
    ),
    SizedBox(height: 10),
    Text(
      '$spins) ${currentQuestion!["question"]}',
      style: TextStyle(
        fontSize: settings.fontSize,
        fontFamily: settings.fontFamily,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
    const SizedBox(height: 30),
    ...(answerOptions ?? []).map((option) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {
          bool isCorrect = option == currentQuestion!["correct"];
          _showAnswerFeedback(isCorrect, settings);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.black,
          minimumSize: Size(double.infinity, 55), // 45
        ),
        child: Text(
          option,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: settings.fontSize,
            fontFamily: settings.fontFamily,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    )),
  ],
),

      ),
    ),
  );
}

  Future<void> _showAnswerFeedback(bool correct, SettingsProvider settings) async {
    if (correct) correctAnswers++;

    if (settings.quizSound) {
      MusicController().playFeedbackSound(correct ? 'audio/right_feedback.mp3' : 'audio/fail_feedback.mp3');
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(correct ? AppLocalizations.of(context)!.correct : AppLocalizations.of(context)!.incorrect, 
            textAlign: TextAlign.center, 
            style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                correct ? AppLocalizations.of(context)!.correct_more : AppLocalizations.of(context)!.incorrect_more, 
                style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
              SizedBox(
                height: 10
              ),
              Icon(
                correct ? Icons.check_circle : Icons.cancel,
                color: correct ? Colors.green : Colors.red,
                size: 60, 
              )
            ],),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentQuestion = null;
                  spinning = false;
                  if (spins >= 12) {
                    _showResultPopup(settings); // 🎉 Show final result here!
                  }
                });
              },
              child: Text(AppLocalizations.of(context)!.continueWord, style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
            )
          ],
        );
      },
    );
}

  void _showResultPopup(SettingsProvider settings) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      String message;
      if (correctAnswers == 12) {
        message = AppLocalizations.of(context)!.message1;
      } else if (correctAnswers >= 9) {
        message = AppLocalizations.of(context)!.message2;
      } else if (correctAnswers >= 6) {
        message = AppLocalizations.of(context)!.message3;
      } else {
        message = AppLocalizations.of(context)!.message4;
      }

      if (settings.quizSound) {
        MusicController().playFeedbackSound('audio/game_over_success.mp3');
      }
      
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.quizCompleted,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${AppLocalizations.of(context)!.result}: $correctAnswers/12",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
            const SizedBox(height: 10),
            Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/');
                  },
                  child: Text(
                    AppLocalizations.of(context)!.goToHome,
                    style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _resetGameCompletely();
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.playAgain,
                    style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

  void _resetGameCompletely() {
  spinning = false;
  angle = 0;
  earnedValue = 0;
  spins = 0;
  correctAnswers = 0;
  currentQuestion = null;

  // Reset used question indexes
  //final usedQuestionIndexes = getUsedQuestionIndexes(context);
  for (var season in usedQuestionIndexes.keys) {
    usedQuestionIndexes[season] = [];
  }

  controller.reset();
}




  Widget _body(SettingsProvider settings) {
  return Stack(
    children: [
      Positioned.fill(
        child: Image.asset(
          AppLocalizations.of(context)!.gameBg, // Change this to your image path
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
            top: 30, 
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
      Container(
        height: double.infinity,
        width: double.infinity,
        child: _gameContent(settings),
      ),
    ],
  );
}

}
