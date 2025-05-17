import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni_rad/music_controller.dart';
import 'package:zavrsni_rad/settings_provider.dart';
import 'package:zavrsni_rad/settings_screen.dart';
import 'dart:math' as math;


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
  Map<String, List<Map<String, dynamic>>> questionPools = {
    'zima': [
      {
    "question": "S kojim mjesecom započinje nova godina?",
    "correct": "Sa siječnjem.",
    "wrong": ["S prosincem.", "S travnjem."]
  },
  {
    "question": "Što se često događa tijekom zime?",
    "correct": "Sniježi.",
    "wrong": ["Cvjeta.", "Žanje se."]
  },
  {
    "question": "Koji je najkraći mjesec u godini?",
    "correct": "Veljača.",
    "wrong": ["Ožujak.", "Siječanj."]
  },
  {
    "question": "Koji mjesec ima jedan dan više svake prijestupne (četvrte) godine?",
    "correct": "Veljača.",
    "wrong": ["Ožujak.", "Siječanj."]
  },
  {
    "question": "U kojem mjesecu obilježavamo Dan zaljubljenih (Valentinovo)?",
    "correct": "U veljači.",
    "wrong": ["U siječnju.", "U ožujku."]
  },
  {
    "question": "Što se najčešće obilježava u veljači?",
    "correct": "Fašnik (Maškare).",
    "wrong": ["Božić.", "Uskrs."]
  },
  {
    "question": "Koje biljke nazivamo 'vjesnicima proljeća'?",
    "correct": "Visibabe, jaglaci i ljubičice.",
    "wrong": ["Ruže, šafrani.", "Tulipani, božuri."]
  },
  {
    "question": "Koje ptice selice se vraćaju iz toplijih krajeva u proljeće?",
    "correct": "Lastavice, rode i grlice.",
    "wrong": ["Golubovi i vrane.", "Galebovi i vrapci."]
  },
  {
    "question": "U kojem mjesecu nastupa prijelaz iz zime u proljeće?",
    "correct": "U ožujku.",
    "wrong": ["U siječnju.", "U travnju."]
  }
    ],
    'proljeće': [
      {
    "question": "Što se događa s danima tijekom proljeća?",
    "correct": "Dani postaju duži.",
    "wrong": ["Dani postaju kraći.", "Dani ostaju isti."]
  },
  {
    "question": "Koje životinje često povezujemo s proljećem i Uskrsom?",
    "correct": "Zec i pile.",
    "wrong": ["Jež i sova.", "Riba i hobotnica."]
  },
  {
    "question": "Što se često događa s drvećem u proljeće?",
    "correct": "Pušta pupoljke i listove.",
    "wrong": ["Opada im lišće.", "Postaju smeđa."]
  },
  {
    "question": "Koja je osobitost proljetne ravnodnevnice?",
    "correct": "Dan i noć traju približno jednako dugo.",
    "wrong": ["Dan traje dulje od noći.", "Noć traje dulje od dana."]
  },
  {
    "question": "Na prvi dan kojeg mjeseca obilježavamo Dan šale?",
    "correct": "Travanj.",
    "wrong": ["Svibanj.", "Lipanj."]
  },
  {
    "question": "Koje godišnje doba započinje u lipnju?",
    "correct": "Ljeto.",
    "wrong": ["Jesen.", "Proljeće."]
  },
  {
    "question": "Dan kada dan traje najdulje, a noć najkraće, događa se krajem kojeg mjeseca?",
    "correct": "Lipnja.",
    "wrong": ["Svibnja.", "Srpnja."]
  },
  {
    "question": "Koje voće često jedemo u proljeće?",
    "correct": "Jagode.",
    "wrong": ["Jabuke.", "Kruške."]
  }],
    'ljeto': [
      {
    "question": "Što ljudi često rade ljeti?",
    "correct": "Idu na ljetovanje.",
    "wrong": ["Kopaju krumpire.", "Siju pšenicu."]
  },
  {
    "question": "Koja dva susjedna mjeseca imaju isti broj dana?",
    "correct": "Srpanj i kolovoz.",
    "wrong": ["Siječanj i veljača.", "Kolovoz i rujan."]
  },
  {
    "question": "Koje poljoprivredne kulture uzgajamo ljeti?",
    "correct": "Kukuruz, rajčicu i krastavce.",
    "wrong": ["Bundevu.", "Kapi znoja."]
  },
  {
    "question": "Koje se voće jede ljeti kako bismo se osvježili?",
    "correct": "Lubenica.",
    "wrong": ["Jabuka.", "Banana."]
  },
  {
    "question": "Kako se zove pojava kada su dani jako vrući i bez kiše?",
    "correct": "Suša.",
    "wrong": ["Hladni val.", "Kipuće ljeto."]
  },
  {
    "question": "Što se često koristi za zaštitu od sunca ljeti?",
    "correct": "Kapa, svijetla odjeća i krema za sunčanje.",
    "wrong": ["Šal.", "Kabanica."]
  },
  {
    "question": "Koje godišnje doba započinje u rujnu?",
    "correct": "Jesen.",
    "wrong": ["Proljeće.", "Zima."]
  },
  {
    "question": "Kako se zove pojava kada zrak treperi zbog velikih vrućina?",
    "correct": "Vrela izmaglica (ljetna fatamorgana).",
    "wrong": ["Vjetar.", "Plima."]
  },
  {
    "question": "Koja pojava predstavlja opasnost za vrijeme velikih vrućina?",
    "correct": "Požari.",
    "wrong": ["Poplave.", "Obilne kiše."]
  }],
    'jesen': [
      {
    "question": "Što pada u jesen?",
    "correct": "Lišće.",
    "wrong": ["Snijeg.", "Kapi znoja."]
  },
  {
    "question": "Koja dva susjedna mjeseca (ne gledajući mjesece unutar jedne godine) imaju isti broj dana?",
    "correct": "Prosinac i siječanj.",
    "wrong": ["Kolovoz i rujan.", "Rujan i listopad."]
  },
  {
    "question": "Koji plodovi sazrijevaju u jesen?",
    "correct": "Jabuke, kruške i grožđe.",
    "wrong": ["Lubenice i dinje.", "Jagode i maline."]
  },
  {
    "question": "U koje boje listovi mijenjaju svoju boju?",
    "correct": "U žutu, narančastu i smeđu.",
    "wrong": ["U zelenu.", "U plavu."]
  },
  {
    "question": "Što se događa s danima tijekom jeseni?",
    "correct": "Dani postaju kraći.",
    "wrong": ["Dani postaju duži.", "Dani ostaju isti."]
  },
  {
    "question": "Koje povrće sazrijeva u jesen?",
    "correct": "Krumpir, bundeva i mrkva.",
    "wrong": ["Krastavci.", "Tikvice."]
  },
  {
    "question": "Kako se zove jesenska pojava kada dan i noć traju jednako dugo?",
    "correct": "Jesenska ravnodnevnica.",
    "wrong": ["Ljetni solsticij.", "Zimski solsticij."]
  },
  {
    "question": "Koje godišnje doba započinje krajem prosinca?",
    "correct": "Zima.",
    "wrong": ["Proljeće.", "Jesen."]
  },
  {
    "question": "Koji blagdan obilježavamo krajem prosinca?",
    "correct": "Božić.",
    "wrong": ["Uskrs.", "Dan državnosti."]
  }
    ],
  };

  int correctAnswers = 0;

  // Track used questions per season
  Map<String, List<int>> usedQuestionIndexes = {
    'zima': [],
    'proljeće': [],
    'ljeto': [],
    'jesen': [],
  };

  // Store current question for display
  Map<String, dynamic>? currentQuestion;
  List<String> answerOptions = [];



  @override
  void initState() {
    super.initState();

    generateSectorRadians();

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
    earnedValue = sectors[sectors.length - (randomSectorIndex + 1)];
    spins++;

    String season = _getSeasonName(earnedValue);

    // Fetch unused question
    List<Map<String, dynamic>> pool = questionPools[season]!;
    List<int> used = usedQuestionIndexes[season]!;

    if (used.length >= pool.length) {
      // Reset used questions if all are shown
      used.clear();
    }

    int index;
    do {
      index = random.nextInt(pool.length);
    } while (used.contains(index));

    used.add(index);

    // Set current question
    currentQuestion = pool[index];
    answerOptions = [
      currentQuestion!["correct"],
      ...currentQuestion!["wrong"]
    ]..shuffle(); // Shuffle options

    // Force UI to rebuild to show question
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
              "Provjeri svoje znanje u 12 pitanja.\nZavrti kolo sreće kako bi izvukao/la pitanje!",
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
              child: Text(spinning ? "Vrti se..." : "Zavrti", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
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
      return 'zima';
    case 2:
      return 'proljeće';
    case 3:
      return 'ljeto';
    case 4:
      return 'jesen';
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
            text: "Izvukao/la si pitanje iz godišnjeg doba: \n",
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
      '$spins. ${currentQuestion!["question"]}',
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
          title: Text(correct ? "Točno!" : "Netočno!", 
            textAlign: TextAlign.center, 
            style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                correct ? "Bravo! Točan odgovor." : "Oh ne! Krivi odgovor.", 
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
              child: Text("Nastavi", style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
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
      if (correctAnswers == 10) {
        message = "Savršeno! Sve točno!";
      } else if (correctAnswers >= 7) {
        message = "Odlično! Znaš puno o godišnjim dobima!";
      } else if (correctAnswers >= 4) {
        message = "Dobro je! Ali može i bolje.";
      } else {
        message = "Ne brini, bit će bolje sljedeći put!";
      }

      if (settings.quizSound) {
        MusicController().playFeedbackSound('audio/game_over_success.mp3');
      }
      
      return AlertDialog(
        title: Text("Kviz završen",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Rezultat: $correctAnswers/12",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
            const SizedBox(height: 10),
            Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/'); // go back to main screen
            },
            child: Text("Vrati se na početnu stranicu",
                    style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close popup
              setState(() {
                _resetGameCompletely(); // restart game
              });
            },
            child: Text("Igraj ponovno",
                    style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily,)),
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
          "assets/images/game_background.png", // Change this to your image path
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
