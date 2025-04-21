import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
      {"question": "S kojim mjesecom započinjemo novu godinu?", "correct": "Sa siječanjem.", "wrong": ["S prosincom.", "S travanjom."]},
      {"question": "Što se često događa zimi?", "correct": "Snježi.", "wrong": ["Cvjeta.", "Žanje se."]},
      {"question": "Koji mjesec je najkraći mjesec u godini?", "correct": "Veljača.", "wrong": ["Ožujak.", "Siječanj."]},
      {"question": "Koji mjesec je duži za jedan dan svake prijestupne (četvrte) godine?", "correct": "Veljača.", "wrong": ["Ožujak.", "Siječanj."]},
      {"question": "U kojem mjesecu obilježavamo Dan zaljubljenih (Valentinovo)?", "correct": "Veljača.", "wrong": ["Siječanj.", "Ožujak."]},
      {"question": "Što najčešće obilježavamo u veljači?", "correct": "Fašnik (Maškare).", "wrong": ["Božić.", "Uskrs."]},
      {"question": '''Koje biljke nazivamo "vjesnicima proljeća"?''', "correct": "Visibabe, jaglaci, ljubičice.", "wrong": ["Ruže, šafrani.", "Tulipani, božuri."]},
      {"question": "Koje se ptice selice vraćaju iz toplijih krajeva u proljeće?", "correct": "Lastavice, rode i grlice.", "wrong": ["Golubovi i vrane.", "galebovi i vrapci"]},
      {"question": "U kojem mjesecu se odvija prijelaz iz zime u proljeće?", "correct": "Ožujak.", "wrong": ["Siječanj.", "Travanj."]},
    ],
    'proljeće': [
      {"question": "Što se događa s danima tijekom proljeća?", "correct": "Dani postaju duži.", "wrong": ["Dani postaju kraći.", "Dani ostaju isti."]},
      {"question": "Koje životinje često povezujemo s proljećem i Uskrsom?", "correct": "Zec, pile.", "wrong": ["Jež, sova.", "Riba, hobotnica."]},
      {"question": "Što se često događa s drvećem u proljeće?", "correct": "puštaju pupoljke i listove", "wrong": ["opada im lišće", "postaju smeđa"]},
      {"question": "Koje je obilježje proljetne ravnodnevnice?", "correct": "Dan i noć traju približno jednako dugo.", "wrong": ["Dan traje duže od noći.", "Noć traje duže od dana."]},
      {"question": "Na prvi dan kojeg mjeseca obilježavamo Dan šale?", "correct": "Travanj.", "wrong": ["Svibanj.", "Lipanj."]},
      {"question": "Koje godišnje doba započinje u lipnju?", "correct": "Ljeto.", "wrong": ["Jesen.", "Proljeće."]},
      {"question": "Dan kada dan traje najduže, a noć najkraće događa se krajem kojeg mjeseca?", "correct": "Lipanj.", "wrong": ["Svibanj.", "Srpanj."]},
      {"question": "Koje voće često jedemo u proljeće?", "correct": "Jagode.", "wrong": ["Jabuke.", "Kruške."]},
      // Add more...
    ],
    'ljeto': [
      {"question": "Što ljudi često rade ljeti?", "correct": "Idu na ljetovanje.", "wrong": ["Kopaju krumpire.", "Siju pšenicu."]},
      {"question": "Koja dva susjedna mjeseca imaju isti broj dana?", "correct": "Srpanj i kolovoz.", "wrong": ["Siječanj i veljača.", "Kolovoz i rujan."]},
      {"question": "Koje poljoprivredne kulture uzgajamo u ljeto?", "correct": "Kukuruz, rajčicu i suncokret.", "wrong": ["Bundevu", "Kapi znoja"]},
      {"question": "Koje se voće jede ljeti kako bismo se osvježili?", "correct": "Lubenica.", "wrong": ["Jabuka.", "Banana."]},
      {"question": "Kako se zove pojava kada su dani jako vrući i bez kiše?", "correct": "Toplinski udar.", "wrong": ["Hladni val.", "Kipuće ljeto."]},
      {"question": "Što se često koristi za zaštitu od sunca ljeti?", "correct": "Kapa, svijetla odjeća i krema za sunce.", "wrong": ["Šal.", "Kabanica."]},
      {"question": "Koje godišnje doba započinje u rujnu?", "correct": "Jesen.", "wrong": ["Proljeće.", "Zima."]},
      {"question": "Kako se zove pojava kada zrak treperi zbog velikih vrućina?", "correct": "Vrela izmaglica (ljetna fatamorgana).", "wrong": ["Vjetar.", "Plima."]},
      {"question": "Koja pojava predstavlja opasnost za vrijeme velikih vrućina?", "correct": "Požari.", "wrong": ["Poplave.", "Obilne kiše."]},
      // Add more...
    ],
    'jesen': [
      {"question": "Što pada u jesen?", "correct": "Lišće", "wrong": ["Snijeg", "Kapi znoja"]},
      {"question": "Koja dva susjedna mjeseca (ne gledajući mjesece unutar jedne godine) imaju isti broj dana", "correct": "Prosinac i siječanj.", "Rujan i listopad.": ["Kolovoz i rujan.", "Kapi znoja"]},
      {"question": "Koji plodovi sazrijevaju u jesen?", "correct": "Jabuke, kruške i grožđe.", "wrong": ["Lubenice i dinje.", "Jagode i maline."]},
      {"question": "U koje boje listovi stabala mijenjaju svoje boje?", "correct": "U žutu, narančastu i smeđu.", "wrong": ["U zelenu.", "U plavu."]},
      {"question": "Što se događa s danima tijekom jeseni?", "correct": "Dani postaju kraći.", "wrong": ["Dani postaju duži.", "Dani ostaju isti."]},
      {"question": "Koje povrće sazrijeva u jesen?", "correct": "Krumpire, bundeve i mrkve.", "wrong": ["Krastavce.", "Tikvice."]},
      {"question": "Kako se zove jesenska pojava kada dan i noć traju jednako dugo?", "correct": "Jesenska ravnodnevnica.", "wrong": ["Ljetni solsticij.", "Zimski solsticij."]},
      {"question": "Koje godišnje doba započinje krajem prosinca?", "correct": "Zima.", "wrong": ["Proljeće.", "Jesen."]},
      {"question": "Koji blagdan obilježavamo krahem prosinca?", "correct": "Božić.", "wrong": ["Uskrs.", "Dan državnosti."]},


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
    return Scaffold (
      backgroundColor: Color(0xFFc4e2ff),
      body: _body(),
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


  _gameContent() {
    return Stack(
      children: [
        //_gameTitle(),
        _gameWheel(),
        if (currentQuestion != null) _quizUI(),
        _gameActions(),
        _gameStats(),
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
/*
  Widget _gameTitle() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 70),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: CupertinoColors.systemYellow,
            width: 2,
          ),
          gradient: const LinearGradient(colors: [
            Color(0xFF2D014C),
            Color(0xFFF8009E),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          )
        ),
        child: const Text(
          "Kolo sreće o mjesecima u godini",
          style: TextStyle(
            fontSize: 40,
            color: CupertinoColors.systemYellow,
          ))
      )
    );
  }*/

  Widget _gameWheel() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: Offset(0, -150),
          child: Container(
            padding: const EdgeInsets.only(top: 4.5, left: 1),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.5,
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
                      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.023),
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

        // 👇 This is your message below the wheel
        //const SizedBox(height: 20),
        Transform.translate(
          offset: Offset(0, -120),
          child: const Text(
          "Zavrti kolo sreće kako bi izvukao/la pitanje!",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        )
        
      ],
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
          SizedBox(
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
          ),
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

  Widget _quizUI() {
  return Center(
    child: Transform.translate(
      offset: Offset(0, 400),
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
            Text(
              currentQuestion!["question"],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...answerOptions.map((option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ElevatedButton(
                onPressed: () {
                  bool isCorrect = option == currentQuestion!["correct"];
                  _showAnswerFeedback(isCorrect);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 55), // 45
                ),
                child: Text(option, style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal)),
              ),
            )),
          ],
        ),
      ),
    ),
  );
}

  void _showAnswerFeedback(bool correct) {
  if (correct) correctAnswers++;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(correct ? "Točno!" : "Netočno!", 
          textAlign: TextAlign.center, 
          style: TextStyle(fontSize: 24)),
        content: Text(correct
            ? "Bravo! Točan odgovor."
            : "Oh ne! Krivi odgovor.", 
            style: TextStyle(fontSize: 24)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentQuestion = null;

                if (spins >= 10) {
                  _showResultPopup(); // 🎉 Show final result here!
                }
              });
            },
            child: const Text("Nastavi", style: TextStyle(fontSize: 24)),
          )
        ],
      );
    },
  );
}

  void _showResultPopup() {
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

      return AlertDialog(
        title: const Text("Kviz završen",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Točno si odgovorio/la na $correctAnswers od 10 pitanja.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(message,
              style: TextStyle(fontSize: 24)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close popup
              Navigator.of(context).pop(); // go back to main screen
            },
            child: const Text("Vrati se na početnu stranicu",
                    style: TextStyle(fontSize: 24)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close popup
              setState(() {
                _resetGameCompletely(); // restart game
              });
            },
            child: const Text("Igraj ponovno",
                    style: TextStyle(fontSize: 24)),
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




  Widget _body() {
  return Stack(
    children: [
      Positioned.fill(
        child: Image.asset(
          "assets/images/game_background_2.png", // Change this to your image path
          fit: BoxFit.cover,
        ),
      ),
      Container(
        height: double.infinity,
        width: double.infinity,
        child: _gameContent(),
      ),
    ],
  );
}

}
