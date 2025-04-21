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


  @override
  void initState() {
    super.initState();

    generateSectorRadians();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800));

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
    spins = spins + 1;
  }

  _gameContent() {
    return Stack(
      children: [
        //_gameTitle(),
        _gameWheel(),
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
      child: Transform.translate(offset: Offset(0, -150),
        child: Container(
          padding: const EdgeInsets.only(top: 4.5, left: 1),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.5,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain, image: AssetImage("assets/images/wheel_belt.png")
            )
          ),
          child: InkWell(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: controller.value * angle,
                  child: Container (
                    margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.023),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/fortune_wheel-removebg-preview.png"))
                    )
                  )
                );
              }
            ),
            onTap: () {
              setState(() {
                if (!spinning) {
                  spin();
                  spinning = true;
                }
              });
            }
          )
        )
      )
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
    return (2 * math.pi * sectors.length) + sectorRadians[randomSectorIndex] + math.pi / sectors.length;
  }

  Widget _gameStats() {
  return Stack(
    children: [
      // Broj okretaja (left side)
      Transform.translate(
        offset: Offset(20, MediaQuery.of(context).size.height * 0.5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Broj okretaja",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$spins/10",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),

      /*// Tema (right side)
      Transform.translate(
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
      offset: Offset(-10, -510), // fine-tune vertically
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 200,
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
                textStyle: const TextStyle(fontSize: 22),
              ),
              child: const Text("Pokreni ponovo"),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 200,
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
                textStyle: const TextStyle(fontSize: 22),
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
