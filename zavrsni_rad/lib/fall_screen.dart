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

class FallScreen extends StatelessWidget {
  const FallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          //_buildWinterPage(context),
          _buildFallPage(context), // Add another page if you want to swipe to it
        ],
      ),
    );
  }

  Widget _buildFallPage(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/fall_screen.png', // Replace with your image
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
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.topRight,
                child: _buildBox(
                    "10. LISTOPAD\n Došlo je hladnije vrijeme, a lišće mijenja boje u crvene, narančaste i žute nijanse. Uživanje u specijalitetima od kestena i bundeva.",
                    24),
              ),
              //const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildBox(
                    "11. STUDENI\n Jesen se bliži kraju - dani postaju kraći, a temperature sve niže.",
                    24),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerRight,
                child: _buildBox(
                    "12. PROSINAC\n Krenuo je advent - vrijeme blagdana i darivanja. Odbrojavamo dane do Božića i Nove godine.\n Krajem prosinca kreće zima, a taj isti dan je i najdulji u godini.",
                    24),
              ),
              const SizedBox(height: 44),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: FilledButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xFF9D3D25),
                    ),
                  ),
                  child: const Text(
                    "Provježbaj znanje o jesenskim mjesecima!",
                    style: TextStyle(
                      fontSize: 24, // Set the font size
                      color: Colors.white, // Set the text color
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

  Widget _buildBox(String text, double fontSize) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 200,
        maxWidth: 480,
      ),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent, // Make background fully transparent
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
